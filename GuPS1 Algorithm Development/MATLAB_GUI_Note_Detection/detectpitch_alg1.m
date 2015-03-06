function [x, y, note, freq, fund_val] = detectpitch_alg1(filename)
%function [x y match_index freq] = detectpitch_alg1(filename)
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
%   match_index = The index of the most accurate match.
%   freq = The frequency of the fundamental after detection.
%

[wave, fs] = wavread(filename);

%%library of low E string fret frequencies for reference
low_E_string_lib = [82,87,92,98,104,110,117,123,131,139,147,156,165,175,185,196,208,220,233,247,262,277,294];
low_E_string_lib_note_letters = {'E'; 'F'; 'F#'; 'G'; 'G#'; 'A'; 'A#'; 'B'; 'C'; 'C#'; 'D'; 'D#'; 'E'; 'F'; 'F#'; 'G'; 'G#'; 'A'; 'A#'; 'B'; 'C'; 'C#'; 'D'};


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
work = FFT_normalized(zero_freq_index:length(FFT_normalized)); %create a working subset of the FFT looking a the right half plane
freq_axis_pos = freq_axis(zero_freq_index:length(freq_axis)); %create working subset of frequnecy axis looking at right half plane

[max_peak, max_loc] = max(abs(work)); %find the max peak value of the FFT and its location

threshold = max_peak*.4; %set a threshold for peak detection
first_peak_loc = 0; %initialize the location of the first peak
first_peak_val = 0; %initialize the value of the first peak
first_peak_flag = 0; %initialize a found flag for the first peak
index = 1;
while ( and((first_peak_flag < 1),(index <= max_loc)) )
    if( abs(work(index)) >= threshold ) %if a peak breaks the threshold
        first_peak_loc = index; %save the peaks location
        first_peak_val = abs(work(index)); %save the peaks value
        first_peak_flag = first_peak_flag + 1; %set flag indicating the first peak has been found
    end
    index = index + 1;
end

freq = freq_axis_pos(first_peak_loc); %look up frequency of fundamental based on the location of the first peak


index = 1; %reset the index counter to 1
match_index = -1; %initialize index of closest match to out of bounds for error checking
abs_difference = 100; %set the difference to a large value initially
for index=1:1:length(low_E_string_lib)
    temp = abs( low_E_string_lib(index) - freq ); %find the difference between the fundmamental and the library frequency
    if( temp < abs_difference ) 
        abs_difference  = temp; %update the difference variable
        match_index = index; %save the index of the library frequency that gives the smallest difference
    end
end

note = low_E_string_lib_note_letters(match_index);
x = freq_axis;
y = abs_shifted_FFT_normalized;
fund_val = first_peak_val;
end