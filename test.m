clear;clc
tic
%plant components and modular supervisors
load("AGV_1.mat"); 
load("AGV_2.mat"); 
load("AGV_3.mat"); 
load("AGV_4.mat"); 
load("AGV_5.mat");
load("SUP_IPSR.mat");
load("SUP_ZWSR.mat");
load("State_space.mat");
%load('Q_table.mat')

%Controllable events
E_c = 1:2:19;
E_u = 2:2:32;
k = 2; %select at most one controllable event
B = set_of_controllable_event_subset(E_c, k);
A = 1:1:length(B); %action set
%Q table
Q_table = zeros(length(State_space),length(A));

%parameters
epsilon = 0.95;
gamma = 0.99;
alpha = 0.95;
epsilonDecay = 1e-5;
episode = 0;
initial_Observation = [1,1,1,1,1,1,1];
FiveEpisodeRewardTotal = zeros(1,30);

minimal_episode = 5000;
minimal_step = 100;
av = 0;
% episode < minimal_episode
% av < 106

while(episode < minimal_episode) 
%     array = [1, 3713];
%     random_index = randi(length(array)); % 随机生成一个索引
%     random_element = array(random_index); % 提取对应的元素
%     initial_Observation = State_space(random_element, :);  % 训练一段时间后，随机取初始状态，继续训练。

    Observation = initial_Observation;
    step = 0;
    EpisodeReward = 0;
    while(step<minimal_step)
        [~,state] = ismember(Observation,State_space,"rows"); % state number               
        pattern_index = choose_action(state,Q_table,epsilon,A);
        Event_subset = B{pattern_index};
        % Components + Supervisors permit events + Agent
        [Enable_P_S, Enable_P] = Eventallowed(Observation,AGV_1,AGV_2,AGV_3,AGV_4,AGV_5,SUP_IPSR,SUP_ZWSR);
        feasible = intersect(Event_subset, Enable_P_S);
        feasible = union(feasible, E_u);
        feasible = intersect(feasible, Enable_P);
        
        
        if ~isempty(feasible)
            event_exe = feasible(randi(length(feasible),1));
            Observation_ = StepFunction(Observation,event_exe,AGV_1,AGV_2,AGV_3,AGV_4,AGV_5,SUP_IPSR,SUP_ZWSR);
            [~,state_] = ismember(Observation_,State_space,"rows"); % next state number
            
            Sum_Max_value = 0; 
            Sum_reward = 0;    
            termination = 0;
            % Check if the selected control pattern is correct
            for i = 1 : length(feasible)
                event = feasible(i);
                next = StepFunction(Observation,event,AGV_1,AGV_2,AGV_3,AGV_4,AGV_5,SUP_IPSR,SUP_ZWSR);
                Enable_P_S_ = Eventallowed(next,AGV_1,AGV_2,AGV_3,AGV_4,AGV_5,SUP_IPSR,SUP_ZWSR);            
                if isempty(Enable_P_S_) % a deadlock occurs
                    termination = 1;
                    break
                end
            end
        else  %the feasible is empty
            termination = 1;
            Observation_ = Observation;
            state_ = state;
        end

        r = reward_event(termination, feasible);  
        MaxQ = reward_exp(termination,Observation,feasible,Q_table, State_space, AGV_1,AGV_2,AGV_3,AGV_4,AGV_5,SUP_IPSR,SUP_ZWSR); % state value exp
        Q_table(state, pattern_index) = Q_table(state, pattern_index) + alpha * (r + gamma * MaxQ - Q_table(state, pattern_index));

        step = step + 1;
        EpisodeReward = EpisodeReward + r;
        
%         if termination == 1
%             fprintf('Episode %d is Blocking\n', episode);
%             break
%         end

        Observation = Observation_;
        if epsilon > 0.05
            epsilon = epsilon * (1 - epsilonDecay);
        end
        
    end
    episode = episode + 1; 

    EpisodeRewardMemory(episode) = EpisodeReward;
    FiveEpisodeRewardTotal(end + 1) = EpisodeReward;
    if length(FiveEpisodeRewardTotal) > 100
        FiveEpisodeRewardTotal(1) = [];
    end
    AverageReward(episode) = mean(FiveEpisodeRewardTotal);
    av = AverageReward(episode);
    
    
end

plot(1:episode, EpisodeRewardMemory); 
hold on
plot(1:episode, AverageReward); 

toc   

























