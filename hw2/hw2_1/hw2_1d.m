clear; % clean windows
clc; % clean variables

[x, fs] = import_music('sample1.mp3');
%sound(x, fs);
time=(1:length(x))/fs;
p = 5;
len = length(x);
%y = zeros(len, 2);
p_matrix = ones(p, 1);

h = 1/p*p_matrix;

freqz(h)

% import .mp3
function [y, fs] = import_music(path)
    [y, fs] = audioread(path);
end