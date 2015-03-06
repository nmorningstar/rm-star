%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This downsampling gets as close to the desired frequency as possible so 
% that it can still preserve the period (T) of the original signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


input_file = 'high_e_fret22(D)_long.wav';
[wave, fs] = wavread(input_file);

max_pow2 = floor(log2(length(wave)));
num_samples = length(wave);

S = fs;
T = num_samples/S;
Nfft = T*S;
dt = 1/S;
n = [0:num_samples-1];
t=n*dt;

figure(1);
plot(t, wave);
title('Input Signal Before Downsampling');
xlabel('Time (s)');
ylabel('Amplitude');

%take a normalized FFT of the input signal
[FFT_normalized] = fft(wave)/Nfft;
freq_axis = [(-Nfft/2):(Nfft-1)/2]*(S/Nfft); %create frequency axis to plot against
abs_shifted_FFT_normalized = fftshift(abs(FFT_normalized));

figure(2);
plot(freq_axis, abs_shifted_FFT_normalized);
hold on;
title('FFT of Original Signal');
xlabel('Frequency (Hz)');
ylabel('|H(F)|');
xlim([-5000, 5000]);

S_desired = 8192;

M=floor(num_samples/(T*S_desired)); %downsample factor
wave_downsample = wave(M:M:length(wave));

fs_down = length(wave_downsample)/T;
T_down = length(wave_downsample)/fs_down;
Nfft_down = T_down*fs_down;
dt_down = 1/fs_down;
n_down = [0:length(wave_downsample)-1];
t_down=n_down*dt_down;

figure(3);
plot(t_down, wave_downsample);
title('Input Signal After Downsampling');
xlabel('Time (s)');
ylabel('Amplitude');

%take a normalized FFT of the input signal
[FFT_normalized_down] = fft(wave_downsample)/Nfft_down;
freq_axis_down = [(-Nfft_down/2):(Nfft_down-1)/2]*(fs_down/Nfft_down); %create frequency axis to plot against
abs_shifted_FFT_normalized_down = fftshift(abs(FFT_normalized_down));

figure(4);
plot(freq_axis_down, abs_shifted_FFT_normalized_down);
hold on;
title('FFT of Downsampled Signal');
xlabel('Frequency (Hz)');
ylabel('|H(F)|');
xlim([-5000, 5000]);

% player = audioplayer(wave, fs);
% play(player);
% player = audioplayer(wave_downsample, fs_down);
% play(player);
