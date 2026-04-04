function varargout = voice_gui(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @voice_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @voice_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function voice_gui_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

function varargout = voice_gui_OutputFcn(hObject, eventdata, handles)
% 深色背景
set(handles.figure1, 'Color', [0.2 0.2 0.2]);
% 按钮背景灰色，字体白色
btns = [handles.pushbutton1, handles.pushbutton4, handles.pushbutton20, ...
        handles.pushbutton21, handles.pushbutton22, handles.pushbutton23, handles.pushbutton9];
set(btns, 'BackgroundColor', [0.4 0.4 0.4], 'ForegroundColor', 'white');
% 坐标轴背景黑色
axesList = [handles.axes1, handles.axes2, handles.axes3, handles.axes4];
set(axesList, 'Color', 'k', 'XColor', 'w', 'YColor', 'w', 'GridColor', [0.5 0.5 0.5]);
% 弹出菜单背景黑色文字白色
set(handles.popupmenu1, 'BackgroundColor', [0.3 0.3 0.3], 'ForegroundColor', 'white');



varargout{1} = handles.output;

function pushbutton1_Callback(hObject, eventdata, handles)  %%画图
popup_sel_index = get(handles.popupmenu1, 'Value');
switch popup_sel_index
    case 1
        y=audioread('boy.wav');
    case 2
        y=audioread('girl.wav');
    case 3
        y=audioread('old.wav');
end
Fs=8192;
[Y,w,t]=voice_spectrum(y,Fs);
axes(handles.axes1);
cla;
plot(t,y);grid;title('语音信号y');
axes(handles.axes2);
cla;
plot(w,Y);grid;axis([0 2000 0 500]);title('语音信号y频谱图');
handles.Fs = Fs;
guidata(hObject,handles);


function FileMenu_Callback(hObject, eventdata, handles)
function OpenMenuItem_Callback(hObject, eventdata, handles)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end


function PrintMenuItem_Callback(hObject, eventdata, handles)
printdlg(handles.figure1)

function CloseMenuItem_Callback(hObject, eventdata, handles)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)

function popupmenu1_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

set(hObject, 'String', {'boy','girl'});

function popupmenu1_Callback(hObject, eventdata, handles)
function pushbutton4_Callback(hObject, eventdata, handles)  %%播放语音


Fs = 8192; %handles.Fs;
popup_sel_index = get(handles.popupmenu1, 'Value');
switch popup_sel_index
    case 1
        y=audioread('boy.wav');
    case 2
        y=audioread('girl.wav');
    case 3
        y=audioread('old.wav');
end
sound(y, Fs);
handles.y = y;
guidata(hObject,handles);


function popupmenu3_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
set(hObject, 'String', {'Time Sequence', 'Spectrum'});
function popupmenu3_Callback(hObject, eventdata, handles)


function pushbutton9_Callback(hObject, eventdata, handles)
close;

function popupmenu1_KeyPressFcn(hObject, eventdata, handles)

function pushbutton20_Callback(hObject, eventdata, handles)  %%女变男
y=handles.y;
fs=handles.Fs;%读取音频信息（双声道，16位，频率44100Hz）
N=length(y);
f=0:fs/N:fs*(N-1)/N;
y1=fft(handles.y,N);

Y=fft(y,N);                %进行傅立叶变换
plot(handles.axes2,f(1:N/2),Y(1:N/2));
title(handles.axes2,'声音信号的频谱');
xlabel(handles.axes2,'频率');
ylabel(handles.axes2,'振幅');
f1=0:(fs*0.7)/N:(fs*0.7)*(N-1)/N;
syms t;
t=[0,9];
R=y*exp(2*pi*300*t);
P=fft(R,N);
Z=ifft(P);
z=real(Z);
handles.y=y;
plot(handles.axes3,f1(1:N/2),Z(1:N/2));
title(handles.axes3,'变声后的时域图');
xlabel(handles.axes3,'时间序列');
ylabel(handles.axes3,'频率')
set(handles.axes3,'Xgrid','on');
set(handles.axes3,'Ygrid','on');


plot(handles.axes4,f1(1:N/2),y1(1:N/2));
set(handles.axes4,'Xgrid','on');
set(handles.axes4,'Ygrid','on');
title(handles.axes4,'频谱图');
xlabel( handles.axes4,'频率');
ylabel( handles.axes4,'幅度');
%pause(3);
guidata(hObject,handles);

