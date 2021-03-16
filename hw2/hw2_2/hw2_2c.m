clear; % clean windows
clc; % clean variables

[x, fs] = import_music('sample1.mp3');
%sound(x, fs);
time=(1:length(x))/fs;

len = length(x);
y = zeros(len, 1);
for n=1:len
    if mod(n, 80) == 0
        y(n) = 0.5;
    else
        y(n) = 0;
    end
end

%sound(y, fs);

% after filter
alpha = 0.9; % 0 < abs(a) < 1 is constant
yy = filter((1), (1-alpha), y);
sound(yy, fs);

% import .mp3
function [y, fs] = import_music(path)
    [y, fs] = audioread(path);
end