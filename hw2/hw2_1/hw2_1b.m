clear; % clean windows
clc; % clean variables

[x, fs] = import_music('sample1.mp3');
%sound(x, fs);
time=(1:length(x))/fs;
p = 10;
len = length(x);
y = zeros(len, 2);

for n=10:len
    for m=0:p
        y(n, 1) = 1/p*(x(n, 1)+x(n-m+1));
        y(n, 2) = 1/p*(x(n, 2)+x(n-m+1));
    end
end
sound(y, fs);

% import .mp3
function [y, fs] = import_music(path)
    [y, fs] = audioread(path);
end
