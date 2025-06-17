clear;clc
%plant components and modular supervisors
load("AGV_1.mat"); 
load("AGV_2.mat"); 
load("AGV_3.mat"); 
load("AGV_4.mat"); 
load("AGV_5.mat");
load("SUP_IPSR.mat");
load("SUP_ZWSR.mat");
load("State_space.mat");
load('B_new.mat') % 11X10 choices
load("Q_table.mat");
%Controllable events
E_c = 1:2:19;
E_u = 2:2:32;

num_transtions = 0;
OBSER = 1;
OBSER1 = 1;
Imp_Q_table = zeros(size(Q_table, 1), size(Q_table, 2));

method = 1;  
online = 1;

RO_nodes = 10;
RO_traces = 50;
RO_depth = 4;
RO_gamma = 0.95;
n_actions = 11;



while(~isempty(OBSER))
    state = OBSER(1);
    isDone = 0;
    Observation = State_space(state,:);
    if method == 1  % maximal value pattern index  26 states
        [~, pattern_index] = max(Q_table(state,:)); 
    elseif method == 2   
        if ~online   %Only cluetering algorithm   3609 states
            pattern_index = Cluster_pattern(state, Q_table, 1);
        else        %Online algorithm  4339 states  
            [pattern_value, ~] = rollout_test(Q_table, state, RO_nodes, ...
                RO_traces, RO_depth, RO_gamma, n_actions, State_space, B_new);
            Imp_Q_table(state, :) = pattern_value;
            pattern_index = Cluster_pattern(1, pattern_value, 1);
        end
    end

    logic_idx_set = B_new(pattern_index,:);
%     select_event_index = logic_idx_set == 1;
    [~, cols] = find(logic_idx_set == 1);
    select_event_set = E_c(cols'); % the selected event set
    [Enable_P_S, Enable_P] = Eventallowed(Observation,AGV_1,AGV_2,AGV_3,AGV_4,AGV_5,SUP_IPSR,SUP_ZWSR);
    pattern = intersect(select_event_set, Enable_P_S);
    pattern = union(pattern, E_u);
    pattern = intersect(pattern, Enable_P);

    if ~isempty(pattern)
        for i = 1 : length(pattern)
            event = pattern(i);
            next = StepFunction(Observation,event,AGV_1,AGV_2,AGV_3,AGV_4,AGV_5,SUP_IPSR,SUP_ZWSR);
            [~,next_num] = ismember(next,State_space,"rows");
            Enable_P_S_ = Eventallowed(next,AGV_1,AGV_2,AGV_3,AGV_4,AGV_5,SUP_IPSR,SUP_ZWSR);  
            if isempty(Enable_P_S_)
                fprintf("A deadlock occurs!\n");
                isDone = 1;
                break
            else
                if (~ismember(next_num,OBSER1)) 
                    OBSER1(end+1) = next_num;
                    OBSER(end+1) = next_num;
                end
                fprintf('%d->%d[label=%d];\n',state,next_num,event);
                num_transtions = num_transtions + 1; 
            end
        end
    else
        fprintf("Pattern is empty!\n");
        isDone = 1;
        break
    end

    OBSER(1) = [];
    if isDone
        break
    end
end





