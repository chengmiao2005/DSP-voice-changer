function [Y, w, t] = voice_spectrum(y, Fs)
%VOICE_SPECTRUM FFT magnitudes and exact sample/frequency coordinates.
%   The first floor(N/2) FFT bins are returned, preserving the original
%   spectrum-length convention. Magnitudes are not amplitude-normalized.
validateattributes(y, {'numeric'}, {'vector','real','finite','nonempty'}, mfilename, 'y');
validateattributes(Fs, {'numeric'}, {'scalar','real','finite','positive'}, mfilename, 'Fs');
y = double(y(:));
N = numel(y);
if N < 2
    error('voice_changer:TooShort', 'Spectrum input must have at least two samples.');
end
t = (0:N-1)' / Fs;
tnum = floor(N/2);
spectrum = fft(y);
Y = abs(spectrum(1:tnum));
w = (0:tnum-1)' * (Fs/N);
end
