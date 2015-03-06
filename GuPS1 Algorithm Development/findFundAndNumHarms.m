function [ lib_freq, num_harmonics ] = findFundAndNumHarms(file_name, note_lib, threshold_factor)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
[x_axis, y_axis, actual_freq, fund_val, fund_index, max_peak, lib_freq] = detectpitch_alg5(file_name, note_lib);

[wave, fs] = wavread(file_name);

%determine max integer power of 2 number of samples in the input file
max_pow2 = floor(log2(length(wave)));
num_samples = 2^max_pow2; %number of relevant samples of the input signal

S = fs; %set sampling frequency of FFT same a sampling freq. of recording
wave = wave(1:num_samples); %discard samples beyon 2^ max power of 2
T = num_samples/S;
Nfft = T*S;
dt = 1/S;
n = [0:num_samples-1]; %indeces
t=n*dt;                    
t1 = [0 : 1/S : T-1/S];

%take a normalized FFT of the input signal
[FFT_normalized] = fft(wave)/Nfft;
freq_axis = [(-Nfft/2):(Nfft-1)/2]*(S/Nfft); %create frequency axis to plot against
abs_shifted_FFT_normalized = fftshift(abs(FFT_normalized));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIND ALL HARMONICS ABOVE THRESHOLD
%
threshold = max_peak*threshold_factor;

threshold_array = ones(1, length(freq_axis)) * threshold;


adjustment = 25;
found_count = 0;
index = fund_index+1;
multiplier = 2;
harm_loc = -99;
harm_val = -99;
harmonic_locs = zeros(1, 10);

window_Hz = 10; %size of window in Hz
window_indeces = ceil(window_Hz/(1/T)); %number of indeces in window

while index <= length(abs_shifted_FFT_normalized)
    if(abs_shifted_FFT_normalized(index) >= threshold)
        first = index; % for debugging
        best_index = index;
        index_count = 0;
        while index_count <= window_indeces
            while abs_shifted_FFT_normalized(index) >= threshold
                if abs_shifted_FFT_normalized(index) > abs_shifted_FFT_normalized(best_index)
                    best_index = index;
                end
                index = index + 1;
            end
            index = index + 1; %increment index for next iteration
            index_count = index_count + 1; %update index_count for next iteration            
        end
%         last = index; %for debugging
%         disp(['First: ', num2str(first)]);
%         disp(['Last: ', num2str(last)]);
%         figure(3);
%         hold on;
%         plot([freq_axis(first) freq_axis(first)],ylim, 'Color', 'r');
%         plot([freq_axis(last) freq_axis(last)],ylim, 'Color', 'g');
%         hold off;
        
        if and(freq_axis(best_index) > (actual_freq*multiplier)-adjustment, freq_axis(best_index) < (actual_freq*multiplier)+adjustment)
            harm_loc = best_index;
            harm_val = abs_shifted_FFT_normalized(best_index);
            harmonic_locs(found_count+1) = harm_loc;
            multiplier = multiplier + 1;
            found_count = found_count + 1;
        end
    end
    index = index + 1;
end

num_harmonics = found_count;
end

