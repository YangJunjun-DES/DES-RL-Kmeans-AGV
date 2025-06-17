function [pattern_value, pattern_length] = Q_value_eval(Q_table, S, B_new)

load("AGV_1.mat"); 
load("AGV_2.mat"); 
load("AGV_3.mat"); 
load("AGV_4.mat"); 
load("AGV_5.mat");
load("SUP_IPSR.mat");
load("SUP_ZWSR.mat");
load("State_space.mat"); 

%Events
E_c = 1:2:19;
E_u = 2:2:32;

% 初始化 pattern_value 和 pattern_length，用于存储每个动作的评估值和评估长度
pattern_value = zeros(1, size(Q_table, 2));
pattern_length = zeros(1, size(Q_table, 2));

% 遍历所有可能的动作
for pattern_ind = 1:size(Q_table, 2)
    is_Done_test = 0;
    % 执行相应的 Step 函数
    % Components + Supervisors permit events + Agent
    [Event_set,Enb_P] = Eventallowed(S,AGV_1,AGV_2,AGV_3,AGV_4,AGV_5,SUP_IPSR,SUP_ZWSR);
    logic_idx_set = B_new(pattern_ind,:);
    [~, cols] = find(logic_idx_set == 1);
    select_event_set = E_c(cols');
    pattern = intersect(select_event_set, Event_set);
    pattern = union(pattern, E_u);
    pattern = intersect(pattern, Enb_P);

    if ~isempty(pattern) % all_S, R_t and is_Done_test
        State_all = [];
        R_t = 0;
        for event_ind = 1 : length(pattern)
            S_ = StepFunction(S,pattern(event_ind),AGV_1,AGV_2,AGV_3,AGV_4,AGV_5,SUP_IPSR,SUP_ZWSR);
            [~,State_] = ismember(S_,State_space,"rows"); % next state number
            State_all = [State_all, State_];
            R_e = reward_event(0, pattern);
            R_t = R_t + R_e;
            [Event_set_,~] = Eventallowed(S_,AGV_1,AGV_2,AGV_3,AGV_4,AGV_5,SUP_IPSR,SUP_ZWSR);            
            if isempty(Event_set_)
                is_Done_test = 1;
            end
        end
    else
        is_Done_test = 1;
    end

    if is_Done_test
        pattern_value(pattern_ind) = -1e5;
        pattern_length = 0;
    else
        Q_S_ = 0;
        for State_ind = 1 : length(State_all)
            Q_S_ = Q_S_ + max(Q_table(State_all(State_ind)));
        end
        Q_S_exp = Q_S_ ./ length(State_all);  % 使用均值而非最大值，因为有可能进入任何状态
        R_t = R_t ./ length(State_all);
        %  the expected value of Q is two step look ahead
        pattern_value(pattern_ind) = R_t + Q_S_exp;
        pattern_length(pattern_ind) = length(State_all);
    end
end








       