clear; % clean windows
clc; % clean variables

[x, fs] = import_music('sample1.mp3');
%sound(x, fs);
time=(1:length(x))/fs;
p = 5;
len = length(x);
y = zeros(len, 2);
for n=2:len
    y(n, 1) = x(n, 1)-x(n-1);
    y(n, 2) = x(n, 2)-x(n-1);
end
sound(y, fs);

% import .mp3
function [y, fs] = import_music(path)
    [y, fs] = audioread(path);
end