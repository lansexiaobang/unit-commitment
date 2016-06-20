function OptimalCost = PL(G,Load)

NG = length(G.Pmax);              % # of genereations
Nh = length(Load);              % # of load hour
CurStateId = zeros(1,Nh);       % Current state index

% Obtain the full priority list based on average fuel cost 
[States, GMax, GMin] = PriorityList(G);

for HOUR = 1 : Nh
    if (Load(HOUR) < min(GMin) || Load(HOUR) > max(GMax))
        msg = fprintf('NO Feasible PL Scheduling for Load in Hour %2d!',HOUR);
        msgbox(msg, 'WARNING','warn');
        return;
    end
    CurStateId(HOUR) = numel(find(GMax < Load(HOUR))) + 1;
end

% Obtain all the schedule details
IniState = (G.IniState > 0);
CurState = States(:,CurStateId);   
States = [IniState',CurState];

% Print the scheduling result 
OptimalCost = PrintResult(G,Load,States);

end