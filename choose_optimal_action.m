function optimal_action = choose_optimal_action(state_,Event_set_,Q_table)
value = Q_table(state_,Event_set_);
if max(value) == 0
    value_0_index = find(value == 0);   
    optimal_action = value_0_index(randperm(numel(value_0_index),1));
else
    [~,b] = max(Q_table(state_,Event_set_));
    optimal_action = Event_set_(b); 
end

