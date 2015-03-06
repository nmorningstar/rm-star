function [ shifted_wave ] = exp_mod3( wave, t, steps, f)
%function [ output ] = exp_mod3( wave, t, steps, f)
%
% DESCRIPTION:
% This function performs time domain pitch shifting by multiplication of a 
%   complex exponential.
%
% CALLING PARAMETERS:
%   wave = the input signal to be shifted 
%   t = the time axis for the input signal
%   steps = the number of whole steps to be shifted by
%   f = the frequency of the peak to be shifted
%
% OUTPUT PARAMETERS:
%   shifted_wave = the shifted time domain signal

Fdiff = f*((2*steps)/12); %difference between the peak frequency and the frequency to be shifted to
shifted_wave = exp(j*2*pi*Fdiff.*t) .* wave; 

end

