close all;
clc;

%open an audio file

%input_file = 'low_e_fret1(F)_long.wav';
%input_file = 'low_e_fret20(C).wav';
%input_file = 'low_e_fret6(A#)_long.wav';
input_file = 'low_e_open_long.wav';
[wave, fs] = wavread(input_file);

%%library of low E string fret frequencies for reference
low_E_string_lib = [82,87,92,98,104,110,117,123,131,139,147,156,165,175,185,196,208,220,233,247,262];

S = 44100;
num_samples = 2^18; %length(wave);
wave = wave(1:num_samples);
T = num_samples/S;
Nfft = T*S;
dt = 1/S;
n = [0:num_samples-1];
t=n*dt;                    
t1 = [0 : 1/S : T-1/S];
    
%plot input signal in dB
figure(1);
plot(t1, 20*log(abs(wave)));
title('Input Signal');
xlabel('Time (s)');
ylabel('Amplitude (dB)');

%plot input signal
figure(2);
plot(t1, wave);
title('Input Signal');
xlabel('Time (s)');
ylabel('Amplitude');

%take a normalized FFT of the input signal
[FFT_normalized] = fft(wave)/Nfft;
%freq_axis = linspace(((-num_samples/2)*(S/num_samples)), (((num_samples/2)-1)*(S/num_samples)), num_samples); %should use num_samples or Nfft in general????
%freq_axis(0,(num_samples/2)*(S/num_samples),Nfft/2);  %attempt to make a 1 sided FFT frequency axis; not working
freq_axis = [(-Nfft/2):(Nfft-1)/2]*(S/Nfft);

%omega = n/Nfft * S;

figure(3);
plot(freq_axis, fftshift(abs(FFT_normalized)));
%plot(freq_axis/(2*pi), 2*abs(FFT_normalized(1:Nfft/2)));  %attempt to plot
%1 sided FFT
title('FFT');
xlabel('Frequency (Hz)');
ylabel('|H(F)|');
xlim([-2000, 2000]);

%%%Questions:
%why does S need to equal 44100 in order to get correct output (doesnt work with 1024)?
%why do I get different results now that S=44100 with long and short clips of same note?




