function [Y,w,t]=voice_spectrum(y,Fs)
tend=length(y)/Fs;   % 语音总时长（秒）
t=linspace(0,tend,length(y));   % 时间轴
Y=fft(y);              % 快速傅里叶变换
Ts=t(2)-t(1);          % 采样间隔
ws=1/Ts;               % 采样角频率
wn=ws/2;               % 奈奎斯特频率（Hz）
w=linspace(0,wn,length(t)/2);   % 频率轴（只取正频率）
if mod(length(t),2)==0
    tnum=length(t)/2;
else
    tnum=(length(t)-1)/2;       % 取一半的点（对应正频率）
end
Y=abs(Y(1:1:tnum));             % 幅度谱（单边）