sound(handles.y,fs*0.7);


function pushbutton21_Callback(hObject, eventdata, handles)  %%录音并实时变声（男变女）
fs=8192;
recorder=audiorecorder(fs,16,1);%设置采样频率、采样位数、通道数
recordblocking(recorder, 4.0);%设置声音记录时间为 4s
samples = getaudiodata(recorder);%存储声音数据
stop(recorder);
handles.y = samples;  %保存语音数据
handles.Fs = fs;
audiowrite('boy.wav', samples, fs);

axes(handles.axes1);
ee=samples(1500:2000);  %选取原始文件x的第1500至2000点的语音
plot(samples);title('语音信号');
xlabel('样点数');ylabel('幅度');grid; 

[Y,w,t]=voice_spectrum(samples, fs);
axes(handles.axes2);
cla;
plot(w,Y);grid;axis([0 2000 0 500]);title('语音信号y频谱图');
FL = 80;                % 帧长
WL = 240;               % 窗长
P = 10;                 % 预测系数个数
data=samples;
N=length(data);
y1=fft(data,N);
f1=0:fs/N:fs*(N-1)/N;

data= data/max(data);	% 归一化
L = length(data);       % 读入语音长度
FN = floor(L/FL)-2;     % 计算帧数

% 预测和重建滤波器
exc = zeros(L,1);       % 激励信号（预测误差）
zi_pre = zeros(P,1);    % 预测滤波器的状态
s_rec = zeros(L,1);     % 重建语音
zi_rec = zeros(P,1);

% 合成滤波器
exc_syn = zeros(L,1);   % 合成的激励信号（脉冲串）
s_syn = zeros(L,1);     % 合成语音
last_syn = 0;           % 存储上一个（或多个）段的最后一个脉冲的下标
zi_syn = zeros(P,1);    % 合成滤波器的状态

% 变调不变速滤波器
exc_syn_t = zeros(L,1);   % 合成的激励信号（脉冲串）
s_syn_t = zeros(L,1);     % 合成语音
last_syn_t = 0;           % 存储上一个（或多个）段的最后一个脉冲的下标
zi_syn_t = zeros(P,1);    % 合成滤波器的状态

% 变速不变调滤波器（假设速度减慢一倍）
hw = hamming(WL);         % 汉明窗

% 依次处理每帧语音
for n = 3:FN
    % 计算预测系数（不需要掌握）
    s_w = data(n*FL-WL+1:n*FL).*hw;    % 汉明窗加权后的语音
    [A, E] = lpc(s_w, P);              % 用线性预测法计算P个预测系数
                                       % A是预测系数，E会被用来计算合成激励的能量
    s_f = data((n-1)*FL+1:n*FL);       % 本帧语音，下面就要对它做处理

    % (4) 用filter函数s_f计算激励，注意保持滤波器状态
    [exc1,zi_pre] = filter(A,1,s_f,zi_pre);

    exc((n-1)*FL+1:n*FL) = exc1; %计算得到的激励

    % (5) 用filter函数和exc重建语音，注意保持滤波器状态
    [s_rec1,zi_rec] = filter(1,A,exc1,zi_rec);

    s_rec((n-1)*FL+1:n*FL) = s_rec1; %计算得到的重建语音

    % 注意下面只有在得到exc后才会计算正确
    s_Pitch = exc(n*FL-222:n*FL);
    PT = findpitch(s_Pitch);    % 计算基音周期PT（不要求掌握）
    G = sqrt(E*PT);           % 计算合成激励的能量G（不要求掌握）

    %方法3：本段激励只能修改本段长度
    tempn_syn = [1:n*FL-last_syn]';
    exc_syn1 = zeros(length(tempn_syn),1);
    exc_syn1(mod(tempn_syn,PT)==0) = G; %某一段算出的脉冲
    exc_syn1 = exc_syn1((n-1)*FL-last_syn+1:n*FL-last_syn);
    [s_syn1,zi_syn] = filter(1,A,exc_syn1,zi_syn);
    exc_syn((n-1)*FL+1:n*FL) =  exc_syn1;   %计算得到的合成激励
    s_syn((n-1)*FL+1:n*FL) = s_syn1;   %计算得到的合成语音
    last_syn = last_syn+PT*floor((n*FL-last_syn)/PT);

    % (13) 将基音周期减小一半，将共振峰频率增加150Hz，重新合成语音，听听是啥感受～
    PT1 =floor(PT/2);   %减小基音周期

    poles = roots(A);
    deltaOMG =150*2*pi/fs;
    for p=1:10   %增加共振峰频率，实轴上方的极点逆时针转，下方顺时针转
        if imag(poles(p))>0 
            poles(p) = poles(p)*exp(j*deltaOMG);
        elseif imag(poles(p))<0 
            poles(p) = poles(p)*exp(-j*deltaOMG);
        end
    end
    A1=poly(poles);

    tempn_syn_t = [1:n*FL-last_syn_t]';
    exc_syn1_t = zeros(length(tempn_syn_t),1);
    exc_syn1_t(mod(tempn_syn_t,PT1)==0) = G; %某一段算出的脉冲
    exc_syn1_t = exc_syn1_t((n-1)*FL-last_syn_t+1:n*FL-last_syn_t);
    [s_syn1_t,zi_syn_t] = filter(1,A1,exc_syn1_t,zi_syn_t);
    exc_syn_t((n-1)*FL+1:n*FL) =  exc_syn1_t;   %计算得到的合成激励
    s_syn_t((n-1)*FL+1:n*FL) = s_syn1_t;   %计算得到的合成语音
    last_syn_t = last_syn_t+PT1*floor((n*FL-last_syn_t)/PT1);
