% Sinusoidal synthesis
% Revised Nov 2010, Yi-Wen Liu
% Revised Feb 2017 for Flipped classroom preparation.
%
% EE6641: Analysis and synthesis of audio signals
% National Tsing Hua University
% This function should take a list of the amplitude, frequency (amplitude in
% dB and frequency in rad/sample) and intial phase of sinusoidal components
% and calculate a frame of the output signal which is the sum of sinusoidal components.
% 
% Synopsis:
% [s]: the output signal
% phaseUpdate:   the final phase, which will be used as the initial phase 
%               for the next frame
%
% amps: The list of amplitudes of the sinusoids (dB) of the current frame,
%       used here for resolving splits.
% freqs: the list of frequencies of the sinusoids (rad/sample) of the
%       current frame.
% R: length of the synthesis frame (samples)
% initState: the initial state matrix. It has three columns but only the
%       2nd (frequencies of previous frame) and 
%       the 3rd ("phaseUpdate" from the previous frame) are used.
% fs: sampling frequency.
%
% Update May 2020: to handle birth and death

function [s,phaseUpdate] = MyAdditivesynth2020(amps,freqs,R,inistate,fs)
numTracks = size(inistate,1);
phaseUpdate = zeros(numTracks,1);

%% Find nearest peaks
maxJump = 100; % Hz
freqsPrev = inistate(:,2);
prefConn = zeros(numTracks,1); % preferred connection
%mindis = zeros(numTracks,1);
for jj = 1:numTracks
   [md,ii] = min(abs(freqsPrev-freqs(jj))); 
   if md*fs/(2*pi) > maxJump
       phaseUpdate(jj) = 0; % A new track is born.
   else
       prefConn(jj) = ii;
   end
end

%% Resolving splits, and update phase phi() accordingly.
for ii = 1:numTracks
    ind = find(prefConn == ii);
    count = length(ind);
    if count == 1
        winner = ind;
       phaseUpdate(winner) = inistate(ii,3) + ...
            (inistate(ii,2) + freqs(winner))/2*R;
    elseif count > 1
        % find the winner
        ampsComp = amps(ind);
        [~,tmp] = max(ampsComp);
        winner = ind(tmp);
        phaseUpdate(winner) = inistate(ii,3) + ...
            (inistate(ii,2) + freqs(winner))/2*R;
    end
end

s = zeros(2*R,1);
%% Use this double loop to synthesize a frame of the output signal
w=hann(2*R+1); w=w(1:end-1); % synthesis with 50% overlap using Hann (2017)
w=w(:);
mags = 10.^(amps/20);
nn = 0:length(w)-1;
nn = nn(:);
for kk = 1:numTracks
    s = s + mags(kk)*cos(freqs(kk)*nn+phaseUpdate(kk));
end
s = s.*w;

%finalstate(:,2)=freqs;

