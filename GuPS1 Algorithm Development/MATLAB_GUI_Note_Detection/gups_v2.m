
function varargout = gups_v2(varargin)
% GUPS_V2 MATLAB code for gups_v2.fig
%      GUPS_V2, by itself, creates a new GUPS_V2 or raises the existing
%      singleton*.
%
%      H = GUPS_V2 returns the handle to a new GUPS_V2 or the handle to
%      the existing singleton*.
%
%      GUPS_V2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUPS_V2.M with the given input arguments.
%
%      GUPS_V2('Property','Value',...) creates a new GUPS_V2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI out_graph gups_v2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gups_v2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gups_v2

% Last Modified by GUIDE v2.5 17-Dec-2014 23:19:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gups_v2_OpeningFcn, ...
                   'gui_OutputFcn',  @gups_v2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% SET FORMAT
format long;








% --- Executes just out_graph gups_v2 is made visible.
function gups_v2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gups_v2 (see VARARGIN)

set(handles.push_play,'Enable','off');  %disable play
set(handles.push_detect,'Enable','off');  %disable detect
axes(handles.out_graph);



% Choose default command line output for gups_v2
%handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gups_v2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gups_v2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in push_open.
function push_open_Callback(hObject, eventdata, handles)
% hObject    handle to push_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%Open File selection UI showing only .wav files.
global input_file
[input_file, input_path, trash] = uigetfile('./*.wav');

%If valid file selected...
if(input_file ~= 0)
    %Enable Play button.
    set(handles.push_play, 'Enable', 'on');
    %Enable Detect button.
    set(handles.push_detect, 'Enable', 'on');
    
    %If note is not sharp, then save only note character.
    if(input_file(15) ~= '#')
        expected_note = input_file(14);
    %Otherwise save note character and # as well.
    else
        expected_note = input_file(14:15);
    end
    
    fret_num = str2num(input_file(11:12)); %Get fret number from filename.
    [expected_freq, trash] = get_expected_note(fret_num); %Call Dave's function to return the expected frequency.
    
    %Update expected note to value from filename.
    set(handles.exp_note, 'String', expected_note);
    %Update expected frequency to correct value.
    set(handles.exp_freq, 'String', num2str(expected_freq));
    
    %Clear actual note and frequency, as well as graph, since detect has
    %not been pressed yet.
    set(handles.act_note, 'String', 'X'); %Clear actual note.
    set(handles.act_freq, 'String', '0'); %Clear actual freq.
    axes(handles.out_graph);
    plot(0);
    
else %If invalid file selected, or selection window is closed...
    set(handles.push_play, 'Enable', 'off'); %Disable Play button
    set(handles.push_detect, 'Enable', 'off'); %Disable Detect button
    set(handles.exp_note, 'String', 'X'); %Clear expected note.
    set(handles.exp_freq, 'String', '0'); %Clear expected freq.
    set(handles.act_note, 'String', 'X'); %Clear actual note.
    set(handles.act_freq, 'String', '0'); %Clear actual freq.
    axes(handles.out_graph);
    plot(0);
end    




% --- Executes on button press in push_play.
function push_play_Callback(hObject, eventdata, handles)
% hObject    handle to push_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stereo = 2;
mono = 1;

%audio_input = 'e_string_highest_note.wav';
global input_file
if(~(exist(input_file,'file')))
    errordlg('Error: File doesnt exist or is unreadable',audio_input);
else
[wave, Fs] = wavread(input_file);

row = length(wave);
col = stereo;

%if (get(hObject,'Value')==1)
%    axes(handles.out_graph);
%    plot(wave); % the bellow data set will need to be changed
    % with the right data when we have it.
   
%    M = fft(wave);
%    Mjw = fftshift(M);
%    omega = (-149426/2:1:(149426/2) - 1);
%    axes(handles.before_fft);
%    plot(omega, abs(Mjw));
    
%end

%if (get(hObject,'Value')==0)
%    axes(handles.out_graph);
%    plot(0); 
%    axes(handles.before_fft);
%    plot(0);
%end


handles.r=audioplayer(wave,Fs);
% PLAY SOURCE AUDIO FILE
play(handles.r);
guidata(hObject,handles); % update handles 
end



% --- Executes on button press in push_detect.
function push_detect_Callback(hObject, eventdata, handles)
% hObject    handle to push_detect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global input_file
[x_axis, y_axis, actual_note, actual_freq, fund_val, fund_index, max_peak] = detectpitch_alg4(input_file);

set(handles.act_note, 'String', actual_note); %Set actual note.
set(handles.act_freq, 'String', num2str(actual_freq)); %Set actual freq.

axes(handles.out_graph);
plot(x_axis, y_axis);
hold on;
xlim([-2000, 2000]);
xlabel('Frequency (Hz)','fontsize',20,'fontweight','b','color','k');
ylabel('|H(F)|','fontsize',20,'fontweight','b','color','k');
plot(actual_freq, fund_val, 'r--o');
hold off;