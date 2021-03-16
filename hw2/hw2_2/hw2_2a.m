clear; % clean windows
clc; % clean variables

[x, fs] = import_music('sample1.mp3');
%sound(x, fs);
time=(1:length(x))/fs;

len = length(x);
y = zeros(len, 2);
alpha = 0.9; % 0 < abs(a) < 1 is constant
for n=2:len
    y(n, 1) = alpha*y(n-1, 1)+x(n, 1);
    y(n, 2) = alpha*y(n-1, 2)+x(n, 2);
end
%sound(y, fs);

y = filter((1), (1-alpha), x);
sound(y, fs);

% import .mp3
function [y, fs] = import_music(path)
    [y, fs] = audioread(path);
end