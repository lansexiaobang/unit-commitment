function OptimalCost = DP(G, Load)
% Dynamic programming

global FULLSTATES;

% Calculate the size of unit commitment problem
Nh = length(Load);               % # of load hour

if FULLSTATES == 0
    % Using Priority-list
    [States,GMax,GMin] = PriorityList(G);
else
    % Enumerate all the combinations
    [States,GMax,GMin] = Enumerate(G);
end

% Save N = 1 lowest cost for each transition

% Determine the initial state
IniState = (G.IniState > 0);
[~,IniStateId] = ismember(IniState,States','rows');

% Captitalized HOUR and STATE are indices
for HOUR = 1 : Nh
    fprintf('Starting processing the UC in hour %d\n', HOUR);
    
    % record the status of previous hour
    if HOUR == 1                                
        PreStateId = IniStateId;        % initial state
        PreTransM  = PreStateId;
    else
        PreFCost   = CurFCost;
        PreStateId = CurTransM(:,end);
        PreTransM  = CurTransM;
    end
    
    % Find all the feasible states for each hour(states index)
    [FeasiState, flag] = FeasibleStates(Load,GMax,GMin,HOUR,States);
    if (~flag)
        return;
    end
    
    NF = length(FeasiState);             % # of feasible states
    NP = length(PreStateId);             % # of previous states              
    % Initialize the parameters
    % The total cost of getting to all feasible states in current hour
    CurFCost  = zeros(NF,1);
    % Transition matrix of optimal path to all feasible states in current hour
    CurTransM = zeros(NF,HOUR+1); 
    % Total cost list for all previous states to a current state
    TotalCost = zeros(NP,1);          
    % Search each feasible state
    for CurStateCnt = 1 : NF
        CurState = States(:,FeasiState(CurStateCnt));
        % Search each previous feasible state
        for PreStateCnt = 1 : NP
            if HOUR == 1
                PreState = IniState';
            else
                PreState = States(:,PreStateId(PreStateCnt));
            end
            % Check the state transition 
            % stateTrans = 1 means commited, =1 means decommited
            StateTrans = CurState - PreState;
            % The start cost is cosidered as cold start
            GenStartCost = (StateTrans > 0)'.* G.Fsc; 
            % For each feasible state, calculate the cost and dispatch
            [~,Cost] = ED(G.Coef_a,G.Coef_b,G.Coef_c,G.Pmax,G.Pmin,Load(HOUR),States(:,FeasiState(CurStateCnt)));
            if HOUR == 1
                TotalCost(PreStateCnt) = Cost + sum(GenStartCost);
            else
                TotalCost(PreStateCnt) = Cost + sum(GenStartCost) + PreFCost(PreStateCnt);
            end
        end
        
        % Calculate the minimum cost to get to current state
        [CurFCost(CurStateCnt), Index] = min(TotalCost);
        % Update the transition matrix
        CurTransM(CurStateCnt,1:size(PreTransM,2)) = PreTransM(Index,:);
        CurTransM(CurStateCnt,end) = FeasiState(CurStateCnt);
    end
end
% End of search all the combination, then find the best path
[OptimalCost,Index] = min(CurFCost);
BestPath = CurTransM(Index,:);

fprintf('\nProcessing Done!');
fprintf('\n%s \n',repmat('*',1,100'));
% Print the UC result
PrintResult(G,Load,States(:,BestPath));
end