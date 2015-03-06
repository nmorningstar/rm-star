%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% THIS IS A IIR FILTER (SPECIFICALLY BUTTERWORTH)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Goal of this script is to filter out 220Hz out of a signal that has 
% other signals (440, 880). Then perform a pitch shift the way we 
% have proven to do so previously with exp_mod2.m
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;

Fs = 44100; % audio sampling rate

%duration of sample (milliseconds)
T = 10000;  % or call it 'T'  
max_pow2 = floor(log2(T));
num_samples = 2^max_pow2;

%duration of sample (milliseconds)
L = num_samples/Fs;  % or call it 'T'

t = [0 : 1/Fs : L-1/Fs];

%get next nearest power of two
NFFT = L*Fs;

%frequency (Hz)
f1 = 220;     
f2 = 440;
f3 = 880;

%signals
s1 = sin(2*pi*f1*t);
s2 = sin(2*pi*f2*t);
s3 = sin(2*pi*f3*t);

st = s1 + s2 + s3;

td_xaxis = Fs*t;

%%% Dave's Filter Attempt (1/24/15)
%%% Modified by Natalie & Bryan (1/28/15)

freq_desired = 220;
offset = 50;
f_low = 50;
f_adj = 500
[N, Wn] = buttord(f_low/(Fs/2), f_adj/(Fs/2), 1, 50);
[B, A] = butter(N, [(freq_desired-offset)/(Fs/2), (freq_desired+offset)/(Fs/2)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Set up and open Filter Virualization Tool
% use this tool to check out bode plots and other cool things
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fvtool(B,A);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generate Filter Coeficients AND set up some axis 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

filtered = filter(B, A, st);

freq_axis = [(-NFFT/2):(NFFT-1)/2]*(Fs/NFFT);
FFT_normalized = fft(st)/NFFT;
FFT_normalized_filtered = fft(filtered)/NFFT;

abs_shifted_FFT_normalized_filtered = fftshift(abs(FFT_normalized_filtered));
abs_shifted_FFT_normalized = fftshift(abs(FFT_normalized));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generate Impulse Response of the Filter
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pulse=zeros(1,num_samples);
pulse(1)=1;
impulse_response=filter(B,A,pulse);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot FFT of Impulse Response in Log
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2);
M2 = fft(impulse_response);
Mjw2 = fftshift(abs(M2));
plot(freq_axis, Mjw2,'r');
xlim([-2500 2500]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot FFT of Input and the Filtered Output
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(3);
subplot(2,1,1);
plot(freq_axis, abs_shifted_FFT_normalized);
title('Frequency domain (fft) of original signal', 'FontSize', 16);
xlabel('Frequency (Hz)', 'FontSize', 16);
ylabel('Amplitude', 'FontSize', 16);
xlim([-2500 2500]);

subplot(2,1,2);
plot(freq_axis, abs_shifted_FFT_normalized_filtered);
title('Frequency domain (fft) output of filter', 'FontSize', 16);
xlabel('Frequency (Hz)', 'FontSize', 16);
ylabel('Amplitude', 'FontSize', 16);
xlim([-2500 2500]);

