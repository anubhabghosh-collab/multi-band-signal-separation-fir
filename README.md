# Multi-Band Signal Separation using FIR Filters

## 📌 Project Overview

This project demonstrates the separation of multiple frequency components from a noisy composite signal using **FIR (Finite Impulse Response) band-pass filters in MATLAB**.

A multi-band signal containing different sinusoidal frequency components is combined with random noise. Three FIR band-pass filters are then mathematically designed and applied to extract selected frequency bands.

The filtered signals are analyzed in both the **time domain and frequency domain**.

---

## 🎯 Objectives

- Generate a multi-frequency signal with random noise.
- Design FIR band-pass filters using the mathematical sinc-based method.
- Separate different frequency components from the noisy signal.
- Analyze the filtered outputs in the time domain.
- Compare the frequency spectra using FFT.
- Visualize the impulse responses of the designed FIR filters.

---

## 📊 Input Signal

The clean signal consists of four sinusoidal components:

```text
100 Hz
400 Hz
700 Hz
900 Hz
