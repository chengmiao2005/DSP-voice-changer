function [processed, original, fs] = voice_demo(audio_path)
%VOICE_DEMO Run the coursework voice changer without a GUIDE layout file.
%   voice_demo() records four seconds of mono microphone audio.
%   voice_demo('input.wav') loads a WAV file, mixes to mono, and resamples.
%   [processed, original, fs] = voice_demo(...) returns audio without playing.
%   Figures show both waveforms and spectra. No files are written.
%   Requires MATLAB and Signal Processing Toolbox.

fs = 8192;
for name = {'lpc', 'butter', 'hamming', 'resample'}
    if exist(name{1}, 'file') == 0
        error('voice_changer:Dependency', ...
            'Missing %s. Install/enable Signal Processing Toolbox.', name{1});
    end
end
if nargin == 0
    recorder = audiorecorder(fs, 16, 1);
    disp('Recording four seconds. Speak normally.');
    recordblocking(recorder, 4);
    original = getaudiodata(recorder, 'double');
else
    [original, input_fs] = audioread(audio_path);
    original = mean(original, 2);
    if input_fs ~= fs
        original = resample(original, fs, input_fs);
    end
end
processed = lpc_male_to_female(original, fs);
[original_spectrum, frequency, time] = voice_spectrum(original, fs);
[processed_spectrum, ~, ~] = voice_spectrum(processed, fs);
figure('Name', 'LPC Voice Changer', 'NumberTitle', 'off');
subplot(2,2,1); plot(time, original); grid on;
title('Original waveform'); xlabel('Time (s)'); ylabel('Amplitude');
subplot(2,2,2); plot(frequency, original_spectrum); grid on;
title('Original spectrum'); xlabel('Frequency (Hz)'); ylabel('FFT magnitude'); xlim([0 2000]);
subplot(2,2,3); plot(time, processed); grid on;
title('Processed waveform'); xlabel('Time (s)'); ylabel('Amplitude');
subplot(2,2,4); plot(frequency, processed_spectrum); grid on;
title('Processed spectrum'); xlabel('Frequency (Hz)'); ylabel('FFT magnitude'); xlim([0 2000]);
if nargout == 0
    sound(processed, fs);
end
end
