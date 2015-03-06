close all; clc; clear;

% CONSTANTS
stereo = 2;
mono = 1;

% SET FORMAT
format long;

% GET INPUTS
cos_data = 'cos_2-17.txt'; %this file has 21-bit precesion

%audio_input = 'guitar_chord_e_major_44-1kHz_16bit_clip1.wav';
audio_input = 'e_string_highest_note.wav';

if(~(exist(cos_data,'file')))
    error('Error: %s doesnt exist or is unreadable',cos_data);
end

if(~(exist(audio_input,'file')))
    error('Error: %s doesnt exist or is unreadable',audio_input);
end

fp = fopen(cos_data,'r');
%this takes in 16-bit precesion, so we lost a few
cosine = fscanf(fp,'%f'); 

[wave, Fs] = wavread(audio_input);

max_pow2 = floor(log2(length(wave)));
num_samples = 2^max_pow2;

wave = wave(1:num_samples);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dt = 1/Fs;
%duration of sample (milliseconds)
L = num_samples/Fs;  % or call it 'T'
%n = [0:num_samples-1];
t = [0 : 1/Fs : L-1/Fs];
%Ns=Fs/2;
%get next nearest power of two
NFFT = L*Fs;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%fd_xaxis = linspace(0,Ns,NFFT/2+1);
%fd_xaxis = linspace(0,1,149426);


% PLAY SOURCE AUDIO FILE
%player = audioplayer(wave, Fs);
%play(player);
 
row = length(wave);
col = stereo;

new_data = zeros(1, row);

b = 1;
adj = 50;

for i = 1:1:row
  if ((b*adj) > (length(cosine)))
        b=1;
  end
    new_data(i) = cosine(b*adj)*wave(i); % change col 1
    %new_data(i) = cosine(b*adj,1)*wave(i,2); % change col 2
    b = b+1;    
end

% PLAY PROCESSED AUDIO FILE
%player2 = audioplayer(new_data, Fs);
%play(player2);


freq_axis = [(-NFFT/2):(NFFT-1)/2]*(Fs/NFFT);

% GET FFT OF SOURCE AUDIO FILE
subplot(2,2,1);
plot(t, wave);
M = fft(wave);
Mjw = fftshift(abs(M));

% this is plotting w not f
%omega = (-149426/2:1:(149426/2) - 1);
%omega=omega./(2*pi);
subplot(2,2,2);
plot(freq_axis, Mjw);
%plot(fd_xaxis, abs(Mjw));

% GET FFT OF PROCESSED AUDIO FILE
subplot(2,2,3);
plot(t, new_data);
M = fft(new_data);
Mjw = fftshift(M);
Mjw = Mjw';
omega = (-149426/2:1:(149426/2) - 1);
omega=omega./(2*pi);
subplot(2,2,4);
plot(freq_axis, abs(Mjw));

% RESET DEFAULT FORMAT
format short;


