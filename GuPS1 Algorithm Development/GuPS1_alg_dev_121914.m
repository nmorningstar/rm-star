close all;
clc;
TSTART = tic; % start stopwatch

%open an audio file
%input_file = 'low_e_fret01(F)_long.wav';
%input_file = 'low_e_fret10(D)_long.wav';
%input_file = 'low_e_open.wav';
%input_file = 'low_e_fret12(E)_long.wav';
input_file = 'low_e_open_long.wav';
[wave, fs] = wavread(input_file);

%%library of low E string fret frequencies for reference
low_E_string_lib = [82,87,92,98,104,110,117,123,131,139,147,156,165,175,185,196,208,220,233,247,262,277,294];
low_E_string_lib_note_letters = {'E'; 'F'; 'F#'; 'G'; 'G#'; 'A'; 'A#'; 'B'; 'C'; 'C#'; 'D'; 'D#'; 'E'; 'F'; 'F#'; 'G'; 'G#'; 'A'; 'A#'; 'B'; 'C'; 'C#'; 'D'};

%%%%%%%% Testing of get_expected_note() function %%%%%%%%%%%%%%%%%%%%%%%%%%
% [exp_freq, exp_name] = get_expected_note(18, low_E_string_lib, low_E_string_lib_note_letters);
% disp(['Expected Note Frequency: ', num2str(exp_freq)]);
% fprintf('Expected Note Letter: %s\n', exp_name{1});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%determine max integer power of 2 number of samples in the input file
max_pow2 = floor(log2(length(wave)));
num_samples = 2^max_pow2; %number of relevant samples of the input signal

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find min num samples to accurately detect pitch of a single note
% [max_peak_TD, max_loc_TD] = max(abs(wave));
% powers_of_2 = zeros(1, max_pow2);
% 
% index = 1;
% for index=1:1:max_pow2
%     powers_of_2(index) = 2^index;
% end
% 
% threshold = .025*max_peak_TD;
% counter = 1;
% index = max_loc_TD;
% flag = 0;
% while and(index <= length(wave), flag < 1)
%     if abs(wave(index)) >= threshold
%         counter = counter + 1;
%     end
%     index = index + 1;
% end
% 
% wave2 = wave(max_loc_TD:max_loc_TD+counter-1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S = fs; %set sampling frequency of FFT same a sampling freq. of recording
wave = wave(1:num_samples); %discard samples beyon 2^ max power of 2
T = num_samples/S;
Nfft = T*S;
dt = 1/S;
n = [0:num_samples-1]; %indeces
t=n*dt;                    
t1 = [0 : 1/S : T-1/S];
    
%plot input signal in dB
figure(1);
plot(t1, 20*log(abs(wave)));
title('Input Signal (pow 2 number of samples)');
xlabel('Time (s)');
ylabel('Amplitude (dB)');

%plot input signal
figure(2);
plot(t1, wave);
title('Input Signal (pow 2 number of samples)');
xlabel('Time (s)');
ylabel('Amplitude');

%take a normalized FFT of the input signal
[FFT_normalized] = fft(wave)/Nfft;
%freq_axis = linspace(((-num_samples/2)*(S/num_samples)), (((num_samples/2)-1)*(S/num_samples)), num_samples); %should use num_samples or Nfft in general????
%freq_axis(0,(num_samples/2)*(S/num_samples),Nfft/2);  %attempt to make a 1 sided FFT frequency axis; not working
freq_axis = [(-Nfft/2):(Nfft-1)/2]*(S/Nfft);
abs_shifted_FFT_normalized = fftshift(abs(FFT_normalized));

figure(3);
plot(freq_axis, abs_shifted_FFT_normalized);
hold on;
title('FFT');
xlabel('Frequency (Hz)');
ylabel('|H(F)|');
xlim([-2000, 2000]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pitch Detection Algorithm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FFT_normalized = fftshift(FFT_normalized); %center frequency spectrum

zero_freq_index = find(freq_axis == 0); %find index of 0 Hz
work = FFT_normalized(zero_freq_index:length(FFT_normalized)); %create a working subset of the FFT looking a the right half plane
freq_axis_pos = freq_axis(zero_freq_index:length(freq_axis)); %create working subset of frequnecy axis looking at right half plane

[max_peak, max_loc] = max(abs(work)); %find the max peak value of the FFT and its location

threshold = max_peak*.4; %set a threshold for peak detection

threshold_array = ones(1, length(freq_axis)) * threshold;

figure(3);
plot(freq_axis, threshold_array, 'r--'); %plot threshold line on FFT
hold off;

first_peak_loc = 0; %initialize the location of the first peak
first_peak_val = 0; %initialize the value of the first peak
first_peak_flag = 0; %initialize a found flag for the first peak
index = 1;
window_Hz = 10; %size of window in Hz
window_indeces = ceil(window_Hz/(1/T)); %number of indeces in window

while ( and((first_peak_flag < 1),(index <= max_loc)) )
    if( abs(work(index)) >= threshold )
        best_index = index;
        index_count = 0;
        while index_count <= window_indeces
            while abs(work(index)) >= threshold
                if abs(work(index)) > abs(work(best_index))
                    best_index = index;
                end
                index = index + 1;
                index_count = index_count + 1;
            end
            index = index + 1;
            index_count = index_count + 1;
        end
        first_peak_loc = best_index; %save the peaks location
        first_peak_val = abs(work(best_index)); %save the peaks value
        first_peak_flag = first_peak_flag + 1; %set flag indicating the first peak has been found        
    end
    index = index + 1;
end

fundamental = freq_axis_pos(first_peak_loc); %look up frequency of fundamental based on the location of the first peak

disp(['first peak location in work array: ', num2str(first_peak_loc)]);
disp(['first peak value: ', num2str(first_peak_val)]);
disp(['fundamental: ', num2str(fundamental)]);

figure(3);
hold on;
plot(freq_axis_pos(first_peak_loc), first_peak_val, 'r--o'); %plot the fundamental on the FFT

index = 1; %reset the index counter to 1
best_index = -1; %initialize index of closest match to out of bounds for error checking
abs_difference = 100; %set the difference to a large value initially
for index=1:1:length(low_E_string_lib)
    temp = abs( low_E_string_lib(index) - fundamental ); %find the difference between the fundmamental and the library frequency
    if( temp < abs_difference ) 
        abs_difference  = temp; %update the difference variable
        best_index = index; %save the index of the library frequency that gives the smallest difference
    end
end

%%%% Testing of get_library_note() function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
best_match_name = get_library_note(best_index, low_E_string_lib_note_letters);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elapsed_time = toc(TSTART);
disp(['Elapsed time: ', num2str(elapsed_time)]);

% Questions:
% 1.) how to change S, T, num_samples to fix resolution at about 4-5 Hz?
% 2.) how to automate code to take a reading every so many seconds (maybe every .2 or so)?
% 3.) how to try algorithm on 1/8 note samples?
%    - would we need to find peaks of every strike and only look in between th peaks or there another way?
% 4.) Are the values we use for THD rms values? Should they be? How to
%   convert?






