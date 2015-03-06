function [ filtered_sig b] = filter_guitar( filter_width, n, Fs, fc, st )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

half_width = filter_width/2;

% Bandedgesinpairs /// maybe related to angular freq??
% So for example, if filter_width is 80 then the 
% f in Hz = [0 140 180 260 300 4000]
% to convert from normalized frequencies to Hertz multiple each f value by
% Fs/2, which is the normalization constant
f = [0 2*((fc-(half_width*2))/Fs) 2*((fc-half_width)/Fs) 2*((fc+half_width)/Fs) 2*((fc+(half_width*2))/Fs) 1]; 

% Bandpass filter amplitude
a = [0  0  1   1   0   0]; 

b = firpm(n,f,a);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Display the filter coefficients with fvtool for design purposes
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  bb = firls(n,f,a);
%  fvtool(b,1,bb,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Should we be normalize the coeffficients to sum to 1 like below???
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%b=(b)./(sum(b)); % try to bring the sum to 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Take the Hilbert Transform of the Coefficients, now our filter only
% filter the positive 220 Hz.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
b=hilbert(b);

filtered_sig=filter(b,1,st);

% T = 10000;  % or call it 'T'  
% max_pow2 = floor(log2(T));
% num_samples = 2^max_pow2;
% pulse=zeros(1,num_samples);
% pulse(1)=1;
% impulse_response=filter(b,1,pulse);
% M = fft(impulse_response);
% Mjw = fftshift(abs(M));
% figure;
% plot(freq_axis, 10*log10(Mjw_filtered_sig)); hold on;
% plot(freq_axis, 10*log10(Mjw),'r');
% title('FFT of FIRPM + Hilber Coefficients and Impulse Response in Red',...
%     'fontsize',20,'fontweight', 'b');

end

