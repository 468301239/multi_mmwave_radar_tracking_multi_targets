% ����ģ���״�
% ����1���״�λ��
% ����2���״��ٶ�
% ����3���״��ָ��
% ����4�������Ƕ�
% ����5����������
% ����6��̽������
%��if 3 should be azimuth elevation range and doppler��
% (if 2 should be azimuth range and doppler)
% ����7���ٶ�̽������
% ����8������ά��
function simradar = Radarsim(Locations, Velos, RadarAttitude, ...
                                    SearchAngle, SearchRange, Q, vQ, Nz)
    if length(Locations) == 3
        simradar.x = Locations(1);
        simradar.y = Locations(2);
        simradar.z = Locations(3);
    elseif length(Locations) == 2
        simradar.x = Locations(1);
        simradar.y = Locations(2);
    else
        error('Radar Sim Initialize: Not Support This Location')
    end
        
    if length(Velos) == 3
        simradar.vx = Velos(1);
        simradar.vy = Velos(2);
        simradar.vz = Velos(3);
    elseif length(Velos) == 2
        simradar.vx = Velos(1);
        simradar.vy = Velos(2);
    else
        error('Radar Sim Initialize: Not Support This Velocity')
    end
    
    if length(RadarAttitude) ~= 3
        error('Radar Sim Initialize: Need RPY Angle of Radar')
    else
        simradar.roll  = RadarAttitude(1);
        simradar.pitch = RadarAttitude(2);
        simradar.yaw   = RadarAttitude(3);
    end
    
    if length(Locations) == 2
        if length(SearchAngle) ~= 1
            error('Radar Sim Initialize: Need Search Angle of Radar with Yaw Only')
        else
            simradar.sYaw   = SearchAngle(1);
        end
    elseif length(Locations) == 3
        if length(SearchAngle) ~= 2
            error('Radar Sim Initialize: Need Search Angle of Radar with Yaw and Pitch Only')
        else
            simradar.sYaw   = SearchAngle(1);
            simradar.sPitch = SearchAngle(2);
        end
    end
        
    simradar.sRange = SearchRange;
    simradar.MeasureError = Q;
    simradar.MeasureErrorVelo = vQ;
    simradar.Dimension = Nz;
end