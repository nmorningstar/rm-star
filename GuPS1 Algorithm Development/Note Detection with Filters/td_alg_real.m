%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script shifts a real audio signal (g_string_2nd_fret(A)_8kHz.wav) by
% a given number of half steps using FIR filters.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear all;
clc;

input_file = 'g_string_2nd_fret(A)_8kHz.wav';
[wave, fs] = wavread(input_file);

%determine max integer power of 2 number of samples in the input file
max_pow2 = floor(log2(length(wave)));
num_samples = 2^max_pow2; %number of relevant samples of the input signal

S = fs; %set sampling frequency of FFT same a sampling freq. of recording
wave = wave(1:num_samples); %discard samples beyon 2^ max power of 2
wave = transpose(wave);
T = num_samples/S;
Nfft = T*S;
dt = 1/S;
n = [0:num_samples-1]; %indeces
t=n*dt;                    
%t1 = [0 : 1/S : T-1/S]; %another way to form t variable

%take a normalized FFT of the input signal
[FFT] = fft(wave);
freq_axis = [(-Nfft/2):(Nfft-1)/2]*(S/Nfft); %create frequency axis to plot against
abs_shifted_FFT_normalized = fftshift(abs(FFT));

%plot input signal in time domain
figure(1);
plot(t, wave);
title('Input Signal (pow 2 number of samples) - Time Domain');
xlabel('Time (s)');
ylabel('Amplitude');

%plot input signal in frequency domain
figure(2);
plot(freq_axis, abs_shifted_FFT_normalized);
hold on;
title('FFT');
xlabel('Frequency (Hz)');
ylabel('|H(F)|');
xlim([-2000, 2000]);

half_steps = 12; %number of half steps to shift up or down
filter_width = 80;
n = 200; %number of coefficients; we need to decide what this should be based on the highest harmonic on the guitar

% initialize filters for the following frequencies
f1 = 220; %fundamental
f2 = 440;
f3 = 660;
f4 = 880;
f5 = 1100;
f6 = 1320;
f7 = 1540;

%% filter out f1 from input signal and shift
[f1_filtered, coefs_f1] = filter_guitar(filter_width,n,S,f1,wave);

%plot frequency response of filter for f1
[Hq,wq]=freqz(coefs_f1,1,8192,'whole');
figure(3);
subplot(2,1,1);
plot(wq/(2*pi)*S,abs(Hq));
xlim([50 550]);
subplot(2,1,2);
plot(wq/(2*pi)*S,unwrap(angle(Hq))*180/pi);
xlim([50 550]);

%shift f1_filtered by the desired number of half steps
half_steps_closest = getClosestHalfSteps(S, Nfft, f1, half_steps);
f1_shifted = complex_exp_shift(f1_filtered, t, half_steps_closest, f1);

FFT_f1_filtered = fft(f1_filtered); %take FFT of filtered signal
abs_shifted_FFT_f1_filtered = fftshift(abs(FFT_f1_filtered)); %center FFT on 0Hz
FFT_f1_shifted = fft(f1_shifted); %take FFT of shifted signal
abs_shifted_FFT_f1_shifted = fftshift(abs(FFT_f1_shifted)); %center FFT on 0Hz

%% filter out f2 from input signal and shift
[f2_filtered, coefs_f2] = filter_guitar(filter_width,n,S,f2,wave);

%plot frequency response of filter for f2
[Hq,wq]=freqz(coefs_f2,1,8192,'whole');
figure(4);
subplot(2,1,1);
plot(wq/(2*pi)*S,abs(Hq));
xlim([50 550]);
subplot(2,1,2);
plot(wq/(2*pi)*S,unwrap(angle(Hq))*180/pi);
xlim([50 550]);

%shift f2_filtered by the desired number of half steps
half_steps_closest = getClosestHalfSteps(S, Nfft, f2, half_steps);
f2_shifted = complex_exp_shift(f2_filtered, t, half_steps_closest, f2);

FFT_f2_filtered = fft(f2_filtered); %take FFT of filtered signal
abs_shifted_FFT_f2_filtered = fftshift(abs(FFT_f2_filtered)); %center FFT on 0Hz
FFT_f2_shifted = fft(f2_shifted); %take FFT of shifted signal
abs_shifted_FFT_f2_shifted = fftshift(abs(FFT_f2_shifted)); %center FFT on 0Hz

%% filter out f3 from input signal and shift
[f3_filtered, coefs_f3] = filter_guitar(filter_width,n,S,f3,wave);

