%% EE6641 HW: sinusoidal modeling, additive synthesis
% Adapted from a Stanford EE367 lab assignment in 2002.
% Revised Apr 10, 2014
% Revised Feb 21, 2017
% Touched Apr 21, 2020 for the year's HW5.
% Updated May 5, 2020 for S+N decomposition for HW7.
% Yi-Wen Liu

clear; close all;
DIR = './8LPC20sinesFR40/';
sw.WriteOut = 1;
%fname = 'peaches_16';
%fname = 'mymom_16';
fname = 'draw_16';
%fname = 'ASAS-6.6.1-wrenpn';
[x,fs] = audioread([DIR fname '.wav']);
sound(x,fs);
nx = length(x);

%% ANALYSIS PARAMETERS
frameRate =40;  % frames per second
M = floor(fs/frameRate);  
nFrames = floor(nx/M)*2-1;
R = floor(M/2);  % Note: exact COLA not required
N = 2^(1+floor(log2(5*M+1))); % FFT length, at least a factor of 5 zero-padding

maxPeaks = input('how many peaks to track? '); 
expandRatio = input('time expansion factor?'); % Default = 1.0
freqShift = 0;
fRatio = 2^(freqShift/12); 

%% VECTOR VARIABLES DECLARATION
amps = zeros(maxPeaks,nFrames);
freqs = zeros(maxPeaks,nFrames);
phases = zeros(maxPeaks,nFrames);

%% ANALYSIS
%
w = blackman(M);
w2 = hann(M+1); w2 = w2(1:end-1); w2 = w2(:); % for noise synthesis
df = fs/N;
ff = 0:df:(N-1)*df;
fNyq = fs/2;
normfac = sum(w)/2;
x_noise = zeros((nFrames+1)*R,1);

for m=1:nFrames
    tt = (m-1)*R+1:(m-1)*R+M;
    xw = w .* x(tt);
    Xw = fft(xw,N); 
    thePeaks = MyFindpeaks2020(Xw(1:N/2),maxPeaks,fNyq); 
            
    thePeaks = sortrows(thePeaks,2);
    amps(:,m) = thePeaks(:,1); % amplitude is coded in dB unit
    freqs(:,m) = thePeaks(:,2); % pi = Nyquist frequency here.
    phases(:,m) = thePeaks(:,3); % in rad. Will be used for Sine plus noise decomposition.
    
    %% Sine + noise decomposition
    sinesum = zeros(M,1);
    % IMPLEMENT "single-frame synthesis" here. store the result as sinesum.
    % ...
    % ...
    % ...
    x_noise(tt) = x_noise(tt) + (x(tt) - sinesum).*w2; % using the Hann for synthesis.
    
    if 1, % Debug mode. If done correctly, sinesum should be quite close to x(tt).
        figure(2);
        plot(x(tt)); hold on;
        plot(sinesum); hold off;
    end
end

sound(x_noise,fs);

%% LP coding of the noise part.
sw.emphasis = 1;
p = 8;

LPcoeffs = zeros(p+1,nFrames);
Nfreqs = 2^nextpow2(2*M-1)/2;

noiseResynth = zeros(size(x_noise));

if sw.emphasis == 1
    yemph = filter([1 -0.95],1,x_noise); 
                %[PARAM] -0.95 may be tuned anywhere from 0.9 to 0.99
else
    yemph = x_noise;
end
for kk = 1:nFrames
    ind = (kk-1)*R+1:(kk-1)*R+M;
    ywin = yemph(ind);
    A = lpc(ywin,p);
    LPcoeffs(:,kk) = A;
    sigma = 0;
    % IMPLEMENT excitation replacement by Gaussian white noise of suitable
    % variance. You need to determine sigma
    % ...
    % ...
    % ...
    % ... 
    excit = sigma * randn(p+M,1);
    tmp = filter(1, A, excit);
    noiseResynth(ind) = noiseResynth(ind) + w2.* tmp(p+1:end); 
        % Lengthen "excit" to p+M and only take the last M samples of tmp. 
        % This is a trick to reduce frame-rate artifacts when running
        % a time-varying IIR filter.
end

%% A synthesizer using MyAdditivesynth2020.m
R = round(R* expandRatio);  % time expansion
y = zeros((nFrames+1)*R,1);
state = zeros(maxPeaks,3);  % [ampInitials, freqInitials, phaseInitials]
        % YWL Remark: in windowing implementation, ampInitials are not
        % used (2020-5-06).

for m=2:nFrames-1
    state(:,2) = freqs(:,m-1);  % bug fixed May 2020. "m-1" used to be "m".
    tt = (m-1)*R+1: (m+1)*R;  
    [y_synth,phaseUpdate] = MyAdditivesynth2020(amps(:,m),freqs(:,m),R,state,fs);
	y(tt)= y(tt) + y_synth;
    state(:,3) = phaseUpdate; % from previous round of synthesis.

end

y = y/max(abs(y)); 
sound(y,fs);

if sw.WriteOut
    audiowrite(sprintf('%sSine_%d.wav',fname,maxPeaks),y,fs);
    audiowrite(sprintf('%sNoise_%d.wav',fname,maxPeaks),x_noise,fs);
    audiowrite(sprintf('%sNsynth_%d.wav',fname,maxPeaks),noiseResynth,fs);
    audiowrite(sprintf('%sTotSynth_%d.wav',fname,maxPeaks),y+noiseResynth,fs);
end



%% Visualization
figure(1)
param.fs = fs;
S = mySpecgram(x,w,M*3/4,N,param); 
    % mySpecgram() is YWL's preferred way of seeing a spectrogram.
hold on;
yLIM = get(gca,'ylim');
ymax = yLIM(2);
plot((0:nFrames-1)*R/fs,freqs'/pi*ymax,'.','color','g');
set(gcf,'position',[360,80,800,600])

figure(3)
S = mySpecgram(x_noise,w,M*3/4,N,param); 
set(gcf,'position',[400,120,800,600]); title('noise spectrogram');

figure(4)
plot((0:length(x)-1)/fs, x); hold on;
plot((0:length(x_noise)-1)/fs, x_noise);

figure(5)
subplot(211); plot((0:length(x_noise)-1)/fs, x_noise);
xlabel('time (s)'); ylabel('the noise part');
subplot(212); plot((0:length(x_noise)-1)/fs, noiseResynth);
xlabel('time (s)'); ylabel('synthesized noise part');


setFontSizeForAll(14);


