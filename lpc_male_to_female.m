function s_out = lpc_male_to_female(data, fs)

% LPC processing extracted from the original GUIDE callback, September 2026.
% The pitch/formant algorithm is preserved; this entry point adds input guards.
validateattributes(data, {'numeric'}, {'vector','real','finite','nonempty'}, mfilename, 'data');
validateattributes(fs, {'numeric'}, {'scalar','real','finite','positive'}, mfilename, 'fs');
if fs ~= 8192
    error('voice_changer:SampleRate', 'Use 8192 Hz input; voice_demo resamples WAV files automatically.');
end
data = double(data(:));
if numel(data) < 480
    error('voice_changer:TooShort', 'Input must contain at least 480 samples.');
end
if max(abs(data)) == 0
    s_out = zeros(size(data));
    return;
end

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
peak = max(abs(s_out));
if peak > 0
    s_out = s_out / peak;
end
