% Quadratic interpolation for sinusoidal analysis
% Revised Nov 2010, Yi-Wen Liu
% Last updated May 2020
%
% EE6641: Analysis and synthesis of audio signals
% National Tsing Hua University
% 
% This function looks at FFT spectrum X, finds up to MAXNUMPEAKS 
% **highest** peaks and returns a MAXNUMPEAKS by an array called PEAKS.
% The first column of PEAKS is a list of amplitudes (dB-scale) and 
% the second column of PEAKS describes locations with N 
% the third column of PEAKS contains the corresponding phase.
%
% May 2020: Now the peaks will be at least minSep (Hz) apart.
%
function peaks = MyFindpeaks2020(X, maxNumPeaks, fNyq)
minSep = 80; % Hz

M=size(X(:),1);
D = floor(minSep/(fNyq/M)); % Minimum separation of peaks by bins
data = 20*log10(abs(X));
data=data(:);
ind=find( (data>[data(1)-100;data((1:M-1)')]) ...
    & (data>=[data((2:M)'); data(M)-100]) );   %find the location of peaks
peaks=zeros(maxNumPeaks,3);
peaks_happen=[data(ind),ind]; % Two columns
peaks_low2high=sortrows(peaks_happen,1); % Two columns
i=length(ind);
if ~isempty(ind)
    % Removing peaks that are too close
    for j = i:-1:2
        peakLoc = peaks_low2high(j,2);
        if peakLoc > 0
            for k = j-1:-1:1
                smallerPeakLoc = peaks_low2high(k,2);
                if (smallerPeakLoc > 0) & (abs(peakLoc - smallerPeakLoc) <= D)
                    peaks_low2high(k,2) = 0; % mark the row to be removed
                end
            end
        end
    end
    peaks_low2high = peaks_low2high(peaks_low2high(:,2)>1,:);
            % set loc > 1 to avoid wasting a peak at DC. YWL 2020-5-06.
    i = size(peaks_low2high,1);
    for j=1:min([maxNumPeaks i]) % Bug fixed by YWL 2014-4-10
        k=peaks_low2high(i+1-j,2);%...maxpeaks location
        L0=peaks_low2high(i+1-j,1);
        if L0==data(M)
            A=(L0-2*data(k-1)+data(k-2))/2;
            B=A*(1-2*k)+L0-data(k-1);
        elseif L0==data(1)
            A=(data(k+2)-2*data(k+1)+L0)/2;
            B=(data(k+1)-L0)-(1+2*k)*A;
        else
            A=(data(k-1)+data(k+1)-2*L0)/2;
            B=(data(k-1)-data(k+1)-4*A*k)/2;
        end
        C=L0-A*k^2-B*k;
        peaks(j,2) = -B/(2*A);
        peaks(j,1) = C-(B^2)/(4*A);
            % YWL Remark: This part of calculating A, B, and C was implemented 
            % by a student and is obviously not the most efficient. 
        peaks(j,3)= angle(X(k));
    end
end

%% Return the list of amps and freqs in the order of ascending frequency
peaks(:,2) = (peaks(:,2)-1)*pi/M;
peaks = sortrows(peaks,2);	

% sorting in ascending frequency. 


