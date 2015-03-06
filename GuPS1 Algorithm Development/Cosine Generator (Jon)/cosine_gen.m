% Cosine Value Generator v1.0
%
% This script generates values of the cosine function
% with number of samples being defined at runtime by
% user. The resultant value array is written to a file
% specified by the user as well.
%
% Current Issues:
%   - Matlab evaluates pi to only 4 decimal places. This
%     results in accuracy problems. Ex. cos(pi/2) != 0

%digits(32); % Attempt to force pi to 32 digits.
format long % changes MATLAB workspace to precision to LONG (15 decimal places).
i = input('Enter number of samples: ');
x = 0:(2*pi)/(i-1):2*pi;
res = cos(x);

filename = input('Enter output filename: ', 's');
file = fopen(filename, 'wt');
fprintf(file, '%1.20f\n', res);
fclose(file);
format short % reset MATLAB workspace to default precision of SHORT