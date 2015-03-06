%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Goal of this script is to filter out 220Hz out of a signal that has 
% other signals (440, 880). Then perform a pitch shift the way we 
% have proven to do so previously with exp_mod2.m
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear all;

[st Fs] = wavread('g_string_2nd_fret(A)_8kHz.wav');    % input WAV
st=st';
max_pow2 = floor(log2(length(st)));
num_samples = 2^max_pow2;

%duration of sample (milliseconds)
L = num_samples/Fs;  % or call it 'T'
t = [0 : 1/Fs : L-1/Fs];
NFFT = L*Fs;
st = st(1:num_samples);

%frequency (Hz)
f1 = 220;     
f2 = 440;
f3 = 660;

st = st(1:num_samples); % clip it to the largest power of 2 under the max

% get next nearest power of two
% NFFT = L*Fs
td_xaxis = t;
freq_axis = ((-NFFT/2):(NFFT-1)/2)*(Fs/NFFT);

half_steps = 6; %number of whole steps to shift up
filter_width = 80;
n = 200; 

M_source = fft(st);
Mjw_source = fftshift(abs(M_source));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Determing proper alpha to multiple by in the complex exponential shift
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

half_steps_closest_f1 = getClosestHalfSteps(Fs, NFFT, f1, half_steps);
half_steps_closest_f2 = getClosestHalfSteps(Fs, NFFT, f2, half_steps);
half_steps_closest_f3 = getClosestHalfSteps(Fs, NFFT, f3, half_steps);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Filter out f1, f2, f3 and shift each
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[filtered_f1 b1]= filter_guitar(filter_width,n,Fs,f1,st);
length_filtered_f1 = length(filtered_f1)
shifted_f1 = complex_exp_shift(filtered_f1, t, half_steps_closest_f1, f1);
M_filtered_f1 = fft(filtered_f1);
Mjw_filtered_f1 = fftshift(abs(M_filtered_f1));
M_shifted_f1 = fft(shifted_f1);
Mjw_shifted_f1 = fftshift(abs(M_shifted_f1));

[filtered_f2 b2]= filter_guitar(filter_width,n,Fs,f2,st);
shifted_f2 = complex_exp_shift(filtered_f2, t, half_steps_closest_f2, f2);
M_filtered_f2 = fft(filtered_f2);
Mjw_filtered_f2 = fftshift(abs(M_filtered_f2));
M_shifted_f2 = fft(shifted_f2);
Mjw_shifted_f2 = fftshift(abs(M_shifted_f2));

[filtered_f3 b3]= filter_guitar(filter_width,n,Fs,f3,st);
shifted_f3 = complex_exp_shift(filtered_f3, t, half_steps_closest_f3, f3);
M_filtered_f3 = fft(filtered_f3);
Mjw_filtered_f3 = fftshift(abs(M_filtered_f3));
M_shifted_f3 = fft(shifted_f3);
Mjw_shifted_f3 = fftshift(abs(M_shifted_f3));

%figure(7);
%freqz(b1,1,8192);
%plotting with just freqz here is basically the same as what we do bellow

[Hq,wq]=freqz(b1,1,8192,'whole');
figure(10);
subplot(2,1,1);
plot(wq/(2*pi)*Fs,abs(Hq));
xlim([50 550]);
subplot(2,1,2);
plot(wq/(2*pi)*Fs,unwrap(angle(Hq))*180/pi);
xlim([50 550]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Recombine the shifted harmonics into 1 signal and take the real part
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% also we need to fix the other amplitudes
% other amplitude issues??

shifted_sum = shifted_f1 + shifted_f2 + shifted_f3;
real_shifted_sum = real(shifted_sum); 
M_real_shifted_sum = fft(real_shifted_sum);
Mjw_real_shifted_sum = fftshift(abs(M_real_shifted_sum));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot source, filtered frequencies and shifted frequencies
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2);
subplot(4,1,1);
plot(freq_axis, Mjw_source);
title('FFT of Source Signal',...
    'fontsize',20,'fontweight', 'b');

figure(2);
subplot(4,1,2);
plot(freq_axis, Mjw_filtered_f1, 'b'); hold on;
plot(freq_axis, Mjw_shifted_f1, 'r');
title('(f1) FFT of FIRPM + Hilber Coefficients and Shifted Output in Red',...
    'fontsize',20,'fontweight', 'b');
xlim([-2500 2500]);

