% ���÷����״�����Ŀ��
% ����1�������״� 
% ����2������Ŀ��
% ����3����ǰʱ��
% ����4��������Ŀ��
% ����5����Ŀ��ƽ����Ŀ
% ����6����Ŀ��ƽ��ƫ��ֵ
% ����7����Ŀ��ƽ���ٶ�ֵ
% ���1�����ɵļ�Ŀ��
% ���2����Ŀ���ٶ�
function [GeneratedTargets, GeneratedTargetsVelo] = GenerateTarget(Radars, Targets, time, ...
    fakeTargetEnable, fakeTargetAveageNum, fakeTargetSigma, fakeTargetVeloSigma)
if nargin == 3
    fakeTargetEnable = 0;
    fakeTargetAveageNum = 3;
    fakeTargetSigma = 2.5;
    fakeTargetVeloSigma = 1.0;
end

GeneratedTargets     = {};
GeneratedTargetsVelo = {};
    
    for rr = 1:length(Radars)
        radar = Radars{rr};
        radarInitLoc     = [radar.x radar.y];
        radarVelo        = [radar.vx radar.vy];
        radarLoc         = radarInitLoc + radarVelo * time;
        radarAngle       = -radar.yaw;
        rotMatrix        = rotz(radarAngle / pi * 180); 
        detectTarget     = {};     % ��λĿ��
        detectTargetVelo = {}; % ��λ�ٶ�
        for tt = 1:length(Targets)
            target        = Targets{tt};
            targetInitLoc = [target.x target.y];
            targetVelo    = [target.vx target.vy];
            targetLoc     = targetInitLoc + targetVelo * time + randn(size(targetVelo)) * target.Q;
            deltaLoc      = targetLoc - radarLoc;
            deltaLoc      = rotMatrix(1:2, 1:2) * deltaLoc';
            deltaAngle    = atan2(deltaLoc(2), deltaLoc(1));
            deltaVelo     = norm(targetVelo) * sin(atan2(target.vy, target.vx) - radarAngle);
            if abs(deltaAngle) > radar.sYaw / 2
                continue; % �޷�̽��
            end
            if norm(deltaLoc) > radar.sRange
                continue; % �޷�̽��
            end
            detectTarget{length(detectTarget) + 1} = ...
                deltaLoc + randn(size(deltaLoc)) * radar.MeasureError;
            detectTargetVelo{length(detectTargetVelo) + 1} = ...
                deltaVelo + randn([1, 1]) * radar.MeasureErrorVelo;
            if fakeTargetEnable
                for ii = 1:randi(fakeTargetAveageNum)
                    detectTarget{length(detectTarget) + 1} = ...
                        deltaLoc + randn(size(deltaLoc)) * fakeTargetSigma;
                    detectTargetVelo{length(detectTargetVelo) + 1} = ...
                        deltaVelo + randn([1, 1]) * radar.MeasureErrorVelo + ...
                        randn([1, 1]) * fakeTargetVeloSigma;
                end
            end
        end
        GeneratedTargets{rr} = detectTarget;
        GeneratedTargetsVelo{rr} = detectTargetVelo;
    end


end

% ���Ƕ�����ʱ����ת
