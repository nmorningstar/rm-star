% Simulation script for Controlled Envelope SSB (CESSB)
% by David L. Hershberger W9GR
%
% This script was written for GNU Octave, but this
% version was edited to work with Matlab.
%
% First read in the audio from the peak-limited WAV file.
% The peak of the audio value is expected to be sqrt(0.5) (-3 dB)
% and the sampling rate is expected to be 48 kHz
% [audio,fs]=wavread('SSBaudioprocessed.wav');
[audio,fs]=audioread('SSBaudioprocessed.wav');
nspeech=length(audio);
audiopeak1=max(abs(audio));
% Append a 1 kHz, 1 second sinewave audio tone burst after the audio
ftone=1000;
time=linspace(0,(fs-1)/fs,fs);
audio=[audio;sqrt(0.5)*sin(2*pi*time*ftone).'];
% Append silence after the tone
nsilence=2^14;
audio=[audio;zeros(nsilence,1)];
%
% Append a squarewave (optional, uncomment to do this)
% fsquare=100;
% audio=[audio;sqrt(0.5)*square(time*fsquare*2*pi,.5).'];
% Append silence after the squarewave
% audio=[audio;zeros(nsilence,1)];
%
audiopeak2=max(abs(audio));
% ns is the number of audio samples
ns=length(audio);
% Make Weaver LPF
% The number of coefficients is large because
% the sampling rate is high - 48 kHz.
% For the same shape factor, the number of coefficients
% will go down in proportion to the reduced sampling rate.
nweaver=1820;
fnyq=fs/2;
fcut=1350;
fstop=1450;
fremez=[0,fcut/fnyq,fstop/fnyq,1];
aremez=[1,1,0,0];
weaverlpf=remez(nweaver,fremez,aremez);
nweaver=length(weaverlpf);
% Sweep and plot the resulting filter
nw=400;
f1=0;
f2=fnyq*nw/(nw+1);
w1=2*pi*f1/fs;
w2=2*pi*f2/fs;
fweaver=linspace(f1,f2,nw);
wweaver=2*pi*fweaver/fs;
wweaverresp=freqz(weaverlpf,1,wweaver);
plot(fweaver,20.0*log10(abs(wweaverresp)));
% Make second slightly wider Weaver LPF
nweaver2=1730;
fcut2=1450;
fstop2=1550;
fremez2=[0,fcut2/fnyq,fstop2/fnyq,1];
weaverlpf2=remez(nweaver2,fremez2,aremez);
nweaver2=length(weaverlpf2);
% Sweep and plot the resulting filter
wweaverresp2=freqz(weaverlpf2,1,wweaver);
plot(fweaver,20.0*log10(abs(wweaverresp2)));
% Set the Weaver folding frequency to be the arithmetic mean
% of the low and high frequency cutoffs
ffold=0.5*(300+3000);
time=linspace(0,(ns-1)/fs,ns).';
% Create the Weaver folding carrier
wcarrier=exp(1i*time*2*pi*ffold);
weaveriq=filter(weaverlpf,1,audio.*wcarrier);
% Set the envelope level corresponding to 100% modulation
emax=sqrt(0.5)/2;
% Create the divider signal for RF clipping
rfclipdenom=max(emax,abs(weaveriq))/emax;
% Form the unfiltered, RF clipped signal
rfclip=weaveriq./rfclipdenom;
% rfclipfil is the output of the conventional 'RF clipper'
rfclipfil=filter(weaverlpf,1,rfclip);
env=abs(rfclipfil);
% overshootcomp is the nonlinearly overshoot-compensated signal before final filtering
lenv=length(env);
% Do the peak stretching
lhold=2;
envhold=env;
for ihold=-lhold:1:-1
  envhold=max(envhold,[zeros(-ihold,1);env(1:lenv+ihold)]);
end
for ihold=1:1:lhold
  envhold=max(envhold,[env(1+ihold:lenv); zeros(ihold,1)]);
end
% Form the clippings signal
clippings=max(1,envhold/emax)-1;
% Set the gain factor
x1=2.0;
% Create the divider signal
overshootdiv=1+x1*clippings;
% Do the overshoot compensation
overshootcomp=rfclipfil./overshootdiv;
% Do the final filtering to produce the system output
cessbsig=filter(weaverlpf2,1,overshootcomp);
%
plot(time,abs(cessbsig)/emax);
pkssb=max(abs(weaveriq));
pkrfclip=max(abs(rfclipfil));
pkcessb=max(abs(cessbsig));
% Demodulate SSB from Weaver signal and write to file
demod=conj(wcarrier).*weaveriq;
peakaudio=max(abs(demod));
audioout=(sqrt(0.5)/peakaudio)*demod;
% wavwrite(real(audioout),fs,'ssbdemod.wav');
audiowrite('ssbdemod.wav',real(audioout),fs);
% Demodulate SSB from cessb signal and write to file
demod=conj(wcarrier).*cessbsig;
audioout=(sqrt(0.5)/peakaudio)*demod;
% wavwrite(real(audioout),fs,'cessbdemod.wav');
audiowrite('cessbdemod.wav',real(audioout),fs);


% Produce output plots

% Plot the spectra of just the speech signals (up to 12 seconds)
%nspeech=ns;
%nfspec=512;
%fspec=0.5*fs*linspace(-nfspec/2+0.5,nfspec/2-0.5,nfspec)/nfspec;
nfft=4096;
%[weaveriqspec,fspec]=pwelch(weaveriq(1:nspeech),[],[],nfft,fs,'whole');
%[rfclipspec,fspec]=pwelch(rfclip(1:nspeech),[],[],nfft,fs,'whole');
%[weaveriqspec,fspec]=pwelch(weaveriq(1:nspeech),[],0.5,nfft,fs,'shift');
[weaveriqspec,fspec]=pwelch(weaveriq(1:round(nspeech)),[],[],nfft,fs,'centered');
[rfclipspec,fspec]=pwelch(rfclip(1:nspeech),[],[],nfft,fs,'centered');
[overshootcompspec,fspec]=pwelch(overshootcomp(1:nspeech),[],[],nfft,fs,'centered');
dbpmax=10*log10(max([weaveriqspec;rfclipspec;overshootcompspec]));
dbweaveriqspec=10*log10(weaveriqspec)-dbpmax;
dbrfclipspec=10*log10(rfclipspec)-dbpmax;
dbovershootcompspec=10*log10(overshootcompspec)-dbpmax;
plot(fspec,dbweaveriqspec,fspec,dbrfclipspec,fspec,dbovershootcompspec);
axis([-fs/2,fs/2,-80,0]);
grid on;
saveas(1,'ssb-spectra.png')

n1=1;
n2=ns;
pk=0.1*ceil(10*max(abs(weaveriq/emax)));
ndelssb=round(1+length(weaverlpf)/2)-1;
ndelovsc=ndelssb+round(1+length(weaverlpf2)/2)-1;
%  Plot all three graphs together in different colors
plot(time(n1:n2),abs(weaveriq(n1:n2))/emax,'b',time(n1:n2-ndelssb),abs(rfclipfil(n1+ndelssb:n2))/emax,'r',time(n1:n2-ndelovsc),abs(cessbsig(n1+ndelovsc:n2))/emax,'g');
axis([0,ceil(ns/fs),0,pk]);
xlabel ('Time (seconds)');
ylabel ('Envelope (SSB, clipped SSB, overshoot compensated SSB)');
grid on;
saveas(1,'ssb-all.png')
%
plot(time(n1:n2),abs(weaveriq(n1:n2))/emax,'linewidth',2);
axis([0,ceil(ns/fs),0,pk]);
xlabel ('Time (seconds)');
ylabel ('Uncorrected SSB Envelope');
grid on;
saveas(1,'ssb-ordinary.png')
%
plot(time(n1:n2),abs(rfclipfil(n1:n2))/emax,'linewidth',2);
xlabel ('Time (seconds)');
ylabel ('Baseband Clipped SSB Envelope');
grid on;
saveas(1,'ssb-rf-clipped.png')
%
plot(time(n1:n2),abs(cessbsig(n1:n2))/emax,'linewidth',2);
xlabel ('Time (seconds)');
ylabel ('CESSB Envelope');
grid on;
saveas(1,'cessb.png')

pkssb=pkssb/emax;
pkrfclip=pkrfclip/emax;
pkcessb=pkcessb/emax;
dbpkssb=20.0*log10(pkssb);
dbpkrfclip=20.0*log10(pkrfclip);
dbpkcessb=20.0*log10(pkcessb);
rmsssb=sqrt(sum(weaveriq.*conj(weaveriq))/ns);
rmscessb=sqrt(sum(cessbsig.*conj(cessbsig))/ns);
fprintf('Peak of SSB                     %f\n',pkssb);
fprintf('Peak of clipped SSB             %f\n',pkrfclip);
fprintf('Peak of controlled envelope SSB %f\n',pkcessb);
fprintf('RMS of controlled envelope SSB  %f\n',rmscessb);
fprintf('RMS of SSB                      %f\n',rmsssb);
powergain=((rmscessb/rmsssb)*(pkssb/pkcessb))^2;
powergaindb=10*log10(powergain);
fprintf('Power gain (db)                 %f\n',powergaindb);
fprintf('Power gain (percent)            %f%%\n',100*(powergain-1));

% Modulate a 16 kHz 'carrier' with the baseband signals.
% Scale the modulation levels to produce the same PEP
% with conventional SSB and CESSB. Write the result to
% a WAV file. This can be used to compare RF envelopes
% on a dual-trace scope.
fcarrier=16e3;
rfcarrier=exp(1i*time*2*pi*fcarrier);
audioout=(sqrt(0.5)/emax)*[rfcarrier.*weaveriq/pkssb,rfcarrier.*cessbsig/pkcessb];
% Calculate and print the peak values of the audio signal
fprintf('Peak of SSB 16 kHz signal  = %f\n',max(abs(audioout(:,1))));
fprintf('Peak of CESSB 16 kHz signal= %f\n',max(abs(audioout(:,2))));
% wavwrite(real(audioout),fs,'rfmod.wav');
audiowrite('rfmod.wav',real(audioout),fs);

