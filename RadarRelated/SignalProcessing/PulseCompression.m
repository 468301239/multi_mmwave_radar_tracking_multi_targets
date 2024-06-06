% ����ѹ�� -> �õ�
% ���ײ��״�����ѹ����Ҫ�ڿ�ʱ��ά���Ͻ���FFT
% ����1�����ײ��״�ز� (AntennaNum x ������ x ������Ŀ)
% ����2��FFT�� FFTNum
% ���1��������
function RangeProfile = PulseCompression(RadarEcho, FFTNum)
    if length(size(RadarEcho)) == 3
        num_Ant = size(RadarEcho, 1);
        for aa = 1:num_Ant
            RangeProfile(aa, :, :) = fft(squeeze(RadarEcho(aa, :, :)), FFTNum);
        end
    elseif length(size(RadarEcho)) == 2
        RangeProfile = fft(RadarEcho, FFTNum);
    else
        RangeProfile = [];
        error('Pulse Compression: Not Support other Dimension')
    end
end