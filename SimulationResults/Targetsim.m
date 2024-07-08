% ����ģ��Ŀ��
% ����1��Ŀ��λ��
% ����2��Ŀ���ٶ�
% ����3��Ŀ���˶�����
% (if 2 dimension then Q = 4)
% (if 3 dimension then Q = 6)
% ����4���״�����ά��
function simtarget = Targetsim(Locations, Velos, Q, Nz, MotionType)
    if length(Locations) == 3
        simtarget.x = Locations(1);
        simtarget.y = Locations(2);
        simtarget.z = Locations(3);
    elseif length(Locations) == 2
        simtarget.x = Locations(1);
        simtarget.y = Locations(2);
    else
        error('Radar Sim Initialize: Not Support This Location')
    end
        
    if length(Velos) == 3
        simtarget.x = Velos(1);
        simtarget.y = Velos(2);
        simtarget.z = Velos(3);
    elseif length(Velos) == 2
        if MotionType == 0
            simtarget.vx = @(x) Velos(1);
            simtarget.vy = @(x) Velos(2);
        else
            Velo = norm(Velos);
            simtarget.vx = @(x) Velos(1);
            simtarget.vy = @(x) Velos(2) + min([6, 0.25 * x]);
        end
    else
        error('Radar Sim Initialize: Not Support This Velocity')
    end
    
    simtarget.Q = Q;
    simtarget.Dimension = Nz;
    simtarget.CircleMotion = MotionType;
end