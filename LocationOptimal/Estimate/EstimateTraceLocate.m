% EstimateTraceLocate ���Ƶ�ǰ�����Ĳ���
% ����1�����ݶಿ�״�ɹ����Ĺ۲��������Ż� dTargets
% ����2�����ݶಿ�״�۲���ٶ�ֵ
% ����3���ಿ�״��λ�� dRadar
% ����4������ֵ dAssociateRange
% ����4��ά�� Nz
% ���1���Ż���Ĺ۲�ֵ 1 x N {xx yy (zz)}
function dMeasures = EstimateTraceLocate(singleMeasures, Nz)
    if nargin == 1
        Nz = 2;
    end
    dMeasures = {};
    posiX = []; posiY = []; radarInfo = []; % ��ر��� 
    for tt = 1:length(singleMeasures)
        observedNum = length(singleMeasures{tt});
        for ttt = 1:length(singleMeasures{tt})
            info = [];
            for tttt = 1:length(singleMeasures{tt}{ttt})
                info(tttt, :) = singleMeasures{tt}{ttt}{tttt};
            end
            if Nz == 2
                posiX{ttt}{tt}     = info(:, 2); % radars x observeTimes
                posiY{ttt}{tt}     = info(:, 3);
            end
        end
    end
    dMeasures = PositionEstimate(posiX, posiY);
end