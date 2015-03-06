function best_match = get_library_note( best_index, name_array )
%function best_match = get_library_note(best_index, name_array)
%
%Description: Returns the note name of the best match found in the library
%   for the GuPS1 note detection algorithm.
%
%Calling Parameters:
%   best_index = the index containing the best match found in the note
%       library
%   name_array = the note name library
%
%Output Parameters:
%   best_match = the note name corresponding to the best match in the note
%       library
%
%D.M.E 12/17/14
    if(best_index >= 0) %if best_index is still negative, some error occured in the library lookup
        disp(['best_index: ', num2str(best_index)]);
        fprintf('Note letter: %s\n', name_array{best_index});
    end
    best_match = name_array(best_index);
end

