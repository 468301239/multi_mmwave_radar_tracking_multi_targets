% ��ʼ��EKF״̬
% ����1��X X����
% ����2��Y Y����
% ����3��Z Z����
% ����4��Xn ԭ����״̬ 
% ����5��Pn ԭ����Э����
% ��ѡ����1��EKF2 ʹ��2ά ���� 3ά��EKF
% ���1��Xn ״̬
% ���2��Pn Э����
function [Xn, Pn] = InitEKF3(Posi, Velo, Xn, Pn, EKF2)
    if nargin == 5
        EKF2 = 0;
    end
    initNum = length(Pn);
    for ii = 1:length(Posi)
        if ~EKF2
            Xn = [Xn; Posi{ii}(1) Velo{ii}(1) ...
                        Posi{ii}(2) Velo{ii}(2) ...
                        Posi{ii}(3) Velo{ii}(3)];
            Pn{initNum + ii} = eye(6);
        else
            Xn = [Xn; Posi{ii}(1) Velo{ii}(1) ...
                        Posi{ii}(2) Velo{ii}(2)];
            Pn{initNum + ii} = eye(4);
        end
    end
end