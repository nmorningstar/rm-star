%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script goes through the data of an array produced by calling
% wavread() on an audio file and prints out each value to a text file by
% the number of rows specified by per_row
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear; close all;

input_file = 'd_chord_8kHz.wav';
[wave, fs] = wavread(input_file);

per_row = 40;
num_rows = ceil(length(wave)/per_row);
fid = fopen('wave_formatted.txt', 'w+');
index = 1;
for i=1:num_rows
   for j=1:per_row
       if index <= length(wave)
           if index == length(wave)
               fprintf(fid, '%f ', wave(index));
               index = index + 1;
           else
               fprintf(fid, '%f, ', wave(index));
               index = index + 1;
           end
       end
   end
   fprintf(fid, '\n');
end
