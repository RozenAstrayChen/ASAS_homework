%% EE6641 HW: sinusoidal modeling, additive synthesis
% Adapted from a Stanford EE367 lab assignment in 2002.
% Revised Apr 10, 2014
% Revised Feb 21, 2017
% Touched Apr 21, 2020 for the year's HW5. Re-used in 2021.
%
% Yi-Wen Liu

clear; close all;
DIR = './soundfiles/';
sw.WriteOut = 0; % switch on to save the audio out to a file.
%fname = 'peaches_16';
%fname = 'mymom_16';
fname = 'draw_16';
%fname = 'ASAS-6.6.1-wrenpn';
[x,fs] = audioread([DIR fname '.wav']);
sound(x,fs);
nx = length(x);

%% ANALYSIS PARAMETERS
frameRate =20;  % frames per second
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

%% ANALYSIS
%
%w = hanning(M); % Note: Here you can choose the type of window.
w = blackman(M);
df = fs/N;
ff = 0:df:(N-1)*df;
fNyq = fs/2;
for m=1:nFrames
    tt = (m-1)*R+1:(m-1)*R+M;
    xw = w .* x(tt);
    Xw = fft(xw,N); 
    %thePeaks = MyFindpeaks2020(Xw(1:N/2),maxPeaks,fNyq); 
    thePeaks = MyFindpeaks(Xw(1:N/2),maxPeaks, N); 
    %X = Xw(1:N/2);
    %maxNumPeaks = maxPeaks;
    
    
    %thePeaks = thePeaks';
    amps(:,m) = thePeaks(:,1); % amplitude is coded in dB unit
    freqs(:,m) = thePeaks(:,2); % pi = Nyquist frequency here.
end


%% Visualization of peaks on the spectrogram.
% Apr 22, 2020.
figure(1)
param.fs = fs;
S = mySpecgram(x,w,M*3/4,N,param); 
    % mySpecgram() is YWL's preferred way of seeing a spectrogram.
hold on;
yLIM = get(gca,'ylim');
ymax = yLIM(2);
plot((0:nFrames-1)*R/fs,freqs'/pi*ymax,'.','color','g');
set(gcf,'position',[360,80,800,600])


%% A baseline synthesizer. You will be asked to do better in HW6.
R = round(R* expandRatio);  % time expansion
freqs = min(pi,freqs*fRatio);
y = zeros((nFrames+1)*R,1);
state = zeros(maxPeaks,3);  % [ampInitials, freqInitials, phaseInitials] 
state(:,2) = freqs(:,m);

for m=1:nFrames-1
    tt = (m-1)*R+1 : (m+1)*R;  
    [y_synth,state] = MyAdditivesynth(amps(:,m),freqs(:,m),R,state);
	y(tt)= y(tt) + y_synth;
end

setFontSizeForAll(14);

y = y/max(abs(y)); 
sound(y,fs);

if sw.WriteOut
    audiowrite(sprintf('%s_SM_%d.wav',fname,maxPeaks),y,fs);
end
