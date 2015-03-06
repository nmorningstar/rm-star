
function varargout = gups_v1(varargin)
% GUPS_V1 MATLAB code for gups_v1.fig
%      GUPS_V1, by itself, creates a new GUPS_V1 or raises the existing
%      singleton*.
%
%      H = GUPS_V1 returns the handle to a new GUPS_V1 or the handle to
%      the existing singleton*.
%
%      GUPS_V1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUPS_V1.M with the given input arguments.
%
%      GUPS_V1('Property','Value',...) creates a new GUPS_V1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gups_v1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gups_v1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gups_v1

% Last Modified by GUIDE v2.5 22-Nov-2014 21:14:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gups_v1_OpeningFcn, ...
                   'gui_OutputFcn',  @gups_v1_OutputFcn, ...
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


% --- Executes just before gups_v1 is made visible.
function gups_v1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gups_v1 (see VARARGIN)

set(handles.ssc_button,'Enable','off');  %disable ssc
set(handles.fsc_button,'Enable','off');  %disable fsc

% Choose default command line output for gups_v1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gups_v1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gups_v1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in vc_button.
function vc_button_Callback(hObject, eventdata, handles)
% hObject    handle to vc_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of vc_button


if (get(hObject,'Value')==1)
    set(handles.ssc_button,'Enable','on')  % Enable ssc
    set(handles.fsc_button,'Enable','on')  % Enable fsc   
end
if (get(hObject,'Value')==0)
    set(handles.ssc_button,'Enable','off')  % Disable ssc
    set(handles.fsc_button,'Enable','off')  % Disable fsc
    set(handles.ssc_button,'Value',0)       % Make unselected
    set(handles.fsc_button,'Value',0)       % Make unselected
    axes(handles.after);
    plot(cos(0)); % basically plot nothing to make it
    % look like it turned off correctly
    axes(handles.before);
    plot(sin(0)); % basically plot nothing to make it
    % look like it turned off correctly
end

%top(handles); % leave here, natalie was playing with this.

% --- Executes on selection change in pop_up_pitch_steps.
function pop_up_pitch_steps_Callback(hObject, eventdata, handles)
% hObject    handle to pop_up_pitch_steps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_up_pitch_steps contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_up_pitch_steps


% --- Executes during object creation, after setting all properties.
function pop_up_pitch_steps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_up_pitch_steps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in fsc_button.
function fsc_button_Callback(hObject, eventdata, handles)
% hObject    handle to fsc_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fsc_button


% just testing action of button with generic data

if (get(hObject,'Value')==1)
    axes(handles.before);
    plot(sin(0:.1:2*pi)); % the bellow data set will need to be changed
    % with the right data when we have it.
end

if (get(hObject,'Value')==0)
   axes(handles.before);
   plot(sin(0)); % basically plot nothing to make it
   % look like it turned off correctly
end



% --- Executes on button press in ssc_button.
function ssc_button_Callback(hObject, eventdata, handles)
% hObject    handle to ssc_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ssc_button


% just testing action of button with generic data

if (get(hObject,'Value')==1)
    axes(handles.after);
    plot(cos(0:.1:2*pi)); % the bellow data set will need to be changed
    % with the right data when we have it.
end

if (get(hObject,'Value')==0)
   axes(handles.after);
   plot(cos(0)); % basically plot nothing to make it
   % look like it turned off correctly
end