%plot frequency response of filter for f3
[Hq,wq]=freqz(coefs_f3,1,8192,'whole');
figure(5);
subplot(2,1,1);
plot(wq/(2*pi)*S,abs(Hq));
xlim([50 550]);
subplot(2,1,2);
plot(wq/(2*pi)*S,unwrap(angle(Hq))*180/pi);
xlim([50 550]);

%shift f3_filtered by the desired number of half steps
half_steps_closest = getClosestHalfSteps(S, Nfft, f3, half_steps);
f3_shifted = complex_exp_shift(f3_filtered, t, half_steps_closest, f3);

FFT_f3_filtered = fft(f3_filtered); %take FFT of filtered signal
abs_shifted_FFT_f3_filtered = fftshift(abs(FFT_f3_filtered)); %center FFT on 0Hz
FFT_f3_shifted = fft(f3_shifted); %take FFT of shifted signal
abs_shifted_FFT_f3_shifted = fftshift(abs(FFT_f3_shifted)); %center FFT on 0Hz


%%  filter out f4 from input signal and shift
[f4_filtered, coefs_f4] = filter_guitar(filter_width,n,S,f4,wave);

%plot frequency response of filter for f4
[Hq,wq]=freqz(coefs_f4,1,8192,'whole');
figure(6);
subplot(2,1,1);
plot(wq/(2*pi)*S,abs(Hq));
xlim([50 550]);
subplot(2,1,2);
plot(wq/(2*pi)*S,unwrap(angle(Hq))*180/pi);
xlim([50 550]);

%shift f4_filtered by the desired number of half steps
half_steps_closest = getClosestHalfSteps(S, Nfft, f4, half_steps);
f4_shifted = complex_exp_shift(f4_filtered, t, half_steps_closest, f4);

FFT_f4_filtered = fft(f4_filtered); %take FFT of filtered signal
abs_shifted_FFT_f4_filtered = fftshift(abs(FFT_f4_filtered)); %center FFT on 0Hz
FFT_f4_shifted = fft(f4_shifted); %take FFT of shifted signal
abs_shifted_FFT_f4_shifted = fftshift(abs(FFT_f4_shifted)); %center FFT on 0Hz

%%  filter out f5 from input signal and shift
[f5_filtered, coefs_f5] = filter_guitar(filter_width,n,S,f5,wave);

%plot frequency response of filter for f5
[Hq,wq]=freqz(coefs_f5,1,8192,'whole');
figure(7);
subplot(2,1,1);
plot(wq/(2*pi)*S,abs(Hq));
xlim([50 550]);
subplot(2,1,2);
plot(wq/(2*pi)*S,unwrap(angle(Hq))*180/pi);
xlim([50 550]);

%shift f5_filtered by the desired number of half steps
half_steps_closest = getClosestHalfSteps(S, Nfft, f5, half_steps);
f5_shifted = complex_exp_shift(f5_filtered, t, half_steps_closest, f5);

FFT_f5_filtered = fft(f5_filtered); %take FFT of filtered signal
abs_shifted_FFT_f5_filtered = fftshift(abs(FFT_f5_filtered)); %center FFT on 0Hz
FFT_f5_shifted = fft(f5_shifted); %take FFT of shifted signal
abs_shifted_FFT_f5_shifted = fftshift(abs(FFT_f5_shifted)); %center FFT on 0Hz

%%  filter out f6 from input signal and shift
[f6_filtered, coefs_f6] = filter_guitar(filter_width,n,S,f6,wave);

%plot frequency response of filter for f6
[Hq,wq]=freqz(coefs_f6,1,8192,'whole');
figure(8);
subplot(2,1,1);
plot(wq/(2*pi)*S,abs(Hq));
xlim([50 550]);
subplot(2,1,2);
plot(wq/(2*pi)*S,unwrap(angle(Hq))*180/pi);
xlim([50 550]);

%shift f6_filtered by the desired number of half steps
half_steps_closest = getClosestHalfSteps(S, Nfft, f6, half_steps);
f6_shifted = complex_exp_shift(f6_filtered, t, half_steps_closest, f6);

FFT_f6_filtered = fft(f6_filtered); %take FFT of filtered signal
abs_shifted_FFT_f6_filtered = fftshift(abs(FFT_f6_filtered)); %center FFT on 0Hz
FFT_f6_shifted = fft(f6_shifted); %take FFT of shifted signal
abs_shifted_FFT_f6_shifted = fftshift(abs(FFT_f6_shifted)); %center FFT on 0Hz

%%  filter out f7 from input signal and shift
[f7_filtered, coefs_f7] = filter_guitar(filter_width,n,S,f7,wave);

