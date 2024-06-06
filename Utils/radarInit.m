%% �״���Ŀ
Net_RadarNum = 3;
% �״�ṹ��
GHz  = 1e9;   % GHz
MHz  = 1e6;   % MHz
us   = 1e-6;  % ΢��
c    = 3.0e8; % ����
Ksps = 1e6;
N    = 256;         %������FFT����
M    = 128;         %��������FFT����
Q    = 512;       %�Ƕ�FFT

for radar = 1:Net_RadarNum
%% �״������ʹ��mmWave StudioĬ�ϲ�����
    Radar(radar).Num = Net_RadarNum;
    Radar(radar).fnumber = 256; % MUST BE UNITED
    Radar(radar).fname = ''; % ������ļ�����
    Radar(radar).RadarParam.B = 4000*1e6;       %��Ƶ����
    Radar(radar).RadarParam.K = 58*1e12;  %��Ƶб��
    Radar(radar).RadarParam.T = Radar(radar).RadarParam.B/Radar(radar).RadarParam.K;         %����ʱ��
    Radar(radar).RadarParam.Tc = 65e-6;     %chirp������
    Radar(radar).RadarParam.fs = 10*1e6;       %������
    Radar(radar).RadarParam.f0 = 77e9;       %��ʼƵ��
    Radar(radar).RadarParam.lambda = c/Radar(radar).RadarParam.f0;   %�״��źŲ���
    Radar(radar).RadarParam.d = Radar(radar).RadarParam.lambda/2;    %�������м��
    Radar(radar).RadarParam.n_samples = 256; %��������/����
    Radar(radar).RadarParam.n_chirps=64;   %ÿ֡������
    Radar(radar).RadarParam.PRI = 4e-3;
    Radar(radar).FFTParam.n_RX=4;        %RX����ͨ����
    Radar(radar).FFTParam.n_TX=3;        %TX����ͨ����
    Radar(radar).ProcessParam.range_axis = linspace(0, ...
                                Radar(radar).RadarParam.fs * ...
                                c / 2 / Radar(radar).RadarParam.K, N);
    Radar(radar).ProcessParam.velo_axis = linspace(-Radar(radar).RadarParam.lambda ...
                                / 4 / Radar(radar).RadarParam.Tc, ...
                                Radar(radar).RadarParam.lambda / 4 / Radar(radar).RadarParam.Tc, M);
    Radar(radar).ProcessParam.an_axis_az = linspace(-asin(Radar(radar).RadarParam.lambda/2/Radar(radar).RadarParam.d), ...
                                asin(Radar(radar).RadarParam.lambda/2/Radar(radar).RadarParam.d), Q);
    Radar(radar).ProcessParam.an_axis_el = linspace(-asin(Radar(radar).RadarParam.lambda/2/Radar(radar).RadarParam.d), ...
                                asin(Radar(radar).RadarParam.lambda/2/Radar(radar).RadarParam.d), Q);
    Radar(radar).Geometry.Location = [0 0 0]; % X Y Z
    Radar(radar).Geometry.Angel    = [0];     % Azimuth only
end