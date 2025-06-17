%% Model of AGVs

%AGV 1
% AGV_1 = zeros(4,4,32);
% 
% AGV_1(1,2,1) = 1;
% AGV_1(2,3,2) = 1;
% AGV_1(3,4,3) = 1;
% AGV_1(4,1,4) = 1;
% 
% %AGV 2
% 
% AGV_2 = zeros(8,8,32);
% AGV_2(1,2,5) = 1;
% AGV_2(2,3,6) = 1;
% AGV_2(3,4,8) = 1;
% AGV_2(4,5,10) = 1;
% AGV_2(5,6,7) = 1;
% AGV_2(6,7,12) = 1;
% AGV_2(7,8,14) = 1;
% AGV_2(8,1,16) = 1;
% 
% %AGV 3
% 
% AGV_3 = zeros(4,4,32);
% AGV_3(1,2,9) = 1;
% AGV_3(2,3,18) = 1;
% AGV_3(3,4,11) = 1;
% AGV_3(4,1,20) = 1;
% 
% %AGV 4
% 
% AGV_4 = zeros(6,6,32);
% AGV_4(1,2,13) = 1;
% AGV_4(2,3,22) = 1;
% AGV_4(3,4,24) = 1;
% AGV_4(4,5,15) = 1;
% AGV_4(5,6,26) = 1;
% AGV_4(6,1,28) = 1;
% 
% %AGV 5
% 
% 
% AGV_5(1,2,17) = 1;
% AGV_5(2,3,30) = 1;
% AGV_5(3,4,19) = 1;
% AGV_5(4,1,32) = 1;
%  
%  Action_set = 1:1:32;
% 
% 
% Com = {};
% for i = 1 : 4
%     for j = 1 : 8
%         for k = 1 : 4
%             for m = 1 : 6
%                 for n = 1 : 4
%                     for a = 1 : 2
%                         for b = 1 : 256
%                             Com{end+1} = [i,j,k,m,n,a,b];
%                         end
%                     end
%                 end
%             end
%         end
%     end
% end
% % 
% % 
% % 
% % 
% % %% Specifications
% % 
% % % Initialization of areas
num_Z1 = 0; num_Z2 = 0; num_Z3 = 0; num_Z4 = 0;
num_WS1 = 0; num_WS2 = 0; num_WS3 = 0;
num_IP = 0;
% % 
% % % Changes of capacity 
% % 
event = 1;
is_WS1 = [];
if event == 1
    num_Z1 = num_Z1 + 1;
elseif event == 2
    num_Z1 = num_Z1 - 1;
    num_IP = num_IP + 1;
elseif event == 3
    num_Z1 = num_Z1 + 1;
    num_IP = num_IP - 1;
elseif event == 4
    num_Z1 = num_Z1 - 1;
    num_WS2 = num_WS2 + 1;
elseif event == 5
    num_Z3 = num_Z3 + 1;
elseif event == 6
    num_Z2 = num_Z2 + 1;
    num_Z3 = num_Z3 - 1;
elseif event == 7
    num_Z1 = num_Z1 + 1;
    num_IP = num_IP - 1;
elseif event == 8
    num_Z1 = num_Z1 + 1;
    num_Z2 = num_Z2 - 1;
elseif event == 9
    num_Z2 = num_Z2 + 1;
elseif event == 10
    num_Z1 = num_Z1 - 1;
    num_IP = num_IP + 1;
elseif event == 11
    num_Z2 = num_Z2 + 1;
elseif event == 12
    num_Z1 = num_Z1 - 1;
    num_Z2 = num_Z2 + 1;
elseif event == 13
    num_Z3 = num_Z3 + 1;
elseif event == 14
    num_Z2 = num_Z2 - 1;
    num_Z3 = num_Z3 + 1;
elseif event == 15
    num_Z4 = num_Z4 + 1;
elseif event == 16
    num_Z3 = num_Z3 - 1;
    num_WS3 = num_WS3 + 1;
elseif event == 17
    num_Z4 = num_Z4 + 1;
elseif event == 18
    num_Z2 = num_Z2 - 1;
    num_WS2 = num_WS2 - 1;
elseif event == 19
    num_Z4 = num_Z4 + 1;
elseif event == 20
    is_WS1(end+1) = event;
    num_Z2 = num_Z2 - 1;
elseif event == 22
    num_Z3 = num_Z3 - 1;
    num_Z4 = num_Z4 + 1;
elseif event == 24
    num_Z4 = num_Z4 - 1;
    num_WS3 = num_WS3 - 1;
elseif event == 26
    num_Z3 = num_Z3 + 1;
    num_Z4 = num_Z4 - 1;
elseif event == 28
    num_Z3 = num_Z3 - 1;
    is_WS1(end+1) = event;
elseif event == 30
    num_WS1 = num_WS1 - 1;
    num_Z4 = num_Z4 - 1;  
    is_WS1 = [];
elseif event == 32
    num_Z4 = num_Z4 - 1;
end
% WS1: Special specification
is_WS1 = unique(is_WS1);
if isequal(is_WS1, [20,28]) || isequal(is_WS1, [28,20])
    num_WS1 = num_WS1 + 1;
end
% 
% 
Num = [num_Z1,num_Z2,num_Z3,num_Z4,num_WS1,num_WS2,num_WS3,num_IP];
termination = 0;
for i = 1 : length(Num)
    if Num(i) < 0 || Num(i) > 1
        termination = 1;
    end
end
% IsDone = termination;
% % 
% % 
% % %% Reward
% % if ~IsDone
% %     if event == 32
% %         Reward = 10;
% %     else
% %         Reward = 0.1;
% %     end
% % else
% %     Reward = -10;
% % end

clear;clc;
AGV_1 = load("AGV_1.mat"); 
AGV_2 = load("AGV_2.mat"); 
AGV_3 = load("AGV_3.mat"); 
AGV_4 = load("AGV_4.mat"); 
AGV_5 = load("AGV_5.mat");
SUP_IPSR = load("SUP_IPSR.mat");
SUP_ZWSR = load("SUP_ZWSR.mat");

State_space = zeros(1,7);
State_reach = zeros(1,7);
initial_s = [1,1,1,1,1,1,1];
State_space(1,:) = initial_s;
State_reach(1,:) = initial_s;

while(~isempty(State_reach))

    State = State_reach(1,:);
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
    
    
    for i = 1: length(Enable_P_S)
        event = Enable_P_S(i);
        State_ = Next(event,State);
        if ~ismember(State_,State_space,"rows")
            State_space = [State_space;State_];
            State_reach = [State_reach;State_];
        end
    end
    State_reach(1,:) = [];
end
    








