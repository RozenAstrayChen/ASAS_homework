clc
clear

%c
%{
M = 8000;
fs = 16000;
N = 16000
T = 1/fs;
f0 = 1000;
n = (0:1.0:2*M-1);
y = zeros(fs, 1);
% a, b, c
for i=1:2*M-1
    y(i) = y_func(n(i), M, f0, T);
end

%Y = fft(y, length(y));
Y = abs(fft(y));
%f = ((0:1.0:length(y)-1)/N)*fs;
figure
plot(0:fs-1, Y)
%soundsc(y, fs)    
%}

%b
%{
M = 8000;
fs = 16000;
N = 16000
T = 1/fs;
f0 = 2000;
n = 1:N;
y = zeros(fs, 1);
% a, b, c
for i=1:2*M-1
    y(i) = y_func(n(i), M, f0, T);
end

Y = fft(y);
Y = 20 * log10(abs(Y));
f = ((0:1.0:length(y)-1)/N)*fs;
figure
plot(f, Y)
%soundsc(y, fs)    
%}

%a
%{
M = 8000;
fs = 16000;
N = 16000
T = 1/fs;
f0 = 1000;
n = (0:1.0:2*M-1);
y = zeros(fs, 1);
% a, b, c
for i=1:2*M-1
    y(i) = y_func(n(i), M, f0, T);
end

%Y = fft(y, length(y));
Y = abs(fft(y));
%f = ((0:1.0:length(y)-1)/N)*fs;
figure
plot(0:fs-1, Y)
%soundsc(y, fs)    
%}

function out = g_func(n, M)
    if ((-M <= n) && (n <= M))
            out = cos((pi*n)/(2*M))^2;
    else
        out = 0;
    end
end

function y = y_func(n, M, f0, T)

    y = 0.5 * g_func(n-M, M) * sin(2*pi*f0*n*T);
end