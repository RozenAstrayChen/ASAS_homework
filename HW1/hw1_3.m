%a
%{
M = 8000;
fs = 16000;
N = 16000;
T = 1/fs;
f0 = 2000;
n = 1:N;
y = zeros(fs, 1);
for i=1:2*M-1
    y(i) = y_func(n(i), M, f0, T);
end
h_size = 320;
window = hanning(h_size); % appropriate window function w[n]
w = 0:0.1:pi; %[0, pi]
w = reshape(w, [32,1]);
Y = zeros(fs,length(w));

for n = 1:N
    for m = n:min(n+h_size-1, fs)
        Y(n, :) = Y(n, :) + (y(m)*window(m-n+1).*exp(-j*w*m)).';
    end
end

figure(1);
%s = spectrogram(y);

spectrogram(y, w, 'yaxis');

figure(2)
imagesc(abs(Y));
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