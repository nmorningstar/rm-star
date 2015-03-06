clear;

[x Fs] = wavread('b3_246_9_Hz.wav');    % input WAV

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Original Signal
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% player = audioplayer(x, Fs);
% play(player);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PitchShifter
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% steps=2;
% frameSize=1024;
% hopSize=256;%overlap
% out1=pitchShift(x,frameSize,hopSize,steps); 
% player = audioplayer(out1, Fs);
% play(player);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Phasevocoder
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% b = x';
% out1=pv2_for_demo1(b,Fs);
% player = audioplayer(out1, Fs);
% play(player);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PVOC
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% y=pvoc(x,4);
% out1 = upsample(y,2);
% player = audioplayer(out1, Fs);
% play(player);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Analytical Signal Algorithm 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

format long % changes MATLAB workspace to precision to LONG (15 decimal places).
a = 2^17;
g = 0:(2*pi)/(a-1):2*pi;
adj=10;
g = g(1:adj:end); % generate sine in steps of 50
res = exp(i*g);

% MATLAB only plays the real part of any signal, don't be fooled. maybe.
xa=hilbert(x);
tic;
out1=exp_mod2(xa,Fs,res);
out1=real(out1);
toc;
player = audioplayer(out1, Fs);
play(player);
format SHORT; % reset default format
wave = xa; % shows the analtical signal without shift in the FFT INPUT

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Up shifter
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% out1 = upshifter_fun(x,Fs);
% player = audioplayer(out1, Fs);
% play(player);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Set-up graph stuff
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

max_pow2 = floor(log2(length(wave)));
num_samples = 2^max_pow2;
wave = wave(1:num_samples);
dt = 1/Fs;
%duration of sample (milliseconds)
L = num_samples/Fs;  % or call it 'T'
t = [0 : 1/Fs : L-1/Fs];
NFFT = L*Fs;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Time graph
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(3,1,1);
plot(t, wave);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% FFT of INPUT
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(3,1,2);
freq_axis = [(-NFFT/2):(NFFT-1)/2]*(Fs/NFFT);
M = fft(wave);
Mjw = fftshift(abs(M));
plot(freq_axis, Mjw);
xlim([-2500 2500]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% FFT of OUTPUT
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(3,1,3);
Y = fft(out1);
Yjw = fftshift(abs(Y));
freq_axis2 = [(-length(Y)/2):(length(Y)-1)/2]*(Fs/length(Y));
plot(freq_axis2, Yjw);
xlim([-2500 2500]);
format short;



