state = 1;
C_B1 = 0;
C_B2 = 0;
Policy_set = [];
num_Z1 = 0; num_Z2 = 0; num_Z3 = 0; num_Z4 = 0;
num_WS1 = 0; num_WS2 = 0; num_WS3 = 0;
num_IP = 0;
Num = [num_Z1,num_Z2,num_Z3,num_Z4,num_WS1,num_WS2,num_WS3,num_IP];
for step = 1:1000
    
    [policy, next_state, state_] = Policy(state, Q_table, AGV_1,AGV_2,AGV_3,AGV_4,AGV_5,SUP_IPSR,SUP_ZWSR,State_space);
    
    event = policy;

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
        num_Z2 = num_Z2 - 1;
        num_WS1 = num_WS1 + 1;
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
        num_WS1 = num_WS1 + 1;
    elseif event == 30
        num_WS1 = num_WS1 - 2;
        num_Z4 = num_Z4 - 1;  
    elseif event == 32
        num_Z4 = num_Z4 - 1;
    end
    
    

    Num = [num_Z1,num_Z2,num_Z3,num_Z4,num_WS1,num_WS2,num_WS3,num_IP];
    termination = 0;
    for i = 1 : length(Num)
        if i ~= 5
            if Num(i) < 0 || Num(i) > 1
                fprintf('100-step failed!\n');
                break
            end
        else
            if Num(i) < 0 || Num(i) > 2
                fprintf('1000-step failed!\n');
                break
            end
        end
    end

    state = state_;
    Policy_set(end + 1) = policy;
    
    
    
end
if step == 1000
    fprintf('The result is 1000-step correct!\n');
end

