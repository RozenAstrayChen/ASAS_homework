% note
clear; % clean windows
clc; % clean variables

[y, fs] = import_music('sample1.mp3');
info_music('sample1.mp3');
%sound(y, fs);
time=(1:length(y))/fs;
plot(time, y)
fprintf("sampling rate is %d", fs)

% import .mp3
function [y, fs] = import_music(path)
    [y, fs] = audioread(path);
end

function info_music(path)
    info = audioinfo(path);
    fprintf('Number of channel = %g 個\n', info.NumChannels);
    fprintf('sampling rate = %g Hz\n', info.SampleRate);
    fprintf('Total number of sampling points = %g 個\n', info.TotalSamples);
end
