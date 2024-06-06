% ����ͬ������б��ں�
% ����1�����к���
% ����2������ֵ
% ����3��������ֵ
% ���1���б����ֵ
function [new_measurements] = SimilarPointsEstimate(Tracks, measurements, SimilarRange)
    if nargin == 2
        SimilarRange = 2.5;
    end
        
    new_measurements = [];
    if isempty(Tracks)
        for iii = 1:size(measurements, 2)
            info = [iii; iii; measurements(:, iii)];
            new_measurements(:, size(new_measurements, 2) + 1) = info;
        end
        return; % ����֪���ٺ���
    end

    measurements_flag = zeros(length(Tracks), size(measurements, 2));
    measures_fusion   = {};
    for tt = 1:length(Tracks)
        TrackInfo = Tracks{tt}.X;
        Pcov      = Tracks{tt}.P;
        for iii = 1:size(measurements, 2)
            MeasureInfo = measurements(:, iii);
            deltaInfo = TrackInfo - MeasureInfo;
            distance  = sqrt(deltaInfo' * inv(Pcov) * deltaInfo);
            measurements_flag(tt, iii) = distance;
        end
        
        valid_fusion = [];
        for iii = 1:size(measurements, 2)
            if measurements_flag(tt, iii) < SimilarRange
                valid_fusion = [valid_fusion; iii];
            end
        end
        measures_fusion{tt} = valid_fusion;
    end
    
    for tt = 1:length(measures_fusion)
        if ~isempty(measures_fusion{tt})
            for iii = 1:length(measures_fusion{tt})
                info = [tt; measures_fusion{tt}(iii); measurements(:, iii)];
                new_measurements(:, size(new_measurements, 2) + 1) = info;
            end
        end
    end
end

% ���첨��
% ����1��Tracks Track������Ϣ
% ����2��new_measurements ����ֵ
% ����3��dt ��λʱ��
function ProbMeasure(Tracks, new_measurements, dt)
    for ii = 1:size(new_measurements, 2)
        if Tracks{new_measurements(1, ii)}.Dimension == 2
            Posi = [Tracks{new_measurements(1, ii)}.X(1) 
                Tracks{new_measurements(1, ii)}.X(3)];
            Velo = [Tracks{new_measurements(1, ii)}.X(2) 
                Tracks{new_measurements(1, ii)}.X(4)];
        X_est = 
            
        elseif info.Dimension == 3

        else
            error('Prob Measure function: Not support this Dimension')
        end
    end
end
