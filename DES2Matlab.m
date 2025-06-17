% SUP_IPSR = zeros(2,2,32);   % 2: number od states, 32:actions
% for i = 1:11
%     for j = 2:4:14
%         s = IPSR(i,j) + 1;
%         a = IPSR(i,j+1);
%         s_ = IPSR(i,j+2) + 1;
%         SUP_IPSR(s,s_,a) = 1;
%     end
% end




SUP_ZWSR = zeros(256,256,32);
for i = 1:400
    for j = 2:4:14
        s = ZWSR(i,j) + 1;
        a = ZWSR(i,j+1);
        s_ = ZWSR(i,j+2) + 1;
        SUP_ZWSR(s,s_,a) = 1;
    end
end