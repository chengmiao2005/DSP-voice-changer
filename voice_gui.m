 % GUI 初始化代码（由 GUIDE 自动生成）
function varargout = voice_gui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name', mfilename, 'gui_Singleton', gui_Singleton, ...
    'gui_OpeningFcn', @voice_gui_OpeningFcn, 'gui_OutputFcn', @voice_gui_OutputFcn, ...
    'gui_LayoutFcn', [], 'gui_Callback', []);
if nargin && ischar(varargin{1}), gui_State.gui_Callback = str2func(varargin{1}); end
if nargout, [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else, gui_mainfcn(gui_State, varargin{:}); end



function voice_gui_OpeningFcn(hObject, ~, handles, ~)
handles.output = hObject;
handles.y = []; handles.Fs = 8192;
for ax = [handles.axes1, handles.axes2, handles.axes3, handles.axes4]
    axes(ax); cla; text(0.5,0.5,'未录音','HorizontalAlignment','center');
end
guidata(hObject, handles);

function varargout = voice_gui_OutputFcn(~, ~, handles)
varargout{1} = handles.output;

function pushbutton4_Callback(~, ~, handles)
if isempty(handles.y), msgbox('请先录音','提示'); return; end
sound(handles.y, handles.Fs);

function pushbutton9_Callback(hObject, ~, handles)
delete(handles.figure1);

function pushbutton21_Callback(hObject, ~, handles)
fs = 8192;
rec = audiorecorder(fs,16,1);
disp('开始录音...'); recordblocking(rec,4); disp('录音结束，处理中...');
y = getaudiodata(rec); handles.y = y; handles.Fs = fs;
guidata(hObject, handles);

axes(handles.axes1); plot(y); grid; title('原始语音信号'); xlabel('样点数');
[Y1,w] = voice_spectrum(y,fs);
axes(handles.axes2); plot(w,Y1); grid; axis([0 2000 0 max(Y1)*1.1]);
title('原始频谱'); xlabel('Hz');

s_syn = lpc_male_to_female(y, fs);

sound(s_syn, fs);
disp('变声播放完成');

axes(handles.axes3); plot(s_syn); grid; title('变声后波形'); xlabel('样点数');
[Y2,~] = voice_spectrum(s_syn,fs);
axes(handles.axes4); plot(w,Y2); grid; axis([0 2000 0 max(Y2)*1.1]);
title('变声后频谱'); xlabel('Hz');
