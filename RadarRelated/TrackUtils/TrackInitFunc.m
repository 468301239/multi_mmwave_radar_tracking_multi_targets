% �������޷������ĵ㼣���г�ʼ��
% ����1��Ŀ��λ����Ϣ tarPosiInfo  {N x 2 / N x 3}
% ����2��Ŀ���ٶ���Ϣ tarVeloInfo ���ٶ�δ֪ �������ʼ���ٶȣ�{N x 1}
% ����3����ǰ֡����Ϣ FrameIndex 
% ����4����ǰ����ʱ����Ϣ dt
% ����5����ǰID��
% ����6�����к��������� �պ���Ҳ���� ��Ŀ��ĺ�����
% ���1�����к��� + �½�����
% ���2���ѷ���ID
function [Tracks, ID] = TrackInitFunc(tarPosInfo, tarVeloInfo, ...
                                            FrameIndex, dt, ID, Tracks)
    for tt = 1:length(tarPosInfo)
        VeloInfo = [];
        Velo = tarVeloInfo{tt}; % �ٶ���Ϣ
        if length(Velo) == 1
            if length(tarPosInfo{tt}) == 2
                weight = rand([1, 2]);
                VeloInfo = Velo * weight;
            elseif length(tarPosInfo{tt}) == 3
                weight = rand([1, 3]);
                VeloInfo = Velo * weight;
            end
        elseif length(Velo) == 2 || length(Velo) == 3
            VeloInfo = Velo;
        else
            error('TrackInitFunc: Not Support This Dimension of Velocity')
        end
        Tracks{length(Tracks) + 1} = trackInit(tarPosInfo{tt}, ...
                                       VeloInfo, dt, FrameIndex, ID);
        ID = ID + 1;
    end
end