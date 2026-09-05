# LPC Voice Changer in MATLAB

A speech-processing course project using linear predictive coding (LPC), pitch-period estimation, and modified excitation to change recorded speech. MATLAB 语音变声项目：LPC 分析、基音周期估计、激励重建与频谱对比。

**Focus:** digital signal processing · speech analysis/synthesis · MATLAB audio

## Processing approach

The implementation uses an LPC order of 10, a 240-sample Hamming window, and an 80-sample frame step. At 8192 Hz, these correspond to approximately 29.3 ms and 9.8 ms. The pitch estimator compares short-lag autocorrelation peaks; resynthesis halves the estimated pitch period and shifts conjugate LPC pole angles by a value corresponding to 150 Hz.

The original function name `lpc_male_to_female` is retained for compatibility. It describes the coursework effect; the repository does not establish naturalness, speaker identity, or gender-classification accuracy.

| File | Purpose |
| --- | --- |
| [voice_demo.m](voice_demo.m) | Standalone microphone/WAV entry point and comparison plots |
| [lpc_male_to_female.m](lpc_male_to_female.m) | Processing function extracted from the original GUI callback |
| [findpitch.m](findpitch.m) | Filtered autocorrelation pitch-period estimate |
| [voice_spectrum.m](voice_spectrum.m) | FFT magnitude and time/frequency coordinates |
| [voice_gui.m](voice_gui.m) | Original GUIDE callback file; its `.fig` layout was not uploaded |

## Run the standalone demo

Requires MATLAB and Signal Processing Toolbox. Make this repository the MATLAB current folder, then choose one input:

```matlab
% Record four seconds and play the processed result.
voice_demo

% Or load your own WAV file (stereo is mixed to mono; input is resampled).
voice_demo('your_recording.wav')

% Return arrays and plots without starting playback.
[processed, original, fs] = voice_demo('your_recording.wav');
```

The demo opens original/processed waveforms and spectra and writes no audio files. `your_recording.wav` is a placeholder for a local file, not a bundled recording. The standalone demo does not require the missing GUIDE layout.

## Scope and verification

This is frame-based processing after recording/loading, not a measured real-time audio stream. The pitch estimator retains a fixed filter normalization from the original code and has no voiced/unvoiced decision. Speech quality, clipping, and robustness require listening tests with real inputs.

The September 2026 maintenance separates the existing processing function from the GUI, adds a standalone entry point and input/silence guards, and corrects spectrum coordinates to actual FFT bins. The original pitch/formant transformation is retained. MATLAB execution and listening tests have not been performed in the maintenance environment; see [validation notes](docs/VALIDATION.md).

[Project portfolio](https://github.com/chengmiao2005/FPGAfinalproject/blob/main/docs/PORTFOLIO.md)
