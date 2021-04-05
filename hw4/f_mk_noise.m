% �e��m�C�Y�����֐�

function output_noise = f_mk_noise(data_length, Fs, alpha)

rand('state',sum(100*clock));   % ��Ԃ����Z�b�g����

% ���g���̈��1/sqrt(freq)�̃t�B���^��������ƃs���N�m�C�Y�ɂȂ�
% ����������g�����C1/freq^alpha for alpha = (0,1)��pinknoise�ƒ�`����
% �܂��ʓI�Ɍ���pinknoise��alpha = 0.5�Cwhite��0�Cred��1�ɂȂ�

% alpha = 0.5;

if mod(data_length, 2) ~= 0
    disp('Increased one length of data, because "data_length" is ODD');
    data_length = data_length + 1;
end

freq(:,1) = Fs/data_length:Fs/data_length:Fs/2;
F_temp(:,1) = ones(data_length/2,1)./freq.^alpha; % �����̈�̃t�B���^�`��̒�`
  % �t�B���^�`��̒�`
%tetsu ���M
F_temp(find(freq(:,1)<20))=F_temp(find(max(freq(freq(:,1)<20,1))==freq(:,1)));

%
F = [F_temp;flipud(F_temp)];

output_noise = -1 + 2.*rand(data_length,1);

OUTPUT_NOISE = fft(output_noise);           % �m�C�Y�̎��ԏ������g�����ɕϊ�
OUTPUT_NOISE = OUTPUT_NOISE .* F;           % �t�B���^�����O
output_noise = real(ifft(OUTPUT_NOISE));    % ���g���������ԏ��ɕϊ�

% �o�C�A�X��������
output_noise = output_noise - mean(output_noise);
% % �ŏ��ƍŌ�ɑ�����
win_len = Fs*0.1; % 0.1s�̑���������
win_index = [0:2*win_len]; % 0...1...0 �̑��Ȃ̂ŁC���C���f�b�N�X���͊
win_parts(:,1) = sin(pi*win_index/(2*win_len)); % �����܂ł��̑��̓e���|����
win_all = [win_parts(1:win_len+1);ones(data_length - 2*(win_len + 1),1);win_parts(win_len+1:2*win_len+1)];
output_noise = output_noise .* win_all;

% -1�`1�ɐ��K��
output_noise = output_noise/max(abs(output_noise));
