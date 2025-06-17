function reward = reward_exp(termination, state,pattern,Q_table, State_space, AGV_1,AGV_2,AGV_3,AGV_4,AGV_5,SUP_IPSR,SUP_ZWSR)
    
    if termination
        reward = -100;
    else
        Sum_Max_value = 0; 
        for i = 1 : length(pattern)
            event = pattern(i);
            next = StepFunction(state,event,AGV_1,AGV_2,AGV_3,AGV_4,AGV_5,SUP_IPSR,SUP_ZWSR);
            [~,next_num] = ismember(next,State_space,"rows"); % next state number
            Max_value = max(Q_table(next_num,:));
            Sum_Max_value = Sum_Max_value + Max_value; 
        end
        reward = Sum_Max_value / length(pattern);
    end


