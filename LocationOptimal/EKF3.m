% ��չ�������˲�3 
% ����1���״�۲⵽�ĸ����� E
% ����2���״�۲⵽�ķ�λ�� A
% ����3���״�۲⵽�ľ���   R
% ����4����ȥ�����Ĺ۲�ֵ Z (1 x 6) X Vx Y Vy Z Vz
% ����5����ȥ������Э���� P 
%  (��ȥ�ĺ����۲��С���״��¹۲⵽�Ĵ�С����һ��)
%  (���û�й۲⵽�µ������ǾͲ�Ҫ�ӽ�ȥ������ΪNULL��)
% ��ѡ����1��EKF2 ��ά������ά
% ��ѡ����2��T    ��֡��ʱ��
% ���1���µĺ����۲�ֵ Zn
% ���2���µĺ���Э���� Pn
function [Zn, Pn] = EKF3(Posi, Velo, Zn, Pn, EKF2, t)
% ����Ĭ��ֵ
if nargin == 4, EKF2 = 0; t = 0.1; end
% ��ʼ������
Q_ = 10;     % �˶������е�����
R_ = 1;      % �۲ⷽ���е�����
% �˶�����
% Xt = Xt-1 + Vxt-1 * t 
% Yt = Yt-1 + Vyt-1 * t
% Zt = Zt-1 + Vzt-1 * t
% Vx = Vxt-1 + n(t)
% Vy = Vyt-1 + n(t)
% Vz = Vzt-1 + n(t)
% ��ν��˶�����ת��Ϊ�۲ⷽ��
% azi   = arctan(y/x)
% ele   = arctan(z/��(x^2 + y^2))
% range = ��(x^2 + y^2 + z^2) 
% �˶�������
% [1 t 0 0 0 0;  X
%  0 1 0 0 0 0;  Vx
%  0 0 1 t 0 0;  Y
%  0 0 0 1 0 0;  Vy
%  0 0 0 0 1 t;  Z
%  0 0 0 0 0 1]; Vz
% �۲ⷽ����
% [ -y / (x^2 + y^2) 0 x / (x^2 + y^2) 0 0 0;
%    x * z / (range^2 * range_xy) 0 y * z / (range^2 * range_xy) 0 -range_xy / range^2 0;
%    x / range 0 y / range 0 z / range 0]
% ����
% range_xy = ��(x^2 + y^2)
% range = ��(x^2 + y^2 + z^2)
% 2024 ����
% �۲�ֵ [xx vx yy vy zz vz] % λ�����ٶ�

for ii = 1:size(Zn, 1)
    if EKF2
        if ~isempty(Posi{ii})
            % �ò���Elevation
            r_x_ = Posi(1);
            r_y_ = Posi(2);
            v_x_ = Velo(1); % ����ٶȹ������׳���
            v_y_ = Velo(2); % ����ٶ����׳���
            r_x  = Zn(ii, 1) + Zn(ii, 2) * t;
            r_y  = Zn(ii, 3) + Zn(ii, 4) * t;
            v_x  = Zn(ii, 2);
            v_y  = Zn(ii, 4);
            Zf   = [r_x, v_x, ...
                     r_y, v_y];      % Ԥ���״̬
            Z_   = [r_x_ v_x_ ...
                     r_y_ v_y_];     % ��ʵ�Ĺ۲�ֵ
        else
            continue;
        end
        
        F = [1 t 0 0; 
            0 1 0 0;
            0 0 1 t;
            0 0 0 1]; % 6 x 6
        H = [1 t 0 0;
            0 t 0 0;
            0 0 1 t;
            0 0 0 t;
            ]; % 6 x 6
    else
        % ���������
        % ������ʵ״̬
        if ~isempty(Posi{ii})
            r_x_  = Posi(1);
            r_y_  = Posi(2);
            r_z_  = Posi(3);
            v_x_  = Velo(1);
            v_y_  = Velo(2);
            v_z_  = Velo(3);
            r_x   = Zn(ii, 1) + Zn(ii, 2) * t;
            r_y   = Zn(ii, 3) + Zn(ii, 4) * t;
            r_z   = Zn(ii, 5) + Zn(ii, 6) * t; % Ԥ��ֵ
            v_x   = Zn(ii, 2);
            v_y   = Zn(ii, 4);
            v_z   = Zn(ii, 6);
            Zf    = [r_x, v_x, ...
                     r_y, v_y, ...
                     r_z, v_z];      % Ԥ���״̬
            Z_    = [r_x_ v_x_ ...
                     r_y_ v_y_ ...
                     r_z_ v_z_];     % ��ʵ�Ĺ۲�ֵ
        else
            % �����и���
            continue;
        end

        F = [1 t 0 0 0 0; 
            0 1 0 0 0 0;
            0 0 1 t 0 0;
            0 0 0 1 0 0;
            0 0 0 0 1 t;
            0 0 0 0 0 1]; % 6 x 6
        H = [1 t 0 0 0 0;
            0 t 0 0 0 0;
            0 0 1 t 0 0;
            0 0 0 t 0 0;
            0 0 0 0 1 t;
            0 0 0 0 0 1
            ]; % 6 x 6
    end
    
    P_ = F * Pn{ii} * F' + Q_ * eye(6); % 6 x 6
    K = P_ * H' / (H * P_ * H' + R_ * eye(3));
    X = X_ + (K * (Z_ - Zf)')';
    Pn{ii} = P_ - K * H * P_;          % ����Э����
    Zn(ii, :) = X;                     % ����״̬
end
end