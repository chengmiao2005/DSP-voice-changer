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

function s_out = lpc_male_to_female(data, fs)
FL=80; WL=240; P=10;
data = data / max(abs(data));
L = length(data);
FN = floor(L/FL)-2;
exc=zeros(L,1); zi_pre=zeros(P,1); s_rec=zeros(L,1); zi_rec=zeros(P,1);
exc_syn=zeros(L,1); s_syn=zeros(L,1); last_syn=0; zi_syn=zeros(P,1);
exc_syn_t=zeros(L,1); s_syn_t=zeros(L,1); last_syn_t=0; zi_syn_t=zeros(P,1);
hw = hamming(WL);
for n = 3:FN
    s_w = data(n*FL-WL+1:n*FL).*hw;
    [A, E] = lpc(s_w, P);
    s_f = data((n-1)*FL+1:n*FL);
    [exc1,zi_pre] = filter(A,1,s_f,zi_pre);
    exc((n-1)*FL+1:n*FL) = exc1;
    [s_rec1,zi_rec] = filter(1,A,exc1,zi_rec);
    s_rec((n-1)*FL+1:n*FL) = s_rec1;
    s_Pitch = exc(n*FL-222:n*FL);
    PT = findpitch(s_Pitch);
    G = sqrt(E*PT);
    tempn_syn = (1:n*FL-last_syn)';
    exc_syn1 = zeros(length(tempn_syn),1);
    exc_syn1(mod(tempn_syn,PT)==0) = G;
    exc_syn1 = exc_syn1((n-1)*FL-last_syn+1:n*FL-last_syn);
    [s_syn1,zi_syn] = filter(1,A,exc_syn1,zi_syn);
    exc_syn((n-1)*FL+1:n*FL) = exc_syn1;
    s_syn((n-1)*FL+1:n*FL) = s_syn1;
    last_syn = last_syn + PT*floor((n*FL-last_syn)/PT);
    PT1 = floor(PT/2);
    poles = roots(A);
    deltaOMG = 150*2*pi/fs;
    for p=1:P
        if imag(poles(p))>0, poles(p)=poles(p)*exp(1j*deltaOMG);
        elseif imag(poles(p))<0, poles(p)=poles(p)*exp(-1j*deltaOMG); end
    end
    A1 = poly(poles);
    tempn_syn_t = (1:n*FL-last_syn_t)';
    exc_syn1_t = zeros(length(tempn_syn_t),1);
    exc_syn1_t(mod(tempn_syn_t,PT1)==0) = G;
    exc_syn1_t = exc_syn1_t((n-1)*FL-last_syn_t+1:n*FL-last_syn_t);
    [s_syn1_t,zi_syn_t] = filter(1,A1,exc_syn1_t,zi_syn_t);
    exc_syn_t((n-1)*FL+1:n*FL) = exc_syn1_t;
    s_syn_t((n-1)*FL+1:n*FL) = s_syn1_t;
    last_syn_t = last_syn_t + PT1*floor((n*FL-last_syn_t)/PT1);
end
s_out = s_syn_t - mean(s_syn_t);
s_out = s_out / max(abs(s_out));
