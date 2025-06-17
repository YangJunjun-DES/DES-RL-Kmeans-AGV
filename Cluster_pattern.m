function Index_up = Cluster_pattern(state, Q_converged, method)
%Use a cluster algorithm to generate a control pattern from the learned Q
%table

Value_state = Q_converged(state, :);
if method == 1 %Complex cluster
    if all(Value_state < 0)
        Index_up = 1;  %index=4 means no controllable is selected.
    else
        variance_threshold = 0.1; %设定阈值
        array_variance = var(Value_state); %计算数组方差
        if array_variance < variance_threshold % 如果方差非常小，认为所有元素属于同一类
            % 获取所有下标
            Index_up = 1:length(Value_state);
        else  % 使用 kmeans 分为两类
            [idx, ~] = kmeans(Value_state', 2);
            mean1 = mean(Value_state(idx == 1));
            mean2 = mean(Value_state(idx == 2));
            if mean1 > mean2  %取较大值所属类别
                Index_up = find(idx == 1);
            else
                Index_up = find(idx == 2);
            end
        end
    end
 elseif method == 2  %Larger than zero or not
     if all(Value_state < 0)
        Index_up = 4;  %index=4 means no controllable is selected.
     else
        Index_up = find(Value_state > 0); 
     end
 end
% 默认两类，已验证，比原supervisor 少一个变迁，更新如上。    
%     %the indecies of the values larger than zero  分为两类
%     [idx, ~] = kmeans(Value_state', 2);
%     mean1 = mean(Value_state(idx == 1));
%     mean2 = mean(Value_state(idx == 2));
%     if mean1 > mean2
%         Index_up = find(idx == 1);
%     else
%         Index_up = find(idx == 2);
%     end
end







