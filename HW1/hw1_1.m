%abc
%{
M = 8000;
fs = 16000;
T = 1/fs;
f0 = 1000;
n = (0:1.0:2*M-1);
y = zeros(fs, 1);
% a, b, c
for i=1:2*M-1
    y(i) = y_func(n(i), M, f0, T, 0, 1);
end
plot(n, y);
%soundsc(y, fs)    
%}

%d
%{
M = 8000;
fs = 16000;
T = 1/fs;
f0 = 2000;
n = (0:1.0:2*M-1);
% d
y = zeros(fs, 1);
for i=1:2*M-1
    y(i) = y_func(n(i), M, f0, T, 1, 0);
end
plot(n, y);
soundsc(y, fs)

%}

%e

%{
M = 8000;
fs = 16000;
T = 1/fs;
f0 = 2000;
n = (0:1.0:2*M-1);
% d
y = zeros(fs, 1);
for i=1:2*M-1
    y(i) = y_func(n(i), M, f0, T, 0, 1);
end
plot(n, y);
soundsc(y, fs)
%}

function out = g_func(n, M, g_type)
    if ((-M <= n) && (n <= M))
        if g_type == 0
            out = cos((pi*n)/(2*M))^2;
        else
            out = 1;
        end
    else
        out = 0;
    end
end

function y = y_func(n, M, f0, T, y_type, g_type)
    if y_type == 0
        y = 0.5 * g_func(n-M, M, g_type) * sin(2*pi*f0*n*T);
    else
        y = 0.5 * g_func(n-M, M, g_type) * cos(2*pi*f0*n*T);
    end
end

