function [ half_steps_closest ] = getClosestHalfSteps(S, Nfft, f, half_steps)
%function [ half_steps_closest ] = getClosestHalfSteps(S, Nfft, f, half_steps)
%
% DESCRIPTION:
% Determines the appropriate number to choose for the half_steps variable
%   used in complex_exp_shift(). This function ensures that an integer
%   number of FFT bins are moved (to avoid amplitude issues) to get closest
%   to the desired destination frequency.
%
% CALLING PRAMETERS:
%   S = sampling frequency
%   Nfft = number of samples in the FFT
%   f = the frequency to be shifted
%   half_steps = the number of desired half_steps
%
% OUTPUT PARAMETERS:
%   half_steps_closest = the value closest to half_steps which ensures
%   shifting has occured by moving an integer number of FFT bins
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

resolution = S/Nfft;
Fdiff = f*((half_steps)/12); %difference between the peak frequency and the frequency to be shifted to (destination frequency)

half_steps_closest = ((round(Fdiff/resolution)*resolution)/f)*12;

end

