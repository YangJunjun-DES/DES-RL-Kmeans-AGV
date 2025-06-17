function [Enable_P_S, Enable_P] = Eventallowed(Observation,AGV_1,AGV_2,AGV_3,AGV_4,AGV_5,SUP_IPSR,SUP_ZWSR)
 X1 = Observation(1); 
        X2 = Observation(2); 
        X3 = Observation(3);
        X4 = Observation(4); 
        X5 = Observation(5);
        X6 = Observation(6); 
        X7 = Observation(7);

        Enable_P1 = AvailableEvents(X1, AGV_1);
        Enable_P2 = AvailableEvents(X2, AGV_2);
        Enable_P3 = AvailableEvents(X3, AGV_3);
        Enable_P4 = AvailableEvents(X4, AGV_4);
        Enable_P5 = AvailableEvents(X5, AGV_5);
        
        Enable_P = union(union(Enable_P1,Enable_P2),Enable_P3); 
        Enable_P = union(union(Enable_P,Enable_P4),Enable_P5);% Available events allowed by plant at current global state
        
        Enable_B1SUP = AvailableEvents(X6, SUP_IPSR);
        Enable_B2SUP = AvailableEvents(X7, SUP_ZWSR);
        
        Enable = intersect(Enable_B1SUP,Enable_B2SUP);   % Available events allowed by modular supervisors at current global state
        Enable_P_S = intersect(Enable,Enable_P);  
end

