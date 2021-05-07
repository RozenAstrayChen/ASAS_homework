function [amps,freqs,phases]=FindPeaksWithinFrame(X, maxPeakNum)
%FINDPEAKSWITHINFRAME find the loudest-N peaks in the spectrum 
%   if peaks found less than maxPeakNum, the residuary part
%   is set to zero-ampilitude/minus-inf-magnitude

N=size(X(:),1)/2+1;
X=2*X(1:N);               % extract under fs/2 and preserve energy

pha = unwrap(angle(X));
magn = 20*log10(abs(X));

idx = find( ...         % find peaks/local maximum
    (magn>[magn(1);magn((1:N-1)')]) ...
    & ...
    (magn>[magn((2:N)'); magn(N)]) ...
    );

peakNum = min(length(idx),maxPeakNum);

maxes = [magn(idx), idx, pha(idx)];
maxes = sortrows(maxes, 'descend');
maxes = maxes(1:peakNum, :);       % first max-n peaks

%% Implement quadratic interpolation
peaks = zeros(maxPeakNum, 3);
peaks(:, 1) = -Inf;                 % initialize unaudible peaks

for peakIdx=1:peakNum
    
    maxIdx = maxes(peakIdx, 2);    % indexes of maximum
    A = magn(maxIdx-1:maxIdx+1);   % amplitudes around maximum
    P = pha(maxIdx-1:maxIdx+1);    % phases around maximum
    
    % quadratic amplitude interpolation
    amp = A(2) - (A(1)-A(3))^2 / (8*(A(1)+A(3)-2*A(2)));
    freq = (A(3) - A(1)) / (2*(2*A(2)-A(1)-A(3))) + maxIdx;
    
    % linear phase interpolation
    if freq<maxIdx, k = (P(2)-P(1));
    else, k = (P(3)-P(2));end
    phase = pha(maxIdx) + k*(freq-maxIdx);

    peaks(peakIdx, :) = [amp, freq, phase];
    
end

%% Return the list of amps and freqs in the order of ascending frequency
peaks = sortrows(peaks, 2); 	% sorting in ascending frequency
amps = peaks(:,1);              % dB
freqs= (peaks(:,2)-1)/(N-1)*pi; % rad/sample
phases= peaks(:,3);             % rad

end