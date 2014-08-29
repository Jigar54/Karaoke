function varargout = Karaoke(varargin)
%
%[Function Description]
%This program attempts to create karaoke of a song. It attempts to remove
%voice and then writes it to a new wav file.
%[Algorithm]
%This program utilizes the well known fact that voice is recorded equally in both channels
%without any stereo effect.
%First one of the channel is high pass filterd. This is done to protect the
%low end bass which is also recorded equally on both channels. Then this
%channel is subtracted from the other. The commoon part that is voice gets
%cancelled.This method is called the OUT of PHASE STEREO (OOPS) technique.
%But The use of high pass filters is a new addition to ampify the bass and drums value first before minimizing vocals.
%Butterworth filter is used for the purpose.
%Best use set the high pass cut off for 50Hz and try



% Begin initialization code
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Karaoke_OpeningFcn, ...
                   'gui_OutputFcn',  @Karaoke_OutputFcn, ...
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
% End initialization code
function Karaoke_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);

function varargout = Karaoke_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% Executes during object creation, after setting all properties.
function path_txt_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Executes on button press in input_btn.
function input_btn_Callback(hObject, eventdata, handles)

[file, path] = uigetfile('*.wav','Select a .wav file');
if file == 0
    return
end
set(handles.path_txt,'String',[path file]);


% --- Executes during object creation, after setting all properties.
function out_txt_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in output_btn.
function output_btn_Callback(hObject, eventdata, handles)

out_dir = uigetdir(cd,'Choose output folder');
if out_dir == 0
    return;
end
set(handles.out_txt,'String',out_dir);


% --- Executes on button press in go_btn.
function go_btn_Callback(hObject, eventdata, handles)

set(handles.path_txt,'Enable','off');
set(handles.input_btn,'Enable','off');
set(handles.out_txt,'Enable','off');
set(handles.output_btn,'Enable','off');
set(handles.fc_slider,'Enable','off');
set(handles.hpcut_txt,'Enable','off');

file = get(handles.path_txt,'String');
try
    [y,Fs,nbits]= wavread(file);
catch
    msgbox('Invalid File');
    set(handles.path_txt,'Enable','on');
    set(handles.input_btn,'Enable','on');
    set(handles.out_txt,'Enable','on');
    set(handles.output_btn,'Enable','on');
    set(handles.fc_slider,'Enable','on');
    set(handles.hpcut_txt,'Enable','on');
    return;
end
if size(y,2) == 1
    msgbox('The selected file is Mono. This algorithm is applicable ONLY for Stereo files.');
    set(handles.path_txt,'Enable','on');
    set(handles.input_btn,'Enable','on');
    set(handles.out_txt,'Enable','on');
    set(handles.output_btn,'Enable','on');
    set(handles.fc_slider,'Enable','on');
    set(handles.hpcut_txt,'Enable','on');
    return;
end

warning off all;
%High pass filter
fc = str2double(get(handles.hpcut_txt,'String'));
fc = round(fc);
%filter used so that some drums and bass value with generally match with
%the vocals are saved from being removed.
if fc > 20
    fp = fc+5;
    fs = fc/(Fs/2);
    fp = fp/(Fs/2);
    [n wn] = buttord(fp,fs,0.5,80);
    [b, a] = butter(5,wn,'High');
    channel_2 = filtfilt(b,a,y(:,2));
%    subplot(2, 2, 2);
%    plot(channel_2);
else
    channel_2 = y(:,2);
   end

%Remove voice
%Subtract the two channels into a single channel
karaoke_wav = y(:,1) - channel_2;

%Write it to a file
[p name ext] = fileparts(file);
dir = get(handles.out_txt,'String');
if isdir(dir)
    wavwrite(karaoke_wav,Fs,nbits,[dir '\' name ext]);
else
    wavwrite(karaoke_wav,Fs,nbits,[cd '\' name ext]);
end

set(handles.path_txt,'Enable','on');
set(handles.input_btn,'Enable','on');
set(handles.out_txt,'Enable','on');
set(handles.output_btn,'Enable','on');
set(handles.fc_slider,'Enable','on');
set(handles.hpcut_txt,'Enable','on');

%Executes on slider movement.
function fc_slider_Callback(hObject, eventdata, handles)

slide_input = get(handles.fc_slider,'Value');
set(handles.hpcut_txt,'String',num2str(slide_input*500));

%Executes during object creation, after setting all properties.
function fc_slider_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%Executes during object creation, after setting all properties.
function hpcut_txt_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function uipanel1_ButtonDownFcn(hObject, eventdata, handles)



% --------------------------------------------------------------------
function uipanel3_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uipanel3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
