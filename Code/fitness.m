function TotalCost = fitness(G,Load,CurState)

Nh = length(Load);
TotalCost = 0;                  % Total cost -> fitness objective
lambda = 100;                   % Penalty factor

% Determine the initial state
IniState = (G.IniState > 0);

% Reserve is set at 10% percent of the load
Reserve = 0.05 * Load;

% Adding all the cost in the total hours horizon
for HOUR = 1 : Nh
    if sum(CurState(:,HOUR)) == 0
       TotalCost = Inf;
       return;
    end
    if HOUR == 1
        PreState = IniState;
        PreFCost = 0;
    else
        PreState = CurState(HOUR-1);
        PreFCost = TotalCost;
    end
    % Check the state transition 
    % stateTrans = 1 means commited, =1 means decommited
    StateTrans = CurState(:,HOUR) - PreState';
    % The start cost is cosidered as cold start
    GenStartCost = (StateTrans > 0)'.* G.Fsc; 
    % For each feasible state, calculate the cost and dispatch
    [~,Cost] = ED(G.Coef_a,G.Coef_b,G.Coef_c,G.Pmax,G.Pmin,Load(HOUR),CurState(:,HOUR));
    if Cost == Inf
        TotalCost = Inf;
        return;
    else
        if HOUR == 1
            TotalCost = Cost + sum(GenStartCost);
        else
            TotalCost = Cost + sum(GenStartCost) + PreFCost;
        end
    end
    Flag = (G.Pmax * CurState(:,HOUR) < Load(HOUR) + Reserve(HOUR));
    TotalCost = TotalCost + Flag*lambda*(G.Pmax*CurState(:,HOUR)-Load(HOUR)-Reserve(HOUR))^2;
    
end
end