% 前向速度预测
% 输入1：测量多普勒 TarNum x Frame x Measures
% 输入2
% 输入3
% 输入4
% 输入5：优化后速度向量 TarNum x Frame - Delta x Nz
% 输入6：收敛因子 mu
% 输入7：M 滤波器权重大小
% 输入8：deltaStep 
% 输入9：
% 输出1：滤波器权重 W
% 输出2：滤波器输出 Y
% 输出3：误差序列 En
function [W, Vpre, En, VpreValid] = VeloPrediction(VeloVec, RadarVec, PosiX, PosiY, ...
    dVOptimal, dVvalid, dVveloItem, mu, M, deltaStep, iternum, dt)
    Nz = 2;
    sigma = 1e-8;
    itr  = size(dVOptimal, 2);
    W = []; Vpre = []; En = []; VpreValid = [];

    if itr < M + deltaStep, return; end

    tarNum = length(dVvalid);
    En   = zeros(tarNum, Nz, itr);   % 初始化误差信号
    W    = zeros(tarNum, Nz, M, itr);    % 初始化权值矩阵，每一列代表一次迭代
    Vpre = [];
    
    for tt = 1:tarNum
        rtt = dVvalid(tt);
        if sum(dVveloItem(:, rtt)) < M, continue; end % Too less
        VpreValid = [VpreValid; rtt];
        for dd = 1:Nz 
            for kk = M:itr - 1
                if ~dVveloItem(kk, rtt), continue, end
                x = dVOptimal(tt, kk:-1:kk-M + 1, dd);
                y = x * squeeze(W(tt, dd, :, kk-1));              % 滤波器的输出
                dn = dVOptimal(tt, kk + 1, dd);          % 下一时刻的速度值
                en(tt, dd, kk) = dn - y;                 % 第k次迭代的误差
                W(tt, dd, :, kk) = squeeze(W(tt, dd, :, kk-1))+2*mu*en(tt, dd, kk)*x';     % 滤波器权值计算的迭代式
            end

            for kk = 1:deltaStep 
                expectInput = squeeze(dVOptimal(tt, itr:-1:itr + kk - M, dd));
                index = 1;
                while length(expectInput) < M
                    expectInput(end + 1) = Vpre(tt, index, dd);
                    index = index + 1;
                end
                Vpre(tt, kk, dd) = expectInput * squeeze(W(tt, dd, :, end-1)); %
            end
        end

        % 高斯牛顿法 
        for kk = 1:deltaStep
            V1 = Vpre(tt, kk, 1); V2 = Vpre(tt, kk, 2);
            if length(VeloVec{itr + kk}) < rtt, continue; end
            VeloMeasured = VeloVec{itr + kk}{rtt};
            if isempty(VeloMeasured), continue, end
            radarAngle = -RadarVec{itr + kk}{tt}(:, 3);
            for it = 1:iternum
                cuAngle = atan2(V2, V1); cuNorm = norm([V1 V2]);
                VeloComputed = cuNorm * ...
                    cos(cuAngle + radarAngle);
                % 误差计算
                error = VeloMeasured - VeloComputed;
                if norm(error) < sigma, break; end
                Jf = [2 * V1 / cuNorm * cos(cuAngle + radarAngle) + ...
                      V2 / cuNorm * sin(cuAngle + radarAngle) 2 * V2 / cuNorm * ...
                      cos(cuAngle + radarAngle) - V1 / cuNorm * sin(cuAngle + radarAngle)];
                delta_info = inv(Jf' * Jf) * Jf' * error;
    
                if norm(delta_info) < sigma, break; end
                    V1 = V1 + delta_info(1);
                    V2 = V2 + delta_info(2);
            end
            
            if itr + kk + 1 >= length(PosiX)
                % 如果就是当前值 不进行可靠性判断 只进行速度判断
                ERR_ORIN = sum(norm(squeeze(Vpre(tt, kk, :))) * ...
                    cos(atan2(Vpre(tt, kk, 2), Vpre(tt, kk, 1)) + radarAngle));
                ERR_OPTI = sum(norm([V1 V2]) * cos(atan2(V2, V1) + radarAngle));
                if ERR_OPTI < ERR_ORIN, Vpre(tt, kk, 1) = V1; Vpre(tt, kk, 2) = V2; end
            else
                ERR_ORIN = sum(abs(norm(squeeze(Vpre(tt, kk, :))) * ...
                    cos(atan2(Vpre(tt, kk, 2), Vpre(tt, kk, 1)) + radarAngle)));
                ERR_OPTI = sum(abs(norm([V1 V2]) * cos(atan2(V2, V1) + radarAngle)));
                % 评估当前速度的可靠性
                if length(PosiX{itr + kk}) >= rtt && length(PosiX{itr + kk + 1}) >= rtt
                    X = mean(PosiX{itr + kk}{rtt}); Y = mean(PosiY{itr + kk}{rtt});
                    EX = mean(PosiX{itr + kk + 1}{rtt}); EY = mean(PosiY{itr + kk + 1}{rtt});
                    MSE_ORIN = norm([EX EY] - ([X Y] + squeeze(Vpre(tt, kk, :)) * dt));
                    MSE_OPTI = norm([EX EY] - ([X Y] + [V1 V2] * dt));
                    if MSE_OPTI + ERR_OPTI < MSE_ORIN + ERR_ORIN
                        Vpre(tt, kk, 1) = V1; Vpre(tt, kk, 2) = V2; 
                    end
                else
                    if ERR_OPTI < ERR_ORIN, Vpre(tt, kk, 1) = V1; Vpre(tt, kk, 2) = V2; end
                end
            end
        end
    end
end