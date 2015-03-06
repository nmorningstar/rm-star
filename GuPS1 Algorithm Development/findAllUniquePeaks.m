%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script will find all of the unique theoretical peak values of all
% fundamentals and harmnics on the entire guitar.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; close all; clear;

D = dir('C:\Users\Dave\Documents\School Documents\CMPE 450\GuPS\audio files\all_notes');
%D = dir('C:\Users\Dave\Documents\GitHub\CMPE450\audio files\low_e_notes_mono_long');

fid_debug = fopen('findAllUniquePeaks_DEBUG.txt', 'w+');%open file to log output for debugging

%%% library of fret frequencies
note_lib = [82,87,92,98,104,110,117,123,131,139,147,156,165,175,185,196,208,220,233,247,262,277,294, ...
              110,117,123,131,139,147,156,165,175,185,196,208,220,233,247,262,277,294,311,330,349,370,392, ...
              147,156,165,175,185,196,208,220,233,247,262,277,294,311,330,349,370,392,415,440,466,494,523, ...
              196,208,220,233,247,262,277,294,311,330,349,370,392,415,440,466,494,523,554,587,622,659,698, ...
              247,262,277,294,311,330,349,370,392,415,440,466,494,523,554,587,622,659,698,740,784,831,880, ...
              330,349,370,392,415,440,466,494,523,554,587,622,659,698,740,784,831,880,932,988,1047,1109,1175, ...
              1245,1319,1397,1480,1568,1661,1760,1865,1976,2093,2217,2349,2489,2637,2794,2960,3136,3322,3520,3729,3951,4186,4435,4699,4978,5274];
note_lib = unique(note_lib);

temp_list = zeros(1,1000);
diff_temp_list = zeros(1,(6*23));
diff_index = 1;

amp_threshold_factor = .03;
index = 1;
save = 0;
max_diff = 0;
diff_temp = 0;

list_length = 0;
for file = D'
   if ~strcmp(file.name, '.') && ~strcmp(file.name, '..');
       display(['File: ', file.name]);
       fprintf(fid_debug, 'File: %s\n', file.name);
       [lib_freq, num_harmonics] = findFundAndNumHarms(file.name, note_lib, amp_threshold_factor);
       display(['Theoretical Frequency: ', num2str(lib_freq)]);
       fprintf(fid_debug, 'Theoretical Frequency: %d\n', lib_freq);
       display(['Harmonic Count: ', num2str(num_harmonics)]);
       fprintf(fid_debug, 'Harmonic Count: %d\n', num_harmonics);

       for i=1:(num_harmonics+1)
           value = lib_freq*i;
           
           temp_index = 1; %reset the index counter to 1
           match_index = -1; %initialize index of closest match to out of bounds for error checking
           abs_difference = 1000; %set the difference to a large value initially
           temp = 0;
           for temp_index=1:1:length(note_lib)
               temp = abs( note_lib(temp_index) - value ); %find the difference between the fundmamental and the library frequency
               if( temp < abs_difference ) 
                   abs_difference  = temp; %update the difference variable
                   diff_temp = temp;
                   %display(['DIFF TEMP: ', num2str(diff_temp)]);
                   match_index = temp_index; %save the index of the library frequency that gives the smallest difference
               end
           end
           
           if diff_temp > max_diff
               max_diff = diff_temp;
               max_diff_file = file.name;
           end
           
           if match_index >= 0
               value = note_lib(match_index);
           else
               display(['BAD Value: ', num2str(value), ' Harmonic Count: ', num2str(num_harmonics)]);
               fprintf(fid_debug, 'BAD Value: %d Harmonic Count: %d\n', value, num_harmonics);
               display(['BAD File Name: ', file.name]);
               fprintf(fid_debug, 'BAD File Name: %s\n', file.name);
           end
           display(['Value: ', num2str(value)]);
           fprintf(fid_debug, 'Value: %d\n', value);
           if isempty(find(temp_list == value))
               %display(['HERE']);
               temp_list(index) = value;
               index = index + 1;
               list_length = list_length + 1;
           else
               save = save + 1;
           end
       end
       diff_temp_list(diff_index) = diff_temp;
       fprintf(fid_debug, 'DIFF TEMP: %d\n', diff_temp);
       diff_index = diff_index + 1;
   end
end

%%% loop to print temp_list values out to a file
freq_list = zeros(1, list_length);
index = 1;
fid = fopen('Unique_Frequencies_List.txt', 'w+');
if fid > 0
    for i=1:length(temp_list)
        if ~temp_list(i) == 0
            %display(['Value: ', num2str(temp_list(i))]);
            fprintf(fid, '%d\n', temp_list(i));
            freq_list(index) = temp_list(i);
            index = index + 1;
        end
    end
end
display(['Unique Frequencies: ', num2str(length(freq_list))]);
fprintf(fid_debug, '\nUnique Frequencies: %d\n', length(freq_list));
display(['Savings: ', num2str(save)]);
fprintf(fid_debug, 'Savings: %d\n', save);
display(['Max Quantization: ', num2str(max_diff)]);
fprintf(fid_debug, 'Max Quantization: %d\n', max_diff);
display(['Max Quantization File Name: ', max_diff_file]);
fprintf(fid_debug, 'Max Quantization File Name: %s\n', max_diff_file);

fclose(fid);
fclose(fid_debug);