end

sound(s_syn_t);
pause(2);

plot(handles.axes3,s_syn_t),
set(handles.axes3,'Xgrid','on');
set(handles.axes3,'Ygrid','on');
xlabel(handles.axes3,'数据序列');
ylabel(handles.axes3,'频率');
title(handles.axes3,'变音后的时域图'),xlim([0,length(s_syn_t)]);	

plot(handles.axes4,f1(1:N/2),y1(1:N/2));
set(handles.axes4,'Xgrid','on');
set(handles.axes4,'Ygrid','on');
title(handles.axes4,'变音后的频谱图');
xlabel( handles.axes4,'频率');
ylabel( handles.axes4,'幅度');

guidata(hObject, handles);


function pushbutton22_Callback(hObject, eventdata, handles)   %% 男声变女声

%读取音频信息（双声道，16位，频率44100Hz）
% 定义常数
FL = 80;                % 帧长
WL = 240;               % 窗长
P = 10;                 % 预测系数个数
data=handles.y;
fs=handles.Fs;     % 载入语音数据
N=length(handles.y);
y1=fft(handles.y,N);
f1=0:fs/N:fs*(N-1)/N;

data= data/max(data);	%归一化
L = length(data);          % 读入语音长度
FN = floor(L/FL)-2;     % 计算帧数

% 预测和重建滤波器
exc = zeros(L,1);       % 激励信号（预测误差）
zi_pre = zeros(P,1);    % 预测滤波器的状态
s_rec = zeros(L,1);     % 重建语音
zi_rec = zeros(P,1);

% 合成滤波器
exc_syn = zeros(L,1);   % 合成的激励信号（脉冲串）
s_syn = zeros(L,1);     % 合成语音
last_syn = 0;   %存储上一个（或多个）段的最后一个脉冲的下标
zi_syn = zeros(P,1);   % 合成滤波器的状态

% 变调不变速滤波器
exc_syn_t = zeros(L,1);   % 合成的激励信号（脉冲串）
s_syn_t = zeros(L,1);     % 合成语音
last_syn_t = 0;   %存储上一个（或多个）段的最后一个脉冲的下标
zi_syn_t = zeros(P,1);   % 合成滤波器的状态


hw = hamming(WL);       % 汉明窗

