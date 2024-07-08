% ��¼������Ϣ
% ����1��track ��֪����
% ����2��newTracks �µ����ĺ���
% ����3��maxNum ������ɺ���
% ���1��Tracks �Ѱ����ĺ���
function Tracks = RecordTraceInfo(track, newTracks, maxNum)
    newTracksFlag = zeros([1, length(newTracks)]);
    for tt = 1:length(track)
        % ɾ������ĺ���
        while length(track{tt}) > maxNum
            track{tt}(1) = [];
        end
        tid = track{tt}{1}.ID;
        
        for ttt = 1:length(newTracks)
            if newTracksFlag(ttt), continue; end
            
            ttid = newTracks{ttt}.ID;
            if tid == ttid
                track{tt}{length(track{tt}) + 1} = newTracksFlag(ttt);
                newTracksFlag(ttt) = 1;
            end
        end
    end
    Tracks = track;
end