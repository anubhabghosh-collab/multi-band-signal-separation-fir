clc;
clear;
close all;

%% PARAMETERS
Fs = 2000;                    % Sampling frequency
t = 0:1/Fs:2;                 % 2 seconds duration
N = 60;                       % Filter order (length = N+1)
n = 0:N;                      % Discrete time index

%% MULTI-BAND SIGNAL + RANDOM NOISE
x_clean = sin(2*pi*100*t) + 0.8*sin(2*pi*400*t) + ...
    0.5*sin(2*pi*700*t) + 0.3*sin(2*pi*900*t);
rng('default');               % For repeatable noise
noise = 0.25*randn(size(t));  % Generate noise separately
x = x_clean + noise;          % Noisy signal

%% --- DESIGN 3 FIR BAND-PASS FILTERS (MATHEMATICAL METHOD) ---
% Note: Cutoff frequencies normalized by (Fs/2)
% Band 1: 80–200 Hz
fc1_low = 80/(Fs/2);
fc1_high = 200/(Fs/2);
h1 = (2*fc1_high)*sinc( (2*fc1_high)*(n - N/2) ) - ...
     (2*fc1_low)*sinc( (2*fc1_low)*(n - N/2) );

% Band 2: 350–500 Hz
fc2_low = 350/(Fs/2);
fc2_high = 500/(Fs/2);
h2 = (2*fc2_high)*sinc( (2*fc2_high)*(n - N/2) ) - ...
     (2*fc2_low)*sinc( (2*fc2_low)*(n - N/2) );

% Band 3: 650–950 Hz
fc3_low = 650/(Fs/2);
fc3_high = 950/(Fs/2);
h3 = (2*fc3_high)*sinc( (2*fc3_high)*(n - N/2) ) - ...
     (2*fc3_low)*sinc( (2*fc3_low)*(n - N/2) );

%% --- APPLY FILTERS ---
band1 = filter(h1, 1, x);
band2 = filter(h2, 1, x);
band3 = filter(h3, 1, x);

%% ---- TIME DOMAIN VISUALIZATION ----
figure('Name','Time Domain Visualization');
subplot(4,1,1);
plot(t, x_clean, 'b', 'DisplayName', 'Original Signal'); hold on;
plot(t, noise, 'r', 'DisplayName', 'Noise');
title('Original Multi-band Signal and Noise');
xlabel('t (s)'); ylabel('Amplitude');
legend; hold off;

subplot(4,1,2); plot(t, band1, 'r'); title('Band 1 (80–200 Hz)');
subplot(4,1,3); plot(t, band2, 'g'); title('Band 2 (350–500 Hz)');
subplot(4,1,4); plot(t, band3, 'b'); title('Band 3 (650–950 Hz)');

%% ---- TIME DOMAIN: OVERLAY PLOTS FOR EACH FILTERED BAND ----
figure('Name','Original vs Band 1 Output (Time Domain)');
plot(t, x, 'k', 'LineWidth', 1); hold on;
plot(t, band1, 'r', 'LineWidth', 1);
legend('Original','Band 1 Output');
xlabel('Time (s)'); ylabel('Amplitude');
title('Time Domain: Original vs Band 1 Output');
grid on;

figure('Name','Original vs Band 2 Output (Time Domain)');
plot(t, x, 'k', 'LineWidth', 1); hold on;
plot(t, band2, 'g', 'LineWidth', 1);
legend('Original','Band 2 Output');
xlabel('Time (s)'); ylabel('Amplitude');
title('Time Domain: Original vs Band 2 Output');
grid on;

figure('Name','Original vs Band 3 Output (Time Domain)');
plot(t, x, 'k', 'LineWidth', 1); hold on;
plot(t, band3, 'b', 'LineWidth', 1);
legend('Original','Band 3 Output');
xlabel('Time (s)'); ylabel('Amplitude');
title('Time Domain: Original vs Band 3 Output');
grid on;

%% ---- FREQUENCY DOMAIN (FFT MAGNITUDE COMPARISON) ----
nfft = 2^nextpow2(length(x));
f = Fs/2 * linspace(0,1,nfft/2+1);
X = fft(x, nfft);
B1 = fft(band1, nfft);
B2 = fft(band2, nfft);
B3 = fft(band3, nfft);

% All spectra together
figure('Name','Frequency Domain Visualization (All Outputs)');
plot(f, abs(X(1:nfft/2+1)), 'k','LineWidth',1); hold on;
plot(f, abs(B1(1:nfft/2+1)), 'r','LineWidth',1);
plot(f, abs(B2(1:nfft/2+1)), 'g','LineWidth',1);
plot(f, abs(B3(1:nfft/2+1)), 'b','LineWidth',1);
title('Spectrum of Original and All Filtered Bands');
legend('Original','Band1','Band2','Band3');
xlabel('Frequency (Hz)'); ylabel('Magnitude'); grid on;

% Overlay spectrum for each band
figure('Name','Spectrum: Original vs Band 1');
plot(f, abs(X(1:nfft/2+1)), 'k','LineWidth',1); hold on;
plot(f, abs(B1(1:nfft/2+1)), 'r','LineWidth',1);
legend('Original','Band 1 Output');
xlabel('Frequency (Hz)'); ylabel('Magnitude');
title('Spectrum: Original vs Band 1 Output');
grid on;

figure('Name','Spectrum: Original vs Band 2');
plot(f, abs(X(1:nfft/2+1)), 'k','LineWidth',1); hold on;
plot(f, abs(B2(1:nfft/2+1)), 'g','LineWidth',1);
legend('Original','Band 2 Output');
xlabel('Frequency (Hz)'); ylabel('Magnitude');
title('Spectrum: Original vs Band 2 Output');
grid on;

figure('Name','Spectrum: Original vs Band 3');
plot(f, abs(X(1:nfft/2+1)), 'k','LineWidth',1); hold on;
plot(f, abs(B3(1:nfft/2+1)), 'b','LineWidth',1);
legend('Original','Band 3 Output');
xlabel('Frequency (Hz)'); ylabel('Magnitude');
title('Spectrum: Original vs Band 3 Output');
grid on;

%% ---- IMPULSE RESPONSE PLOTS ----
figure;
subplot(3,1,1); stem(n, h1, 'r','filled');
title('Impulse Response: Band 1'); xlabel('n'); ylabel('h1[n]'); grid on;
subplot(3,1,2); stem(n, h2, 'g','filled');
title('Impulse Response: Band 2'); xlabel('n'); ylabel('h2[n]'); grid on;
subplot(3,1,3); stem(n, h3, 'b','filled');
title('Impulse Response: Band 3'); xlabel('n'); ylabel('h3[n]'); grid on;