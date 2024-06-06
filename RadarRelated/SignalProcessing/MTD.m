% ��Ŀ����
% ���ײ��״� ͨ�� ���������ʵ�� ��ȡ ����-������ ��ͼ
% ����1���������� RangeProfile (Ant_Num x RangeFFT x Chirps)
% ����2���ٶ���FFT���� FFTNum
% ���1��MTD���������-��������ͼ��
function MTD_result = MTD(RangeProfile, FFTNum)
    if length(size(RangeProfile)) == 3
        Ant_Num = size(RangeProfile, 1);
        for aa = 1:Ant_Num
            MTD_result(aa, :, :) = fftshift(fft(RangeProfile(aa,:,:), FFTNum, 2), 2);
        end
    elseif length(size(RangeProfile)) == 2
        MTD_result = fftshift(fft(RangeProfile(:,:), FFTNum, 2), 2);
    else
        MTD_result = [];
        error('MTD: Higher Dimension Detected, Not support')
    end
end