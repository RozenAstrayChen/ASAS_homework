hw1_2a()

function hw1_2a()
    M = 8000;
    fs = 16000;
    N = 16000
    T = 1/fs;
    f0 = 2000;
    n = (0:1.0:2*M-1);
    y = zeros(fs, 1);
    % a, b, c
    for i=1:2*M-1
        y(i) = y_func(n(i), M, f0, T, 0, 0);
    end
    
    Y = fft(y, length(y));
    Y = 20 * log10(abs(Y));
    f = (0:1.0:length(y))/N
    %soundsc(y, fs)    
end

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