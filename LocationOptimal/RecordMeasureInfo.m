% ��¼����ֵ
% ����1��measurements ����ֵ M x N x [tt measX measY (measZ) measV radarX radarY (radarZ) radarYaw (radarPitch)]
% ����2��time ʱ��ֵ
% ����3��dTargets ÿ���״���Ƶ�ֵ
% ����4��dVelocity ÿ���״�����Ķ�����ֵ
% ����5��dRadar ÿ���״�Ĳ���ֵ
% ����6��dAssociate ���������Χ
% ����7��maxNum ���ֵ
% ����8��expireTime ����ʱ�� (������һ���ֹ۲�ֵʱ����ڸ�ֵ ����ɾ��)
% ����9��Nz ά��
% ���1��meas���������
function meas = RecordMeasureInfo(measurements, time, dTargets, dVelocity, ...
                            dRadar, dAssociate, maxNum, expireTime, Nz)
    if nargin == 5
        dAssociate = 2.5;
        maxNum = 50;
        expireTime = 0.5;
        Nz = 2;
    end
    meas = [];
    
    % ��������ֵ
    for rr = size(dTargets, 2):-1:1
        if isempty(dTargets{rr}), continue; end
        if Nz == 2
            radarPos = [dRadar{rr}.x dRadar{rr}.y];
            radarYaw = -dRadar{rr}.yaw;
            rotMatrix  = rotz(radarYaw / pi * 180); 
            rotMatrix  = rotMatrix(1:2, 1:2);
            for tt = length(dTargets{rr}):-1:1
                dTargets{rr}{tt} = rotMatrix' * dTargets{rr}{tt} + radarPos';
            end
        else
            
        end
    end
    
    if ~isempty(measurements)
        for ii = length(measurements):-1:1
            while length(measurements{ii}) > maxNum
                % ɾ����һ��Ԫ��
                measurements{ii}(1) = [];
            end

            if abs(measurements{ii}{end}{1}(1) - time) > expireTime % ʱ��
                measurements(ii) = []; % ɾ�������۲�
            end
        end
        for ii = 1:length(measurements)
            measures     = measurements{ii}{end};
            size_measure = length(measurements{ii});
            for mm = 1:length(measures)
                % 2D
                if Nz == 2
                    info = measures{mm}(2:3);
                else


                end

                dataIndex = 1;
                for rr = size(dTargets, 2):-1:1
                    if Nz == 2
                        radarInfo = [dRadar{rr}.x dRadar{rr}.y dRadar{rr}.yaw];
                    else

                    end
                    if isempty(dTargets{rr}), continue; end
                    for tt = length(dTargets{rr}):-1:1
                        testInfo = [dTargets{rr}{tt}]';
                        deltaInfo = norm(info - testInfo);
                        if deltaInfo < dAssociate
                            measurements{ii}{size_measure + 1}{dataIndex} = [time testInfo dVelocity{rr}{tt} radarInfo];
                            dTargets{rr}(tt)  = [];
                            dVelocity{rr}(tt) = [];
                            dataIndex = dataIndex + 1;
                        end
                    end
                end

            end
        end
    end
    
    % ʣ���޷������Ĺ۲⽨��Ϊ�¹۲�
    for rr = size(dTargets, 2):-1:1
        if Nz == 2
            radarInfo = [dRadar{rr}.x dRadar{rr}.y dRadar{rr}.yaw];
        else
            
        end
        if isempty(dTargets{rr}), continue; end
        
        for tt = length(dTargets{rr}):-1:1
            testInfo = [dTargets{rr}{tt}]';
            measurements{end + 1}{1}{1} = [time testInfo dVelocity{rr}{tt} radarInfo];
        end
    end

    meas = measurements;
end