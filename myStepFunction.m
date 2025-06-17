function [NextObs,Reward,IsDone,LoggedSignals] = myStepFunction(Action,LoggedSignals)
%MYSTEPFUNCTION 此处显示有关此函数的摘要
%   此处显示详细说明

% AGVs models
AGV_1 = load("AGV_1.mat"); 
AGV_2 = load("AGV_2.mat"); 
AGV_3 = load("AGV_3.mat"); 
AGV_4 = load("AGV_4.mat"); 
AGV_5 = load("AGV_5.mat");
SUP_IPSR = load("SUP_IPSR.mat");
SUP_ZWSR = load("SUP_ZWSR.mat");

%Action space
Action_set = load("Action_set.mat");

if ~ismember(Action,Action_set.Action_set)
    error('Action must belongs to Action space');
end

%The action selected by epsilon-greedy policy
action = Action;

% Current global state
State = LoggedSignals.State;
X1 = State(1); 
X2 = State(2); 
X3 = State(3);
X4 = State(4); 
X5 = State(5);
X6 = State(6); 
X7 = State(7);

Enable_P1 = AvailableEvents(X1, AGV_1.AGV_1);
Enable_P2 = AvailableEvents(X2, AGV_2.AGV_2);
Enable_P3 = AvailableEvents(X3, AGV_3.AGV_3);
Enable_P4 = AvailableEvents(X4, AGV_4.AGV_4);
Enable_P5 = AvailableEvents(X5, AGV_5.AGV_5);

Enable_P = union(union(Enable_P1,Enable_P2),Enable_P3); 
Enable_P = union(union(Enable_P,Enable_P4),Enable_P5);% Available events allowed by plant at current global state

Enable_B1SUP = AvailableEvents(X6, SUP_IPSR.SUP_IPSR);
Enable_B2SUP = AvailableEvents(X7, SUP_ZWSR.SUP_ZWSR);

Enable = intersect(Enable_B1SUP,Enable_B2SUP);   % Available events allowed by modular supervisors at current global state
Enable_P_S = intersect(Enable,Enable_P);

is_not_available = 0;   % The event selected by the neural network is defined 
termination = 0;

if isempty(Enable_P_S)  % The current state is blocking
    termination = 1;
    X1_ = X1;
    X2_ = X2;
    X3_ = X3;
    X4_ = X4;
    X5_ = X5;
    X6_ = X6;
    X7_ = X7;
elseif ismember(action,Enable_P_S)  % action selected is permitted 
    Enable_P_S_u = Enable_P_S(mod(Enable_P_S,2)==0); 
    Enable_P_S_current = union(action, Enable_P_S_u);
    action1 = Enable_P_S_current(randi(length(Enable_P_S_current),1));

    X1_ = find(AGV_1.AGV_1(X1,:,action1) ~= 0);
    if isempty(X1_)
        X1_ = X1;
    end

    X2_ = find(AGV_2.AGV_2(X2,:,action1) ~= 0);
    if isempty(X2_)
        X2_ = X2;
    end

    X3_ = find(AGV_3.AGV_3(X3,:,action1) ~= 0);
    if isempty(X3_)
        X3_ = X3;
    end

    X4_ = find(AGV_4.AGV_4(X4,:,action1) ~= 0, 1);
    if isempty(X4_)
        X4_ = X4;
    end

    X5_ = find(AGV_5.AGV_5(X5,:,action1) ~= 0, 1);
    if isempty(X5_)
        X5_ = X5;
    end

    X6_ = find(SUP_IPSR.SUP_IPSR(X6,:,action1) ~= 0);
    X7_ = find(SUP_ZWSR.SUP_ZWSR(X7,:,action1) ~= 0);    
else  % action selected is not permitted 
    is_not_available = 1;
    X1_ = X1;
    X2_ = X2;
    X3_ = X3;
    X4_ = X4;
    X5_ = X5;
    X6_ = X6;
    X7_ = X7;
end


State_ = [X1_, X2_, X3_, X4_, X5_, X6_, X7_];
LoggedSignals.State = State_;
NextObs = LoggedSignals.State;


IsDone = termination || is_not_available;

%% Reward
if ~IsDone
    if action == 32
        Reward = 10;
    else
        Reward = 0.1;
    end
else
    Reward = -10;
end



        



