%%% Real-Time Speech Pitch Shifting on an FPGA
%%% Estephan, Sawyer, Wanninger
%%% M-File by Habib Estephan (2006)
%%% Villanova University
%%% Department of Electrical and Computer Engineering


%clear
%clc

Nin=wavread('b3_246_9_Hz.wav');%input wave
SampleFreq=44100;%Sampling Frequency of the input
windowsize=1200;%(100e-3)*SampleFreq;
overlap=0.25;                              %Specifies the amount of overlap between 
                                           %two blocks before summing them
numsections=floor(length(Nin)/windowsize); %Specifies the total number of blocks in   
                                           %the input speech signal 
shiftval=round(windowsize*overlap);        %Calcultes the the amount by which we need to
                                           %shift our block before we add
                                           %it to itself in order to
                                           %achieve the desired overlap
Nin=Nin(1:numsections*windowsize);         %adjusts the length of Nin to make it an integer
                                           %multiple of the block size
Nin=Nin';%Input's transpose to make it a 1xM array
adjust=windowsize*(2*overlap-1)+1;          %adjustment variable
x=round(length(Nin)/windowsize);
Nout=(windowsize+shiftval)*x+(-shiftval);
Output=zeros(1,Nout+shiftval);              %Initiates an empty output variable

for n=1:round((length(Nin)/windowsize))
     
section=Nin(windowsize*n-(windowsize-1):windowsize*n);%.*hann(windowsize)';  
%Section contains the corresponding block                                        
%from the input vector
start=(windowsize+shiftval)*n+(1-windowsize-shiftval);                       
%points to the insertion location of a block 
                                           %in the output vector  
last=(windowsize+shiftval)*n+(-shiftval);  %points to end location of a block in the output
Output(start:last)=section;
Output(start+shiftval:last+shiftval)=Output(start+shiftval:last+shiftval)+section;
end
Output=Output(1:last);
ratio=length(Output)/length(Nin);
[t,d]=rat(ratio);                   			%returns the the ratio as a fraction,
                                    			%where the Numerator is stored in t
                                    			%and the denominator is stored in d.

Out1=resample(Output,d,t);          			%in order to play the outputed signal at the
%same rate we have resample it at 
                                    			%a rate that d/t the current sampling rate
                                    			%in order to rescale the output vector and
                                    			%make it the same length as the
                                    			%input
%Sound(Out1,SampleFreq)


player = audioplayer(Out1, SampleFreq);
play(player); 