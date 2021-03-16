clear; % clean windows
clc; % clean variables
len = 217200/4;
fs = 44100;
x = 0.1*randn(len, 1)
alpha = 0.1; % 0 < abs(a) < 1 is constant
%sound(x, fs);

y = filter((1), (1-alpha), x);
sound(y, fs);

%{
alpha = 0.5 sound hear like flatten
alpha = 0.9 sound hear like sharp
alpha = 0.5 sound hear like low
%}