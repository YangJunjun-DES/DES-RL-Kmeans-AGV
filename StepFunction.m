function Observation_ = StepFunction(Observation,Action_exe,AGV_1,AGV_2,AGV_3,AGV_4,AGV_5,SUP_IPSR,SUP_ZWSR)

    Action = Action_exe;
    X1 = Observation(1);
    X2 = Observation(2);
    X3 = Observation(3);
    X4 = Observation(4);
    X5 = Observation(5);
    X6 = Observation(6);
    X7 = Observation(7);

    X1_ = find(AGV_1(X1,:,Action) ~= 0);
    if isempty(X1_)
        X1_ = X1;
    end

    X2_ = find(AGV_2(X2,:,Action) ~= 0);
    if isempty(X2_)
        X2_ = X2;
    end

    X3_ = find(AGV_3(X3,:,Action) ~= 0);
    if isempty(X3_)
        X3_ = X3;
    end

    X4_ = find(AGV_4(X4,:,Action) ~= 0);
    if isempty(X4_)
        X4_ = X4;
    end

    X5_ = find(AGV_5(X5,:,Action) ~= 0);
    if isempty(X5_)
        X5_ = X5;
    end
    X6_ = find(SUP_IPSR(X6,:,Action) ~= 0);
    X7_ = find(SUP_ZWSR(X7,:,Action) ~= 0);

    Observation_ = [X1_,X2_,X3_,X4_,X5_,X6_,X7_];

end