% 依次处理每帧语音
for n = 3:FN
    s_w = data(n*FL-WL+1:n*FL).*hw;    %汉明窗加权后的语音
    [A, E] = lpc(s_w, P);            %用线性预测法计算P个预测系数
                                    % A是预测系数，E会被用来计算合成激励的能量
    s_f = data((n-1)*FL+1:n*FL);       % 本帧语音，下面就要对它做处理


    [exc1,zi_pre] = filter(A,1,s_f,zi_pre);

    exc((n-1)*FL+1:n*FL) = exc1; %计算得到的激励


    [s_rec1,zi_rec] = filter(1,A,exc1,zi_rec);

    s_rec((n-1)*FL+1:n*FL) = s_rec1; %计算得到的重建语音


    s_Pitch = exc(n*FL-222:n*FL);
    PT = findpitch(s_Pitch);    % 计算基音周期PT（不要求掌握）
    G = sqrt(E*PT);           % 计算合成激励的能量G（不要求掌握）

    tempn_syn = [1:n*FL-last_syn]';
    exc_syn1 = zeros(length(tempn_syn),1);
    exc_syn1(mod(tempn_syn,PT)==0) = G; %某一段算出的脉冲
    exc_syn1 = exc_syn1((n-1)*FL-last_syn+1:n*FL-last_syn);
    [s_syn1,zi_syn] = filter(1,A,exc_syn1,zi_syn);
    exc_syn((n-1)*FL+1:n*FL) =  exc_syn1;   %计算得到的合成激励
    s_syn((n-1)*FL+1:n*FL) = s_syn1;   %计算得到的合成语音
    last_syn = last_syn+PT*floor((n*FL-last_syn)/PT);

    PT1 =floor(PT/2);   %减小基音周期
    poles = roots(A);
    deltaOMG =150*2*pi/fs;
    for p=1:10   %增加共振峰频率，实轴上方的极点逆时针转，下方顺时针转
        if imag(poles(p))>0 
            poles(p) = poles(p)*exp(j*deltaOMG);
        elseif imag(poles(p))<0 
            poles(p) = poles(p)*exp(-j*deltaOMG);
        end
    end
    A1=poly(poles);


    tempn_syn_t = [1:n*FL-last_syn_t]';
    exc_syn1_t = zeros(length(tempn_syn_t),1);
    exc_syn1_t(mod(tempn_syn_t,PT1)==0) = G; %某一段算出的脉冲
    exc_syn1_t = exc_syn1_t((n-1)*FL-last_syn_t+1:n*FL-last_syn_t);
    [s_syn1_t,zi_syn_t] = filter(1,A1,exc_syn1_t,zi_syn_t);
    exc_syn_t((n-1)*FL+1:n*FL) =  exc_syn1_t;   %计算得到的合成激励
    s_syn_t((n-1)*FL+1:n*FL) = s_syn1_t;   %计算得到的合成语音
    last_syn_t = last_syn_t+PT1*floor((n*FL-last_syn_t)/PT1);
end

sound(s_syn_t);

plot(handles.axes3,s_syn_t),
set(handles.axes3,'Xgrid','on');
set(handles.axes3,'Ygrid','on');
xlabel(handles.axes3,'数据序列');
ylabel(handles.axes3,'频率');
title(handles.axes3,'变音后的时域图'),xlim([0,length(s_syn_t)]);	
handles.y=s_syn_t;

plot(handles.axes4,f1(1:N/2),y1(1:N/2));
set(handles.axes4,'Xgrid','on');
set(handles.axes4,'Ygrid','on');
title(handles.axes4,'变音后的频谱图');
xlabel( handles.axes4,'频率');
ylabel( handles.axes4,'幅度');

pause(2);

guidata(hObject,handles);


function pushbutton23_Callback(hObject, eventdata, handles)  %%男声变大叔声

y=handles.y;
fs=handles.Fs;%读取音频信息（双声道，16位，频率44100Hz）
N=length(y);
f=0:fs/N:fs*(N-1)/N;
y1=fft(handles.y,N);

Y=fft(y,N);                %进行傅立叶变换
plot(handles.axes2,f(1:N/2),Y(1:N/2));
title(handles.axes2,'声音信号的频谱');
xlabel(handles.axes2,'频率');
ylabel(handles.axes2,'振幅');
f1=0:(fs*0.7)/N:(fs*0.7)*(N-1)/N;
syms t;
t=[0,9];
R=y*exp(2*pi*300*t);
P=fft(R,N);
Z=ifft(P);
z=real(Z);
handles.y=y;
plot(handles.axes3,f1(1:N/2),Z(1:N/2));
title(handles.axes3,'变声后的时域图');
xlabel(handles.axes3,'时间序列');
ylabel(handles.axes3,'频率')
set(handles.axes3,'Xgrid','on');
set(handles.axes3,'Ygrid','on');


plot(handles.axes4,f1(1:N/2),y1(1:N/2));
set(handles.axes4,'Xgrid','on');
set(handles.axes4,'Ygrid','on');
title(handles.axes4,'频谱图');
xlabel( handles.axes4,'频率');
ylabel( handles.axes4,'幅度');
%pause(3);
guidata(hObject,handles);

sound(handles.y, fs*0.8);


