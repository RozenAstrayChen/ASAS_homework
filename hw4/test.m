Fs=800;         %sample frequence
N=800;          %FFT sample point
Ts=1/Fs;        %Time sample intervall
L=800*Ts;       %Signal length
t=0:Ts:L;       %t 从0到L间隔为Ts

%*****************signal generation*****************************%
x=2*sin(2*pi*52.8*t)+0.1*sin(2*pi*61.1*t)+0.8*cos(2*pi*51.1*t);%+0.5*randn(size(t));%signal

%***************** FFT spectrum generation**********************%
w =hann(length(x));             %generate window
P1=FFT_spectrum_generate(x,N);       %FFT without window
P2=FFT_spectrum_generate(x.*w',N);   %FFT with window
xk=0:Fs/N:Fs/2;                      %Frequency bin

%************************** begin plot**************************%
subplot(2,2,1);
plot(t,x);
xlabel('Millisecond');
ylabel('Amplitude');
title('Signal');
grid on

subplot(2,2,2); 
plot(xk(1:100),P1(1:100));
xlabel('Frequency');
ylabel('|P|');
title('Signal after FFT');
grid on

subplot(2,2,3);
plot(t,w'.*x,t,w);
legend('Signal','Window');
xlabel('Millisecond');
ylabel('Amplitude');
title('Signal with Hamming window');
grid on

subplot(2,2,4);
plot(xk(1:100),P2(1:100));
xlabel('Frequency');
ylabel('|P|');
title('FFT with Hamming window');
grid on

%********************* define Function ***************************%
function P=FFT_spectrum_generate(x,N)
   Y=fft(x,N);
   P1=abs(Y/N); 
   P = P1(1:N/2+1);
   P(2:end-1) = 2*P(2:end-1);
end