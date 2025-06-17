function Next_Obs = Next(Action,Obs)
%MYSTEPFUNCTION 此处显示有关此函数的摘要
%   此处显示详细说明

AGV_1 = load("AGV_1.mat"); 
AGV_2 = load("AGV_2.mat"); 
AGV_3 = load("AGV_3.mat"); 
AGV_4 = load("AGV_4.mat"); 
AGV_5 = load("AGV_5.mat");
SUP_IPSR = load("SUP_IPSR.mat");
SUP_ZWSR = load("SUP_ZWSR.mat");
   
action = Action;
State = Obs;
X1 = State(1); 
X2 = State(2); 
X3 = State(3);
X4 = State(4); 
X5 = State(5);
X6 = State(6); 
X7 = State(7);

X1_ = find(AGV_1.AGV_1(X1,:,action) == 1, 1);
if isempty(X1_)
    X1_ = X1;
end
X2_ = find(AGV_2.AGV_2(X2,:,action) == 1, 1);
if isempty(X2_)
    X2_ = X2;
end
X3_ = find(AGV_3.AGV_3(X3,:,action) == 1, 1);
if isempty(X3_)
    X3_ = X3;
end
X4_ = find(AGV_4.AGV_4(X4,:,action) == 1, 1);
if isempty(X4_)
    X4_ = X4;
end
X5_ = find(AGV_5.AGV_5(X5,:,action) == 1, 1);
if isempty(X5_)
    X5_ = X5;
end


X6_ = find(SUP_IPSR.SUP_IPSR(X6,:,action) == 1);
X7_ = find(SUP_ZWSR.SUP_ZWSR(X7,:,action) == 1);



% transform state to observation
State_ = [X1_, X2_, X3_, X4_, X5_, X6_, X7_];
Next_Obs = State_;

