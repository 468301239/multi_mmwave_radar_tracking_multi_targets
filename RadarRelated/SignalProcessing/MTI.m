% ��Ŀ��ָʾ
% ����1��RadarEcho �״�ز� �ṹ��[ͨ����Ŀ] optical x ��������Ŀ x ������
% ����2��MTI_delay ����MTI�˲�
% ���1��MTI_result ��Ŀ��ָʾ���
function MTI_result = MTI(RadarEcho, MTI_delay)
    if length(size(RadarEcho)) == 2
        MTI_result = RadarEcho(:, 1:end-MTI_delay) - RadarEcho(:, MTI_delay + 1:end);
    elseif length(size(RadarEcho)) == 3
        MTI_result = RadarEcho(:, :, 1:end-MTI_delay) - RadarEcho(:, :, MTI_delay + 1:end);
    else
        MTI_result = [];
        error('MTI: Higher Dimension Detected, Not Support')
    end
end