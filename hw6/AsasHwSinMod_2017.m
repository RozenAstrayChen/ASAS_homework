%% EE6641 HW: sinusoidal modeling, additive synthesis
% Adapted from a Stanford EE367 lab assignment in 2002.
% Revised Apr 10, 2014
% Revised Feb 21, 2017
% Touched Apr 21, 2020 for the year's HW5. Re-used in 2021.
%
% Yi-Wen Liu

clear; close all;
DIR = './soundfiles/';
sw.WriteOut = 1; % switch on to save the audio out to a file.
fname = 'peaches_16';
%fname = 'mymom_16';
%fname = 'draw_16';
%fname = 'ASAS-6.6.1-wrenpn';
[x,fs] = audioread([DIR fname '.wav']);
%sound(x,fs);


%% ANALYSIS PARAMETERS
nx = length(x);
samPerFra = 512;                            % samples per frame
hopSize = 0.5;                              % hop samples / sample per frame
hopSamples = floor((samPerFra+1) * hopSize);
frameRate =20;  % frames per second
M = floor(fs/frameRate);  
%nFrames = floor(nx/M)*2-1; % 135
nFrames = ceil((nx-samPerFra)/hopSamples)+1; % to 212
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
w = blackman(samPerFra);
%w = hanning(samPerFra); % Note: Here you can choose the type of window.
% zero-padding
xz = zeros((nFrames-1)*hopSamples + samPerFra, 1);
xz(1:nx) = x;

for m=1:nFrames
    %tt = (m-1)*R+1:(m-1)*R+M;
    tt = 1:samPerFra;
    xFrame = zeros(N, 1);
    xFrame(tt) = xz((m-1)*hopSamples + tt);
    xFrame(tt) = xFrame(tt) .* w;
    %linear phase to zero phase
    xFrame = [xFrame(floor(samPerFra/2)+1:end);
        xFrame(1:floor(samPerFra/2))];     
    X = fft(xFrame, N); 
    %X = fft(xz((m-1)*hopSamples + tt) .*w, N);
    %thePeaks = MyFindpeaks(Xw(1:N/2),maxPeaks, N); 
    
    %use other one findpeaks
    [find_amps,find_freqs,find_phases] =FindPeaksWithinFrame(X, maxPeaks);
    
    
    %thePeaks = thePeaks';
    amps(:, m) = find_amps(:); % amplitude is coded in dB unit
    freqs(:, m) = find_freqs(:);
    phases(:, m) = find_phases(:);
    
end


%% Visualization of peaks on the spectrogram.
% Apr 22, 2020.
%{
figure(1)
param.fs = fs;
S = mySpecgram(x,w,samPerFra*3/4,N,param); 
    % mySpecgram() is YWL's preferred way of seeing a spectrogram.
hold on;
yLIM = get(gca,'ylim');
ymax = yLIM(2);
plot((0:nFrames-1)*R/fs,freqs'/pi*ymax,'.','color','g');
set(gcf,'position',[360,80,800,600])
%}
% trajectory formation

plot(fs/(2*pi)*freqs', '.');

%% A baseline synthesizer. You will be asked to do better in HW6.
%R = round(R* expandRatio);  % time expansion
%{
% prof provide code
y = zeros((nFrames+1)*R,1);
state = zeros(maxPeaks,3);  % [ampInitials, freqInitials, phaseInitials] 
state(:,2) = freqs(:,m);
for m=1:nFrames
    tt = (m-1)*R+1 : (m+1)*R;  
    [y_synth,state] = MyAdditivesynth(amps(:,m),freqs(:,m),R,state);
	y(tt)= y(tt) + y_synth;
end
%}

% my method audio modification
freqs(:) = min(fRatio * freqs(:), pi);
samPerFra = samPerFra * expandRatio;
hopSamples = hopSamples * expandRatio;

% y need overlap add so length should longer than origin y
y = zeros((nFrames-1)*hopSamples + samPerFra, 1);
w = hann(samPerFra);

for m=1:nFrames
    tt = 1:samPerFra;
    
    yFrame = SynthWithinFrame(amps(:, m), freqs(:, m), phases(:, m), samPerFra);
    % Overlap-add
    y((m-1)*hopSamples+tt) = y((m-1)*hopSamples+tt) + yFrame'.*w;
end

setFontSizeForAll(14);

y = y/max(abs(y)); 
sound(y,fs);

if sw.WriteOut
    audiowrite(sprintf('%s_SM_%d.wav',fname,maxPeaks),y,fs);
end
