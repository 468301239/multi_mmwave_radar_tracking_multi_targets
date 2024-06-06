% �������ۺ���
% ����1��DetectRes��rr tt amp��
% ����2��minimal_confirm ��Сȷ�Ͼ������
% ����3��consequence_range ��������뾶
% ����4��consequence_velo �����ٶȰ뾶
% ����5���Ƿ�
% ���1��Res �õ��ľ������۽�� ��rr tt var_rr var_tt amp��
%
function Res = RangeCentroid(DetectRes, ...
    minimal_confirm, ...
    consequence_range, ...
    consequence_velo)
    if nargin == 1
        minimal_confirm = 3;
        consequence_range = 3;
        consequence_velo = 3;
    end
    Res = [];

    while ~isempty(DetectRes)
        compare_range  = DetectRes(1, 1);      % ��ǰ����
        compare_velo   = DetectRes(1, 2);      % ��ǰ�ٶ�
        compare_weight = abs(DetectRes(1, 3)); % ��ǰ����
        temporary_compare_range  = DetectRes(1, 1);      % ��ǰ����
        temporary_compare_velo   = DetectRes(1, 2);      % ��ǰ�ٶ�
        temporary_compare_weight = abs(DetectRes(1, 3)); % ��ǰ����
        DetectRes(1, :) = [];            % ɾ��������
        delete_index = [];               % ��Ч������
        record_num = 1;                  % ��¼�۲����
        Temporary_DetectRes = DetectRes; % ��ʱ��¼��
        % �ں��ܱ�Ŀ�� ֻ������ ��ǰ����
        while 1
            find_new_target = 0;
            temporary_delete_index = [];
            weight_record = [temporary_compare_weight];
            index = 1;
            while index < size(Temporary_DetectRes, 1) && size(Temporary_DetectRes, 1) >= 2
                cur_range  = Temporary_DetectRes(index, 1);      % ��ǰ����
                cur_velo   = Temporary_DetectRes(index, 2);      % ��ǰ�ٶ�
                cur_weight = abs(Temporary_DetectRes(index, 3)); % ��ǰ���� 

                if abs(cur_range - temporary_compare_range) < consequence_range && ...
                    abs(cur_velo - temporary_compare_velo) < consequence_velo
                    find_new_target = 1;
                    temporary_delete_index = [temporary_delete_index index];
                    weight_record = [weight_record cur_weight];
                    record_num = record_num + 1;
                end
                index = index + 1;
            end

            if ~isempty(temporary_delete_index)
                temporary_compare_weight = sum(weight_record) / length(weight_record);
                weight_record = weight_record / sum(weight_record);
                temporary_compare_range = sum([temporary_compare_range Temporary_DetectRes(temporary_delete_index, 1)'] .* weight_record);
                temporary_compare_velo  = sum([temporary_compare_velo Temporary_DetectRes(temporary_delete_index, 2)'] .* weight_record);
                Temporary_DetectRes(temporary_delete_index, :) = [];
                delete_index = [delete_index temporary_delete_index];
                temporary_delete_index = [];
                weight_record = [temporary_compare_weight];
            end

            if ~find_new_target
                break;
            end
        end
        
        if record_num >= minimal_confirm
            range  = [compare_range, abs(DetectRes(delete_index, 1))'];
            velo   = [compare_velo, abs(DetectRes(delete_index, 2))'];
            weight = [compare_weight, abs(DetectRes(delete_index, 3))'];
            compare_weight = sum(weight) / length(compare_weight);
            weight = weight / sum(weight);
            compare_range = sum(range .* weight);
            compare_velo = sum(velo .* weight);
            var_range = var(range- compare_range);
            var_velo = var(velo- compare_velo);
            DetectRes(delete_index, :) = [];
            Res = [Res; compare_range compare_velo var_range, var_velo, compare_weight];
        end
    end
end