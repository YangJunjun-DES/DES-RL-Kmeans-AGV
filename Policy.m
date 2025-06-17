function [policy, next_state,i_] = Policy(i, Q_converged, AGV_1,AGV_2,AGV_3,AGV_4,AGV_5,SUP_IPSR,SUP_ZWSR,State_space)

    [~, optional_action_set] = max(Q_converged(i,:));
    action  = optional_action_set(randi(numel(optional_action_set),1,1));
    policy = action;
    
    state = State_space(i,:);
    X1 = state(1);
    X2 = state(2);
    X3 = state(3);
    X4 = state(4);
    X5 = state(5);
    X6 = state(6);
    X7 = state(7);

    X1_ = find(AGV_1(X1,:,action) ~= 0);
    if isempty(X1_)
        X1_ = X1;
    end

    X2_ = find(AGV_2(X2,:,action) ~= 0);
    if isempty(X2_)
        X2_ = X2;
    end

    X3_ = find(AGV_3(X3,:,action) ~= 0);
    if isempty(X3_)
        X3_ = X3;
    end

    X4_ = find(AGV_4(X4,:,action) ~= 0);
    if isempty(X4_)
        X4_ = X4;
    end

    X5_ = find(AGV_5(X5,:,action) ~= 0);
    if isempty(X5_)
        X5_ = X5;
    end


    X6_ = find(SUP_IPSR(X6,:,action) ~= 0);
    X7_ = find(SUP_ZWSR(X7,:,action) ~= 0);
    
    next_state = [X1_,X2_,X3_,X4_,X5_,X6_,X7_];
    [~,i_] = ismember(next_state,State_space,"rows");

end

