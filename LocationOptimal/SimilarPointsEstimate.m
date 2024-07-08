% ����ͬ������б��ں�
% ����1�����к���
% ����2������ֵ
% ����3��DT��λʱ��
% ����4��������ֵ
% ���1���б����ֵ
% ���2�����Ӧ����
function [new_measurements, probs] = SimilarPointsEstimate(Tracks, measurements, DT, SimilarRange)
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
                % tt which tracks which measures
                new_measurements(:, size(new_measurements, 2) + 1) = info;
            end
        end
    end
    
    probs = ProbMeasure(Tracks, new_measurements, DT);
    
end

% ���첨��
% ����1��Tracks Track������Ϣ
% ����2��new_measurements ����ֵ
% ����3��dt ��λʱ��
% ���1��Prob ÿ���۲⺽���ĸ����ܶ�ֵ
function prob = ProbMeasure(Tracks, new_measurements, dt)
    prob = {};
    for tt = 1:length(Tracks)
        if Tracks{tt}.Nz == 2
            Posi = [Tracks{tt}.X(1) 
                Tracks{tt}.X(3)];
            Velo = abs([Tracks{tt}.X(2) 
                Tracks{tt}.X(4)]);
            X_est = Posi + Velo * dt;
            mu = [X_est(1) X_est(2)];
            var = [Velo(1) * dt 1; 1 Velo(2) * dt];
            while var(1, 1) < 10 || var(2, 2) < 10
                var(1, 1) = var(1, 1) * 10;
                var(2, 2) = var(2, 2) * 10;
            end
            
            estimate_index = find(new_measurements(1, :) == tt);
            estimate_info  = new_measurements(3:end, estimate_index);
            estimate_loc   = [estimate_info(1,:) estimate_info(3,:)];
            
            prob_ = mvnpdf(estimate_loc, mu, var);
            prob_ = prob_ / sum(prob_);
            prob{tt}  = prob_;
        elseif info.Dimension == 3

        else
            error('Prob Measure function: Not support this Dimension')
        end
    end
end