figure(2);
subplot(4,1,3);
plot(freq_axis, Mjw_filtered_f2); hold on;
plot(freq_axis, Mjw_shifted_f2, 'r'); 
title('(f2) FFT of FIRPM + Hilber Coefficients and Shifted Output in Red',...
    'fontsize',20,'fontweight', 'b');
xlim([-2500 2500]);

figure(2);
subplot(4,1,4);
plot(freq_axis, Mjw_filtered_f3); hold on;
plot(freq_axis, Mjw_shifted_f3, 'r'); 
title('(f3) FFT of FIRPM + Hilber Coefficients and Shifted Output in Red',...
    'fontsize',20,'fontweight', 'b');
xlim([-2500 2500]);

figure(3);
plot(freq_axis, Mjw_source); hold on;
plot(freq_axis, Mjw_real_shifted_sum, 'r');
title('Recombined shifted signal',...
    'fontsize',20,'fontweight', 'b');
xlim([-2500 2500]);

%player = audioplayer(real_shifted_sum, Fs);
player = audioplayer(st, Fs);
play(player);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Create FIR Filter Coefficient files, I/Q parts
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

real_b1 = real(b1); % I-Component
imag_b1 = imag(b1); % Q-Component
hqr1 = dfilt.dffir(real_b1);
hqi1 = dfilt.dffir(imag_b1);
set(hqr1,'arithmetic','fixed');
set(hqi1,'arithmetic','fixed');
%coewrite(hqr1,10);
coewrite(hqi1,10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot FFT of the Source Signal and its FFT
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure(1); subplot(5,1,1);
% plot(td_xaxis,st);
% title('Source Signal',...
%     'fontsize',20,'fontweight', 'b');
% xlabel('Time (ms)'); ylabel('');
% 
% figure(1); subplot(5,1,2);
% freq_axis = [(-NFFT/2):(NFFT-1)/2]*(Fs/NFFT);
% M_source = fft(st);
% Mjw_source = fftshift(abs(M_source));
% plot(freq_axis, Mjw_source);
% title('FFT of Source Signal',...
%     'fontsize',20,'fontweight', 'b');
% xlim([-2500 2500]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot the filtered output without doing the Hilber Trasnform
% TEST
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure(1); 
% subplot(5,1,3);
% b2=filter(b_f1,1,st);
% M0 = fft(b2);
% Mjw0 = fftshift(abs(M0));
% plot(freq_axis, Mjw0);
% title('zzzFFT of FIRPM Coefficients ONLY',...
%     'fontsize',20,'fontweight', 'b');
% xlim([-2500 2500]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generate Impulse Response of the Filter
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% pulse=zeros(1,num_samples);
% pulse(1)=1;
% impulse_response=filter(b_f1,1,pulse);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot FFT of the Filtered Output
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure(1);
% subplot(5,1,4);
% M_filtered_f1 = fft(filtered_f1);
% Mjw_filtered_f1 = fftshift(abs(M_filtered_f1));
% 
% M2 = fft(impulse_response);
% Mjw2 = fftshift(abs(M2));
% 
% plot(freq_axis, Mjw_filtered_f1); hold on;
% plot(freq_axis, Mjw2,'r');
% title('FFT of FIRPM + Hilber Coefficients and Impulse Response in Red, see Figure 3!',...
%     'fontsize',20,'fontweight', 'b');
% xlim([-2500 2500]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot the shifted filtered output
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure(1);
% subplot(5,1,5);
% M_shifted_f1 = fft(shifted_f1);
% Mjw_shifted_f1 = fftshift(abs(M_shifted_f1));
% plot(freq_axis, Mjw_filtered_f1, 'b'); hold on;
% plot(freq_axis, Mjw_shifted_f1, 'r');
% title('FFT of FIRPM + Hilber Coefficients and Shifted Output in Red',...
%     'fontsize',20,'fontweight', 'b');
% xlim([-2500 2500]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot FFT of the Filtered Output in Log
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure(3);
% plot(freq_axis, 10*log10(Mjw_filtered_f1)); hold on;
% plot(freq_axis, 10*log10(Mjw2),'r');
% title('FFT of FIRPM + Hilber Coefficients and Impulse Response in Red',...
%     'fontsize',20,'fontweight', 'b');

%player = audioplayer(filtered_output_f1, Fs);
%player = audioplayer(out1, Fs);
%play(player);





