function [exp_freq exp_name] = get_expected_note(fret_num)
%function [exp_freq exp_name] = get_expected_note(fret_num, freq_array, name_array)
%
%Description: Returns the expected note frequnecy and note letter name for
%   the GuPS1 note detection algorithm
%
%Calling Parameters:
%   fret_num = fret number extracted from file name
%
%Output Parameters:
%   exp_freq = the expected frequency based on the string and fret number
%   exp_name = note name corresponding to exp_freq
%
%D.M.E 12/17/14

    low_E_string_lib = [82,87,92,98,104,110,117,123,131,139,147,156,165,175,185,196,208,220,233,247,262,277,294];
    low_E_string_lib_note_letters = {'E'; 'F'; 'F#'; 'G'; 'G#'; 'A'; 'A#'; 'B'; 'C'; 'C#'; 'D'; 'D#'; 'E'; 'F'; 'F#'; 'G'; 'G#'; 'A'; 'A#'; 'B'; 'C'; 'C#'; 'D'};

    exp_freq = low_E_string_lib(fret_num+1);
    exp_name = low_E_string_lib_note_letters(fret_num+1);
end

