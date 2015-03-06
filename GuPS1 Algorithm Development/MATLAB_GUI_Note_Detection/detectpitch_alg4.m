function [x, y, note, freq, fund_val, fund_index, max_peak] = detectpitch_alg4(filename)
%function [x, y, note, freq, fund_val, fund_index, max_peak] = detectpitch_alg4(filename)
%
%Description: Detects pitch using Dave's algorithm, and returns
%       relevant data.
%
%Calling Parameters:
%   filename = Name of the input file containing note to be shifted.
%
%Output Parameters:
%   x = The X axis of the resulting plot.
%   y = The Y axis of the resulting plot.
%   note = the actual note name
%   freq = The frequency of the fundamental after detection.
%   fund_val = amplitude value of fundamental
%   fund_index = index in the FFT array where the fundamental lies
%   max_peak = the amplitude value of the max peak found in the FFT
%

[wave, fs] = wavread(filename);

%%library of frequencies for reference
freq_lib = [82,87,92,98,104,110,117,123,131,139,147,156,165,175,185,196,208,220,233,247,262,277,294, ...
              110,117,123,131,139,147,156,165,175,185,196,208,220,233,247,262,277,294,311,330,349,370,392, ...
              147,156,165,175,185,196,208,220,233,247,262,277,294,311,330,349,370,392,415,440,466,494,523, ...
              196,208,220,233,247,262,277,294,311,330,349,370,392,415,440,466,494,523,554,587,622,659,698, ...
              247,262,277,294,311,330,349,370,392,415,440,466,494,523,554,587,622,659,698,740,784,831,880, ...
              330,349,370,392,415,440,466,494,523,554,587,622,659,698,740,784,831,880,932,988,1047,1109,1175];
freq_lib_note_letters = {'E'; 'F'; 'F#'; 'G'; 'G#'; 'A'; 'A#'; 'B'; 'C'; 'C#'; 'D'; 'D#'; 'E'; 'F'; 'F#'; 'G'; 'G#'; 'A'; 'A#'; 'B'; 'C'; 'C#'; 'D'; ...
                       'A'; 'A#'; 'B'; 'C'; 'C#'; 'D'; 'D#'; 'E'; 'F'; 'F#'; 'G'; 'G#'; 'A'; 'A#'; 'B'; 'C'; 'C#'; 'D'; 'D#'; 'E'; 'F'; 'F#'; 'G'; ....
                       'D'; 'D#'; 'E'; 'F'; 'F#'; 'G'; 'G#'; 'A'; 'A#'; 'B'; 'C'; 'C#'; 'D'; 'D#'; 'E'; 'F'; 'F#'; 'G'; 'G#'; 'A'; 'A#'; 'B'; 'C'; ...
                       'G'; 'G#'; 'A'; 'A#'; 'B'; 'C'; 'C#'; 'D'; 'D#'; 'E'; 'F'; 'F#'; 'G'; 'G#'; 'A'; 'A#'; 'B'; 'C'; 'C#'; 'D'; 'D#'; 'E'; 'F'; ...
                       'B'; 'C'; 'C#'; 'D'; 'D#'; 'E'; 'F'; 'F#'; 'G'; 'G#'; 'A'; 'A#'; 'B'; 'C'; 'C#'; 'D'; 'D#'; 'E'; 'F'; 'F#'; 'G'; 'G#'; 'A'; ...
                       'E'; 'F'; 'F#'; 'G'; 'G#'; 'A'; 'A#'; 'B'; 'C'; 'C#'; 'D'; 'D#'; 'E'; 'F'; 'F#'; 'G'; 'G#'; 'A'; 'A#'; 'B'; 'C'; 'C#'; 'D'};


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
%freq_axis = linspace(((-num_samples/2)*(S/num_samples)), (((num_samples/2)-1)*(S/num_samples)), num_samples); %should use num_samples or Nfft in general????
%freq_axis(0,(num_samples/2)*(S/num_samples),Nfft/2);  %attempt to make a 1 sided FFT frequency axis; not working
freq_axis = [(-Nfft/2):(Nfft-1)/2]*(S/Nfft);
abs_shifted_FFT_normalized = fftshift(abs(FFT_normalized));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pitch Detection Algorithm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FFT_normalized = fftshift(FFT_normalized); %center frequency spectrum

zero_freq_index = find(freq_axis == 0); %find index of 0 Hz
[max_peak, max_loc] = max(abs(FFT_normalized(zero_freq_index:length(FFT_normalized)))); %find the max peak value of the FFT and its location
max_loc = max_loc+zero_freq_index-1;

threshold = max_peak*.25; %set a threshold for peak detection

first_peak_loc = 0; %initialize the location of the first peak
first_peak_val = 0; %initialize the value of the first peak
first_peak_flag = 0; %initialize a found flag for the first peak
index = zero_freq_index;
window_Hz = 10; %size of window in Hz
window_indeces = ceil(window_Hz/(1/T)); %number of indeces in window

while ( and((first_peak_flag < 1),(index <= max_loc)) )
    if( abs(FFT_normalized(index)) >= threshold ) % if the threshold is broken
        best_index = index; %initalize the best_index to the current index
        index_count = 0; %initialize counter for the window
        while index_count <= window_indeces %while still inside the window
            while abs(FFT_normalized(index)) >= threshold %while the threshold is still broken
                if abs(FFT_normalized(index)) > abs(FFT_normalized(best_index)) %see if the index is the highest peak
                    best_index = index; %update best_index
                end
                index = index + 1; %increment index for next iteration
                index_count = index_count + 1; %update index_count for next iteration
            end
            index = index + 1; %increment index for next iteration
            index_count = index_count + 1; %update index_count for next iteration
        end
        first_peak_loc = best_index; %save the peaks location
        first_peak_val = abs(FFT_normalized(best_index)); %save the peaks value
        first_peak_flag = first_peak_flag + 1; %set flag indicating the first peak has been found        
    end
    index = index + 1; %increment index for next iteration
end

freq = freq_axis(first_peak_loc); %look up frequency of fundamental based on the location of the first peak

index = 1; %reset the index counter to 1
match_index = -1; %initialize index of closest match to out of bounds for error checking
abs_difference = 100; %set the difference to a large value initially
for index=1:1:length(freq_lib)
    temp = abs( freq_lib(index) - freq ); %find the difference between the fundmamental and the library frequency
    if( temp < abs_difference ) 
        abs_difference  = temp; %update the difference variable
        match_index = index; %save the index of the library frequency that gives the smallest difference
    end
end

note = freq_lib_note_letters(match_index);
x = freq_axis;
y = abs_shifted_FFT_normalized;
fund_val = first_peak_val;
fund_index = first_peak_loc;
end