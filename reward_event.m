function reward = reward_event(termination, pattern)
%reward for events in the selected pattern
    
    if termination || isempty(pattern)
        reward = -50;
    else
        reward = 10 * length(pattern);  % lager the pattern, larger reward
        for idx = 1 : length(pattern)        
            event = pattern(idx);        
            if event == 32
                idx_r = 10;
            elseif ismember(event, [20, 28])
                idx_r = 5;
            elseif ismember(event, [4, 16])
                idx_r = 2.5;
            else
                idx_r = 0.5;
            end
            reward = reward + idx_r;
        end
        reward = reward / length(pattern);
    end