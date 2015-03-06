%add graphics toolkit
%graphics_toolkit fltk

%close all figures currently open


%sampling rate
%this must be at least twice as big
%as the largest frequency component     
S = 1000; 

%width or resulotion of sample rate
dt = 1/S;     

%duration of sample (milliseconds)
L = 1000;  % or call it 'T'   

%time array -- or equivalently t = (0:L-1)*dt;
t = linspace(0,dt*(L-1),S);

%Nyquest sampling thereom
Ns=S/2;

%frequency (Hz)
f1 = 82;     
f2 = 123;
f3 = 165;

%amplitude
A1 = 3;  
A2 = 3;
A3 = 3;

%signals
s1 = A1*sin(2*pi*f1*t);
s2 = A2*sin(2*pi*f2*t);
s3 = A3*sin(2*pi*f3*t);


%generate random noise
noise = 2*randn(size(t));    

%add all the signals
all_signals = s1 + s2 + noise;
s1s2s3 = s1 + s2 ;

%get next nearest power of two
NFFT = 2^nextpow2(L*S);

%take FFT of summed up signals and normalize
transform1 = fft(s1s2s3,NFFT)/L;
transform2 = fft(all_signals,NFFT)/L;

%generate x-axis both time and freq domains, td is time domain and fd is frequency domain
td_xaxis = S*t;
fd_xaxis = linspace(0,Ns,NFFT/2+1);
%fd_xaxis = linspace(0,Ns,NFFT);

 
%%%% generate all plots below%%%%
figure;
subplot(3,3,1);
plot(td_xaxis,s1);
subplot(3,3,2);
plot(td_xaxis,s2);
subplot(3,3,3);
plot(td_xaxis,s3);
subplot(3,3,4);
plot(td_xaxis,s1s2s3);
subplot(3,3,5);
plot(td_xaxis,all_signals);


subplot(3,3,7);
plot(fd_xaxis,2*abs(transform1(1:NFFT/2+1)));
xlim([0 500]);
%plot(fd_xaxis,2*abs(transform1));
title('The     ','fontsize',14,'fontweight', 'b');
xlabel('Frequency (Hz)'); ylabel('Power');



subplot(3,3,8);
plot(fd_xaxis,2*abs(transform2(1:NFFT/2+1)));
%plot(fd_xaxis,2*abs(transform2));
title('The     ','fontsize',14,'fontweight', 'b');
xlabel('Frequency (Hz)'); ylabel('Power');
