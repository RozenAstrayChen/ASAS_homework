clear; % clean windows
clc; % clean variables

[x, fs] = import_music('sample1.mp3');
%sound(x, fs);
time=(1:length(x))/fs;
p = 5;
len = length(x);
%y = zeros(len, 2);
p_matrix = ones(p, 1);
%{
for n=10:len
    for m=0:p
        y(n, 1) = 1/p*(x(n, 1)+x(n-m+1));
        y(n, 2) = 1/p*(x(n, 2)+x(n-m+1));
    end
end
%}
y_conv = conv2(x, 1/p*p_matrix);
sound(y_conv, fs);

% import .mp3
function [y, fs] = import_music(path)
    [y, fs] = audioread(path);
end