function [best_index] = find_closest(x,desired)
%function [best_index] = find_closest(x,desired)
%
% Description: This function finds the index of the closest value in an
%   array to a desired value. The search is performed as a binary search to
%   achieve close to O(log(N)) performance.
%
% Calling Parameters:
%   x = a 1D array to be searched
%   desired = the value to be searched for
%
% Output Parameters:
%   best_index = the index in the x array with the closest value to desired
%
% D.M.E 12/23/14
    
min = 1;
max = numel(x);
median = ceil((min+max)/2);
num_elements = max;

while num_elements > 2
    if x(median) > desired
        max = median;
        median = ceil((min+max)/2);
        num_elements = max - min + 1;
    elseif x(median) < desired
        min = median;
        median = ceil((min+max)/2);
        num_elements = max - min + 1;        
    else    
        best_index = median;
        num_elements = 2;
        min = median;
        max = median;
    end
end

if abs(x(min)-desired) < abs(x(max)-desired)
    best_index = min;
else
    best_index = max;
end

end