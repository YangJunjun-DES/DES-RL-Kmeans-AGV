function action = choose_action(current_state,Q_table,epsilon, A)


tau = rand;
if tau > epsilon
    [~,action]=max(Q_table(current_state, :));
    
else
    action = A(randi(length(A),1));
    
end

