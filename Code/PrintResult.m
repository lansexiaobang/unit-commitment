function OptimalCost = PrintResult(G,Load,FullStates)

NG = length(G.Pmin);            % # of generations
Nh = length(Load);              % # of load hour
TotalCost = zeros(Nh,1);
CurState  = zeros(NG,Nh); 
% Print
fprintf('\n\t\tUNIT COMMITMENT DETAILS IN EACH HOUR.');
for HOUR = 1 : Nh
    CurState(:,HOUR) = FullStates(:,HOUR+1);
    % Check the state transition 
    % stateTrans = 1 means commited, =1 means decommited
    StateTrans = CurState(:,HOUR) - FullStates(:,HOUR);
    % The start cost is cosidered as cold start
    GenStartCost = (StateTrans > 0)'.* G.Fsc; 
    GMin = CurState(:,HOUR).* G.Pmin';
    GMax = CurState(:,HOUR).* G.Pmax';
    [Generation,Cost] = ED(G.Coef_a,G.Coef_b,G.Coef_c,G.Pmax,G.Pmin,Load(HOUR),CurState(:,HOUR));
    if HOUR == 1
        TotalCost(HOUR) = Cost + sum(GenStartCost);
    else
        TotalCost(HOUR) = Cost + sum(GenStartCost) + TotalCost(HOUR-1);
    end
    S = ['UNITS          '
         'ON/OFF         '
         'GENERATION     '
         'MIN MW         '
         'MAX MW         '];
    TEMP = [(1:NG).',CurState(:,HOUR),Generation,GMin,GMax];
    fprintf('\n\n\nHOUR: %2d             Load:%7.1f MW           TotalCost: $%6.1f',HOUR,Load(HOUR),TotalCost(HOUR));
    fprintf('\n%s \n',repmat('-',1,100'))
    fprintf([repmat('%15s ', 1, size(S,1)) '\n\n'], S');fprintf('\n');
    fprintf(['%3d %15d ',repmat('%15.1f', 1, size(TEMP,2)-2) '\n'], TEMP.');
    fprintf('%s \n',repmat('-',1,100'));
    fprintf('TOTAL: %12d  %14.1f %14.1f %14.1f %14.1f %14.1f\n',sum(CurState(:,HOUR)),sum(Generation), sum(GMin), sum(GMax));
end
OptimalCost = TotalCost(end);
end