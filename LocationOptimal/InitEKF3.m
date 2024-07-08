% ��ʼ��EKF״̬
% ����1��X X����
% ����2��Y Y����
% ����3��Z Z����
% ����4��Xn ԭ����״̬ 
% ����5��Pn ԭ����Э����
% ��ѡ����1��EKF2 ʹ��2ά ���� 3ά��EKF
% ���1��Tracks
% ���2��ID
function [Tracks, ID] = InitEKF3(Tracks, Posi, Velo, EKF2, ID)
    TarNum = size(Velo, 1);
    for tt = 1:TarNum
        if ~EKF2
            Tracks{end + 1}.Xn = [Posi{tt}(1) Velo(tt, 1) ...
                            Posi{tt}(2) Velo(tt, 2) ...
                            Posi{tt}(3) Velo(tt, 3)];
            Tracks{end + 1}.Pn = eye(6);
        else
            Tracks{end + 1}.Xn = [Posi{tt}(1) Velo(tt, 1) ...
                            Posi{tt}(2) Velo(tt, 2)];
            Tracks{end + 1}.Pn = eye(4);
        end
        Tracks{end + 1}.ID = ID;
        ID = ID + 1;
    end    
end