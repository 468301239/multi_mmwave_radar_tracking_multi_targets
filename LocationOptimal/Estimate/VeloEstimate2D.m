% �ٶȹ����Ӻ���
% ����1����ȡ���ٶ������� Frame x Observes x Tar
% ����2����ȡ��Xλ�������� Frame x Observes x Tar
% ����3����ȡ��Yλ�������� Frame x Observes x Tar
% ����4�����״����� Frame x Observes x 3 (PosiX PosiY radarYaw)
% ����5����λ����ʱ�� dt
% ���1����ȷ���Ƶ��ٶ�����
function Velo = VeloEstimate2D(VeloVec, PosiX, PosiY, ...
    TarNum, radarInfo, dt, deltaStep, multiStepNum)
    frameLength = length(VeloVec);
    
    if frameLength <= deltaStep
        Velo = [];
        return;
    end
    
    Nz = 2;
    tempVelo = randn(length(1:deltaStep:frameLength), TarNum, Nz);
    % ����������300������
    % �����ֵ����ֹ�ݲ� 0.01
    options = optimset('MaxIter',3000, 'TolFun', 1e-2);
    Velo = fminsearch(@SingleStepDiff, tempVelo, options); % ���Ƴ�ʼֵ
    % ��ȷ�����ٶ�
    Velo = fminsearch(@MultiStepDiff, Velo); % 
    % ��ȷ�����ٶ�
    Velo = fminsearch(@SameVeloDiff, Velo); %

    % �����ٶȹ����Ӻ���
    % ����tempVelo randn[frames x Tar x Nz]
    function costSSD = SingleStepDiff(tempVelo)
        costSSD = 0;
        index = 0;
        for tt = 1:deltaStep:frameLength - deltaStep
            index = index + 1;
            for pp = 1:length(PosiX{tt + deltaStep})
                meanPosiX = mean(PosiX{tt + deltaStep}{pp}); 
                meanPosiY = mean(PosiY{tt + deltaStep}{pp}); 
                diffInfo = [meanPosiX meanPosiY] - [PosiX{tt}{pp} PosiY{tt}{pp}];
                costSSD = costSSD + norm(diffInfo - ...
                    squeeze(tempVelo(index, pp, :))' * deltaStep * dt);
            end
        end
    end
    
    % �ಽ�Ӻ���
    % ����tempVelo randn[frames x Tar x Nz]
    function costMSD = MultiStepDiff(tempVelo)
        costMSD = 0;
        index = 0;
        for tt = 1:deltaStep:frameLength
            index = index + 1; multiStepIndex = 0;
            for ttt = tt + deltaStep:deltaStep:frameLength
                if multiStepIndex >= multiStepNum, break; end
                multiStepIndex = multiStepIndex + 1;
                for pp = 1:length(PosiX{ttt})
                    meanPosiX = mean(PosiX{ttt}{pp}); 
                    meanPosiY = mean(PosiY{ttt}{pp}); 
                    diffInfo = [meanPosiX meanPosiY] - [PosiX{tt}{pp} PosiY{tt}{pp}];
                    costMSD = costMSD + norm(diffInfo - ...
                        squeeze(tempVelo(index, pp, :))' * (ttt - tt) * dt);
                end
            end
        end
    end

    % �ٶ��Ƿ�����Ӻ����۲�ֵ
    % ����tempVelo randn[frames x Tar x Nz]
    function costSVD = SameVeloDiff(tempVelo)
        costSVD = 0;
        index = 0;
        for tt = 1:deltaStep:frameLength - 1
            index = index + 1;
            for pp = 1:length(PosiX{tt})
                targetVelo = squeeze(tempVelo(index, pp, :));
                radarAngle = -radarInfo{tt}{pp}(:, 3); % ���ƫ����
                deltaVelo = norm(targetVelo) * ...
                    cos(atan2(targetVelo(2), targetVelo(1)) + radarAngle);
                costSVD = costSVD + norm(deltaVelo - VeloVec{tt}{pp});
            end
        end
    end

    for tttt = 1:TarNum
        disp(strcat('Ŀ�� ', num2str(tttt) ,' �ٶȣ�'))
        squeeze(Velo(:, tttt, :))
    end
end
