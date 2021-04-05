% 各種ノイズを作る関数

function output_noise = f_mk_noise(data_length, Fs, alpha)

rand('state',sum(100*clock));   % 状態をリセットする

% 周波数領域で1/sqrt(freq)のフィルタをかけるとピンクノイズになる
% これを少し拡張し，1/freq^alpha for alpha = (0,1)をpinknoiseと定義する
% つまり一般的に言うpinknoiseはalpha = 0.5，whiteは0，redは1になる

% alpha = 0.5;

if mod(data_length, 2) ~= 0
    disp('Increased one length of data, because "data_length" is ODD');
    data_length = data_length + 1;
end

freq(:,1) = Fs/data_length:Fs/data_length:Fs/2;
F_temp(:,1) = ones(data_length/2,1)./freq.^alpha; % 実数領域のフィルタ形状の定義
  % フィルタ形状の定義
%tetsu 加筆
F_temp(find(freq(:,1)<20))=F_temp(find(max(freq(freq(:,1)<20,1))==freq(:,1)));

%
F = [F_temp;flipud(F_temp)];

output_noise = -1 + 2.*rand(data_length,1);

OUTPUT_NOISE = fft(output_noise);           % ノイズの時間情報を周波数情報に変換
OUTPUT_NOISE = OUTPUT_NOISE .* F;           % フィルタリング
output_noise = real(ifft(OUTPUT_NOISE));    % 周波数情報を時間情報に変換

% バイアス成分除去
output_noise = output_noise - mean(output_noise);
% % 最初と最後に窓かけ
win_len = Fs*0.1; % 0.1sの窓をかける
win_index = [0:2*win_len]; % 0...1...0 の窓なので，総インデックス数は奇数
win_parts(:,1) = sin(pi*win_index/(2*win_len)); % あくまでこの窓はテンポラリ
win_all = [win_parts(1:win_len+1);ones(data_length - 2*(win_len + 1),1);win_parts(win_len+1:2*win_len+1)];
output_noise = output_noise .* win_all;

% -1～1に正規化
output_noise = output_noise/max(abs(output_noise));
