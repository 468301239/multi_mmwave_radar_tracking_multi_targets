% �˶�ģ�ͺ���
% �������˻��ڵ�λʱ����Ϊ�����˶�
% ����1�����˻��ڸ�ʱ�̵�״̬ status_k [N x 6] ����6��[x vx y vy z vz]
% ����2����λʱ�� frame_time 
% ���1�����˻�����һʱ�̵�״̬ status_k_1 [N x 6]
function [status_k_1] = MotionModel(status_k, frame_time)
    status_k_1 = [];
    droneNum = size(status_k, 1); % ���˻���Ŀ
    for nn = 1:droneNum
        xx = status_k(nn, 1);
        vx = status_k(nn, 2);
        yy = status_k(nn, 3);
        vy = status_k(nn, 4);
        zz = status_k(nn, 5);
        vz = status_k(nn, 6);
        
        xx = xx + vx * frame_time;
        yy = yy + vy * frame_time;
        zz = zz + vz * frame_time;
        status_k_1(nn, :) = [xx vx yy vy zz vz];
    end
end

