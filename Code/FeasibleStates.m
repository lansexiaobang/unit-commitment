function [NStates, flag] = FeasibleStates(Load,GMax,GMin,HOUR,states)
global DEBUG;

NStates = find(Load(HOUR) <= GMax & Load(HOUR) >= GMin);
if isempty(NStates)
    flag = false;
    msg = ['No feasible states in hour ', num2str(HOUR), '!'];
    msgbox(msg,'No feasible states!','warn');
    return;
else
    flag = true;
    
    if DEBUG
        UnitTest(3,states(:,NStates),GMax(NStates),GMin(NStates));
    end
end
end