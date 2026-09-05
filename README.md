# LPC Voice Changer in MATLAB

A MATLAB speech-processing project based on linear predictive coding (LPC), pitch-period estimation, and modified resynthesis.

**Technologies:** MATLAB · Digital Signal Processing · LPC · Speech Analysis/Synthesis

## Project Overview

The project processes recorded speech frame by frame. It estimates speech parameters, modifies pitch-related characteristics, and reconstructs the signal to create a voice-changing effect.

## Processing Pipeline

- LPC analysis with a 10th-order model.
- Hamming-windowed frame processing with overlap.
- Autocorrelation-based pitch-period estimation.
- Modified excitation and LPC pole-angle adjustment during resynthesis.
- Original/processed waveform and spectrum visualization.
- Standalone microphone/WAV entry point for easier demonstration.

## Main Files

| File | Purpose |
| --- | --- |
| `voice_demo.m` | Standalone microphone/WAV workflow and comparison plots |
| `lpc_male_to_female.m` | Core frame-based processing function |
| `findpitch.m` | Autocorrelation-based pitch-period estimator |
| `voice_spectrum.m` | FFT magnitude and frequency-axis calculation |
| `voice_gui.m` | Original GUIDE callback file |

## Run

Requires MATLAB and Signal Processing Toolbox.

```matlab
voice_demo
```

or

```matlab
voice_demo('your_recording.wav')
```

The standalone workflow can return processed and original arrays for further analysis:

```matlab
[processed, original, fs] = voice_demo('your_recording.wav');
```

## Scope

This repository demonstrates frame-based speech analysis and resynthesis. It does not claim measured real-time streaming performance, speaker-identity conversion accuracy, or formal perceptual-quality validation.

## Portfolio

See the [Engineering Portfolio](https://github.com/chengmiao2005/FPGAfinalproject/blob/main/docs/PORTFOLIO.md) for a concise overview of related projects.
