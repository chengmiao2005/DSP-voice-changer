function PT = findpitch(s)
[B, A] = butter(5, 700/4000);   % 设计 5 阶 Butterworth 低通，截止 700 Hz
s = filter(B,A,s);% 滤波，保留基频成分（通常男声 80-200 Hz，女声 150-400 Hz）
R = zeros(143,1);
R = zeros(143,1);
for k=1:143
    R(k) = s(144:223)'*s(144-k:223-k);  % 自相关计算
end
% 在三个范围内搜索最大自相关对应的延迟（周期）
[R1,T1] = max(R(80:143));
T1 = T1 + 79;
R1 = R1/(norm(s(144-T1:223-T1))+1);
[R2,T2] = max(R(40:79));
T2 = T2 + 39;
R2 = R2/(norm(s(144-T2:223-T2))+1);
[R3,T3] = max(R(20:39));
T3 = T3 + 19;
R3 = R3/(norm(s(144-T3:223-T3))+1);
% 选择最大自相关且满足阈值条件的周期
Top = T1;
Rop = R1;
if R2 >= 0.85*Rop
    Rop = R2;
    Top = T2;
end
if R3 > 0.85*Rop
    Rop = R3;
    Top = T3;
end
PT = Top;
