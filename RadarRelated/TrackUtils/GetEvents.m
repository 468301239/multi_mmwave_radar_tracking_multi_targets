% ��ȡ�¼�
% ��ȡJPDA�����¼�
% ����1��������� measure_confirm_matrix
% ����2������¼��� max_events
% ���1��interconnect_matrix
% ���2��event_num ��Ч�¼���Ŀ
%
function [interconnect_matrix, event_num] = GetEvents(measure_confirm_matrix, max_events)
    size_measures = size(measure_confirm_matrix, 1);
    size_targets  = size(measure_confirm_matrix, 2);
    interconnect_matrix = zeros(size_measures, size_targets, max_events);
    event_num = 0;
    
    if size_measures ~= 0
        vectors = {};
        % �������
        for mm = 1:size_measures
            index = find(measure_confirm_matrix(mm, :) == 1);
            for tt = 1:length(index)
                vectors{mm}{tt} = zeros(1, size_targets); % ÿ�����ֵ���Ϊ��ͬ������
                vectors{mm}{tt}(index(tt)) = 1;
            end
        end
        
        composed_result = {};
        temp_result = [];
        tt = -1;
        mm = 1;
        [~, composed_result] = build_events_trees(vectors, ...
                                            composed_result, temp_result, tt, mm, ...
                                            size_measures, size_targets);
                                        
        event_num = length(composed_result);
        for iii = 1:event_num
            if iii > max_events, break, end
            interconnect_matrix(:, :, iii) = composed_result{iii};
        end
    
    else
        return
    end
end

% �����Ч���
% temp_result ��ǰ�����
% composed_result ��ϵĽ������
% vectors: ��ϵ�����
% tt: �ڼ���Ŀ��
% mm: �ڼ�������ֵ
function [valid, composed_result] = build_events_trees(vectors, ...
                                            composed_result, temp_result, tt, mm, ...
                                            measurements, targets)
    valid = 0;
    % ���
    if mm <= 0
        error('JPDA SubFunction Building Events Trees: measurements Error');
    end
    
    if tt <= 0 && ~isempty(temp_result)
        error('JPDA SubFunction Building Events Trees: target num Error');
    end
    
    if targets <= 1
        error('JPDA SubFunction Building Events Trees: no validate targets')    
    end
    
    if isempty(temp_result)
        % ֻ��һ������
        if size(vectors, 2) == 1 && isempty(temp_result)
            for iii = 1:length(vectors{mm})
                composed_result{iii} = vectors{mm}{iii};
            end
            return
        end
        
        for ttt = 1:length(vectors{mm})
            % ��Բ�ͬ�Ĳ���ֵ
            temp_result = vectors{mm}{ttt};
            for tttt = 1:length(vectors{mm + 1})
                [valid, composed_result] = build_events_trees(vectors, ...
                                            composed_result, temp_result, tttt, mm + 1, ...
                                            measurements, targets);
            end
        end
        % ��������
        return;
    end
    
    % �Ӳ�ʼ���ǵ�һ������ֵ
    % ��⵱ǰ�������������Ƿ���Ч
    temp_result = [temp_result; vectors{mm}{tt}];
    for ii = 2:targets
        if sum(temp_result(:, ii)) > 1
            valid = 0;
            return;
        end
    end
    
    % �Ѿ��������
    if mm >= measurements
        composed_result{length(composed_result) + 1} = temp_result;
        valid = 1;
        return;
    end
    
    % ��������
    for ttt = 1:length(vectors{mm + 1})
        [valid, composed_result] = build_events_trees(vectors, ...
                                            composed_result, temp_result, ttt, mm + 1, ...
                                            measurements, targets);
        
    end

end
