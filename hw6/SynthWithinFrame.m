function y = SynthWithinFrame(amp, freq, pha, N)
%SYNTHWITHINFRAME resynthesize the audio in a single frame
%   use PHA as the reference of the phase of the center of the frame
%	AMP amplitude of sinusoids in dB
%	FREQ frequency of sinusoids in rad/sample
%	PHA phase of sinusoidsin rad
%   N the frame length in samples

amp = 10.^(amp/20);

leftHalf = floor(N/2);
startPha = pha - (leftHalf+1)*freq;
phas = startPha + freq.*(1:N);

y = sum(amp.*cos(phas), 1);       % sum all trajectories

end