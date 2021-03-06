% NTHU EE6641: Analysis and Synthesis of Digital Audio Signals 
% HW4: Part I HRTF demo and starter code.
%
% These Head-related Impulse Responses were measured at Tohoku University's
% Suzuki Lab in 2013.
%
% 3/29/2021
% Yi-Wen Liu
clear;
close all

subject = 'liu';
elevselect = '0'; % You may choose -80:10:90 (i.e. -80 to 90 in steps of 10 degrees)
azimselect= [];

%a = azimuth (0:5:355)

if isempty(elevselect)
    elevselect = input('Select the elevation which you would like to show -> ', 's');
end

if isempty(azimselect)
    azimselect = input('Select the azimuth (0:5:355) -> ', 's');
end

elev = str2double(elevselect);
azim = str2double(azimselect); 
hrirdir = sprintf('./%s/elev%d/',subject,elev);

lhrir = zeros(512,1);
rhrir = zeros(512,1);


%{
Left sounds
%}
hrirname = sprintf('%s/L%de%03da.dat',hrirdir,elev,azim);
fid = fopen(hrirname,'r','b');
lhrir = fread(fid,'float');
fclose(fid);
%{
Right sounds
%}
if azim==0 % Originally provided by colleagues at Tohoku. This is probably due to
    % their file-naming convention. Do not change.
    hrirname = sprintf('%s/R%de%03da.dat',hrirdir,elev,azim);
else
    hrirname = sprintf('%s/R%de%03da.dat',hrirdir,elev,360-azim);
end
fid = fopen(hrirname,'r','b');
rhrir = fread(fid,'float');
fclose(fid);


noise = f_mk_noise(48000*2, 48000, 0.5); 
    % routine f_mk_noise() creates an instance of colored noise
noise = noise.*0.25;

l=conv(noise,lhrir);
r=conv(noise,rhrir);

%%%
y = zeros(length(l), 2);
L = 2048; %block length
filter_len = length(lhrir);
Fs = 48000;
framelen = 0.032;
numFrames = floor(length(noise)/L); % frame rate
% window
win_rec = ones(L,1);
win_hann = hann(L+1);
win_hann = win_hann(1:end-1);
%% HW4 implementation
% Please implement overlap add using 1) the rectangular window and 
% 2) the Hann window. Make sure that the hope size is chosen correctly so
% contant overlap-add is achieved before even doing FIR filtering. Then,
% try zeropadding the left and right HRIR (lhrir, rhrir) to an appropriate
% length (needs to be long enough) and transform them to the frequency domain.
% Save the result as LHRIR and RHRIR, respectively. Now, for each
% windowed block, calculate the FFT, and multiply it with LHRIR and
% RHRIR at every frequency. Take the result back to the time domain by
% ifft. Then hop and overlap appropriately to complete filtering. The0
% result should be identical to simply using conv(). The results need to be
% completely free of any frame-rate artifact.

%so=[l r];
%sound(so,48000);
for kk = 1:numFrames % frame index
    ind = (kk-1)*L+1:kk*L;
    x_win = noise(ind).*win_rec;
    % choice N_fft = 2048+512-1=2559
    
    x_fft = fft(x_win);
    lh_fft = fft(lhrir);
    rh_fft = fft(rhrir);
    
    lY = conv(x_fft, lh_fft);
    rY = conv(x_fft, rh_fft);
    % inverse FFT
    inverse_lY = ifft(lY);
    inverse_rY = ifft(rY);
    y(ind(1):ind(end), 1) = real(inverse_lY(1:L));
    y(ind(1):ind(end), 2) = real(inverse_rY(1:L));
end

sound(y,48000);

%%