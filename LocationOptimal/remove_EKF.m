% ɾ��EKF״̬
% ����1��Xn ���е�״̬
% ����2��Pn ���е�Э����
% ����3��removeIndex ɾ��������
function [Xn, Pn] = remove_EKF(Xn, Pn, removeIndex)
    Xn(removeIndex, :) = [];
    Pn(removeIndex)    = [];
end