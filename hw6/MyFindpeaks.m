% Quadratic interpolation for sinusoidal analysis
% Revised Nov 2010, Yi-Wen Liu
% Last updated March 2017
%
% EE6641: Analysis and synthesis of audio signals
% National Tsing Hua University
% 
% This function should look at FFT spectrum X, finds up to MAXNUMPEAKS 
% **highest** peaks and returns a MAXNUMPEAKS by 2 array called PEAKS.
% The first column of PEAKS is a list of amplitudes (dB-scale) and 
% the second comlumn of PEAKS describes locations with N 
function peaks = MyFindpeaks(X, maxNumPeaks, N)
    % returns an array of size maxPeaks * 2 that describes a list of largest peaks
    peaks = zeros(maxNumPeaks,2);
    mag = 20*log10(abs(X)); % magnitude spectrum in dB
    
    [pks, locs] = findpeaks(mag, 'sortstr', 'descend');
    %k_pks = maxk([pks, locs], maxNumPeaks, 1);
    peaks(:,1) = pks(1:maxNumPeaks);
    
    peaks(:,2) = locs(1:maxNumPeaks);
    peaks(:, 2) = (peaks(:, 2)*2*pi)/N;
    
    %% Return the list of amps and freqs in the order of ascending frequency
    peaks = sortrows(peaks,2);	

    return 




