%%% Real-Time Speech Pitch Shifting on an FPGA
%%% Estephan, Sawyer, Wanninger
%%% M-File by Scott Sawyer (2006)
%%% Villanova University
%%% Department of Electrical and Computer Engineering


clear; clc;

%%% Define input signal and sampling rate

input = wavread('freddie_mono.wav')';    % input WAV
fs = 44.1e3;                             % input sampling rate

%%% Define global constants

alpha = 13/12;                          % pitch-shift factor
N = 512;                                % frame length
overlap = .75;                          % overlap fraction
window = hanning(N)';                   % input window

%%% Calculate working variables

input_length = length(input);           % length of input signal
frame_count = floor((input_length-2*N)/(N*(1-overlap)));
                                        % number of frames in input
Ra = floor(N*(1-overlap));              % analysis time hop
Rs = floor(alpha*Ra);                   % synthesis time hop
Wk = (0:(N-1))*2*pi/N;                  % center bin frequencies
output = zeros(1, input_length*alpha);  % output signal initialization

%%% Process input frames

Xu_current = fft(window.*input(1:N));   % analyze initial frame
PhiY_current = angle(Xu_current);       % initial frame output phases

for u=1:frame_count
    Xu_prev = Xu_current;               % store last frame's STFT
    PhiY_prev = PhiY_current;           % store last frame's output phases
    Xu_current = fft(window.*input(u*Ra:u*Ra+N-1));
                                        % analyze current frame
    DPhi = angle(Xu_current) - angle(Xu_prev) - Ra*Wk;
                                        % unwrapped phase change
    DPhip = mod(DPhi+pi, 2*pi) - pi;    % principle determination (+/- pi)
    w_hatk = Wk + (1/Ra)*DPhip;         % estimated "real" bin frequency
    PhiY_current = PhiY_prev + Rs*w_hatk;
                                        % Phase propagation formula
    Yu = abs(Xu_current).*exp(j*PhiY_current);
                                        % output STFT
    output(u*Rs:u*Rs+N-1) = output(u*Rs:u*Rs+N-1) + real(ifft(Yu));
                                        % add current frame to output
end

norm_output = output./max(output);      % normalize the output amplitude
[t,d]=rat(alpha);                       % determine integer shift ratio
shifted = resample(output,d,t);         % resample for pitch shift

% sound(input,fs);
% sound(output,fs);
% sound(shifted,fs);
