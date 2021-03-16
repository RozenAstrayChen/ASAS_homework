len = 217200/4
% gaussian white noise
%sigma = 0.1
%mu = 0
fs = 44100
x = 0.1*randn(len, 1)
% origin gaussian white nosie
%sound(x, fs);

% after averaging/differencing
p = 10;
%y = zeros(len, 2);
p_matrix = ones(p, 1);
y_conv = conv2(x, 1/p*p_matrix);
sound(y_conv, fs);