% �����״ﺽ��
% ����1��Tracks �״ﺽ��
% ����2��ID ������Ŀ
% ����3��figureIndex ͼ������
% �����
function plotRadarTracks(Tracks, ID, figureIndex)
    if nargin == 2, figureIndex = 10000; end
    
    figure(figureIndex)
    frames = size(Tracks, 2);
    
    plot_target_total = {};
    hold on
    for tt = 1:ID - 1
        plot_target = [];
        for ff = 1:frames
            if isempty(Tracks{ff})
                
            else
                for target_index = 1:length(Tracks{ff})
                    if isempty(Tracks{ff}{target_index}), continue; end
                    if Tracks{ff}{target_index}(1) == tt % ��ÿ��ID���м��
                        plot_target = [plot_target; Tracks{ff}{target_index}(2:end)];
                    end
                end
            end
        end
        plot_target_total{tt} = plot_target;
        if isempty(plot_target), continue; end
        %plot(plot_target(:, 1), plot_target(:, 2), 'r-.', 'linewidth', 1)
        scatter(plot_target(:, 1), plot_target(:, 2), 5, 'filled', 'r')
    end
    hold off
end