%% �״���Ŀ
Net_RadarNum = 2;
% �״�ṹ��
GHz  = 1e9;   % GHz
MHz  = 1e6;   % MHz
us   = 1e-6;  % ΢��
c    = 3.0e8; % ����
Ksps = 1e6;
N    = 256;         %������FFT����
M    = 128;         %��������FFT����
Q    = 256;         %�Ƕ�FFT

radarType = ["1843", "6843"];
fileName  = ["RadarFiles/data1/2024-06-20-22-25-20.bin",
    "RadarFiles/data2/2024-06-20-22-17-29.bin"];
carryFrequency = [77e9 60e9];
location = [0 0 0;
            3 0 0];
angle    = [0 0];


for radar = 1:Net_RadarNum
%% �״������ʹ��mmWave StudioĬ�ϲ�����
    Radar(radar).Type = radarType(radar);
    Radar(radar).Num  = Net_RadarNum;
    Radar(radar).fnumber = 256; % MUST BE UNITED
    Radar(radar).fname = fileName(radar); % ������ļ�����
    Radar(radar).RadarParam.B = 4000*1e6;       %��Ƶ����
    Radar(radar).RadarParam.K = 80*1e12;  %��Ƶб��
    Radar(radar).RadarParam.T = Radar(radar).RadarParam.B/Radar(radar).RadarParam.K;         %����ʱ��
    Radar(radar).RadarParam.Tc = 65e-6;     %chirp������
    Radar(radar).RadarParam.fs = 12500 * 1e3;       %������
    Radar(radar).RadarParam.f0 = carryFrequency(radar);       %��ʼƵ��
    Radar(radar).RadarParam.lambda = c/Radar(radar).RadarParam.f0;   %�״��źŲ���
    Radar(radar).RadarParam.d = Radar(radar).RadarParam.lambda/2;    %�������м��
    Radar(radar).RadarParam.n_samples = 256; %��������/����
    Radar(radar).RadarParam.n_chirps=128;   %ÿ֡������
    Radar(radar).RadarParam.PRI = 1e-1;
    Radar(radar).FFTParam.n_RX=4;        %RX����ͨ����
    Radar(radar).FFTParam.n_TX=2;        %TX����ͨ����
    Radar(radar).ProcessParam.DisableAngle = 69 / 180 * pi; % Ori:69
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
    Radar(radar).Geometry.Location = location(radar, :); % X Y Z
    Radar(radar).Geometry.Angle    = angle(radar);     % Azimuth only
end