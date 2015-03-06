function [ new_data ] = exp_mod2( wave, Fs, exp_res )
%   Detailed explanation goes here

max_pow2 = floor(log2(length(wave)));
num_samples = 2^max_pow2;
wave = wave(1:num_samples);
dt = 1/Fs;
%duration of sample (milliseconds)
L = num_samples/Fs;  % or call it 'T'

t = [0 : 1/Fs : L-1/Fs];

%get next nearest power of two
NFFT = L*Fs;

row = length(wave);


new_data = zeros(1, row);

b = 1; % starting point
adj = 20; % this is our vague adjustment for now

for i = 1:1:row
  if ((b*adj) > (length(exp_res)))
        b=1;
  end
    new_data(i) = exp_res(b*adj)*wave(i); % change col 1
    b = b+1;    
end


end