%plot frequency response of filter for f7
[Hq,wq]=freqz(coefs_f7,1,8192,'whole');
figure(9);
subplot(2,1,1);
plot(wq/(2*pi)*S,abs(Hq));
xlim([50 550]);
subplot(2,1,2);
plot(wq/(2*pi)*S,unwrap(angle(Hq))*180/pi);
xlim([50 550]);

%shift f7_filtered by the desired number of half steps
half_steps_closest = getClosestHalfSteps(S, Nfft, f7, half_steps);
f7_shifted = complex_exp_shift(f7_filtered, t, half_steps_closest, f7);

FFT_f7_filtered = fft(f7_filtered); %take FFT of filtered signal
abs_shifted_FFT_f7_filtered = fftshift(abs(FFT_f7_filtered)); %center FFT on 0Hz
FFT_f7_shifted = fft(f7_shifted); %take FFT of shifted signal
abs_shifted_FFT_f7_shifted = fftshift(abs(FFT_f7_shifted)); %center FFT on 0Hz

%% Plot filtered frequencies and shifted frequencies

figure(10);
%subplot(4,1,2);
plot(freq_axis, abs_shifted_FFT_f1_filtered, 'b'); hold on;
plot(freq_axis, abs_shifted_FFT_f1_shifted, 'r');
title('(f1) FFT of FIRPM + Hilber Coefficients and Shifted Output in Red',...
    'fontsize',20,'fontweight', 'b');
xlim([-2500 2500]);

figure(11);
%subplot(4,1,3);
plot(freq_axis, abs_shifted_FFT_f2_filtered); hold on;
plot(freq_axis, abs_shifted_FFT_f2_shifted, 'r'); 
title('(f2) FFT of FIRPM + Hilber Coefficients and Shifted Output in Red',...
    'fontsize',20,'fontweight', 'b');
xlim([-2500 2500]);

figure(12);
%subplot(4,1,4);
plot(freq_axis, abs_shifted_FFT_f3_filtered); hold on;
plot(freq_axis, abs_shifted_FFT_f3_shifted, 'r'); 
title('(f3) FFT of FIRPM + Hilber Coefficients and Shifted Output in Red',...
    'fontsize',20,'fontweight', 'b');
xlim([-2500 2500]);

figure(13);
%subplot(4,1,4);
plot(freq_axis, abs_shifted_FFT_f4_filtered); hold on;
plot(freq_axis, abs_shifted_FFT_f4_shifted, 'r'); 
title('(f4) FFT of FIRPM + Hilber Coefficients and Shifted Output in Red',...
    'fontsize',20,'fontweight', 'b');
xlim([-2500 2500]);

figure(14);
%subplot(4,1,4);
plot(freq_axis, abs_shifted_FFT_f5_filtered); hold on;
plot(freq_axis, abs_shifted_FFT_f5_shifted, 'r'); 
title('(f5) FFT of FIRPM + Hilber Coefficients and Shifted Output in Red',...
    'fontsize',20,'fontweight', 'b');
xlim([-2500 2500]);

figure(15);
%subplot(4,1,4);
plot(freq_axis, abs_shifted_FFT_f6_filtered); hold on;
plot(freq_axis, abs_shifted_FFT_f6_shifted, 'r'); 
title('(f6) FFT of FIRPM + Hilber Coefficients and Shifted Output in Red',...
    'fontsize',20,'fontweight', 'b');
xlim([-2500 2500]);

figure(16);
%subplot(4,1,4);
plot(freq_axis, abs_shifted_FFT_f7_filtered); hold on;
plot(freq_axis, abs_shifted_FFT_f7_shifted, 'r'); 
title('(f7) FFT of FIRPM + Hilber Coefficients and Shifted Output in Red',...
    'fontsize',20,'fontweight', 'b');
xlim([-2500 2500]);

%% Recombine the shifted harmonics into 1 signal and take the real part

shifted_sum = f1_shifted + f2_shifted + f3_shifted + f4_shifted + f5_shifted + f6_shifted + f7_shifted;
real_shifted_sum = real(shifted_sum); 
FFT_real_shifted_sum = fft(real_shifted_sum);
abs_shifted_FFT_real_shifted_sum = fftshift(abs(FFT_real_shifted_sum));

figure(17);
plot(freq_axis, abs_shifted_FFT_normalized); hold on;
plot(freq_axis, abs_shifted_FFT_real_shifted_sum, 'r');
title('Original FFT and Recombined FFT', 'fontsize', 20, 'fontweight', 'b');
%xlim([-2000, 2000]);

%% Play output
player = audioplayer(real_shifted_sum, S);
%player = audioplayer(wave, S);
play(player);
