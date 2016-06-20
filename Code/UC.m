function UC()
%% Unit Commitment
tic
global FULLSTATES;
global DEBUG;
format long;

% Unit Test for each function, 1 means printing each function result
DEBUG = 0;

% Obtain the generation data and load data
[genData,loadData] = GetData();

% Choose an algorithm to solve
Algorithm = 2;

% Algorithm used to solve the UC problem
% 1: Priority List(PL)
% 2: Dynamic Programming(DP) + Full states
% 3: Dynamic Programming(DP) + Priorty lists
% 4: Particle Swarm Optimization(PSO)

switch Algorithm
    case 1
        fprintf('\n\t\tSolving Using Priority List Method.');
        fprintf('\n%s \n',repmat('*',1,100'));
        % No startup cost considered when scheduling
        OptimalCost = PL(genData,loadData);
    case 2
        % Startup cost considered
        FULLSTATES = 1;
        fprintf('\n\t\tSolving Using Dynamic Programming.');
        fprintf('\n%s \n',repmat('*',1,100'));
        OptimalCost = DP(genData,loadData);
    case 3
        FULLSTATES = 0;
        fprintf('\n\t\tSolving Using Dynamic Programming + Priority List Method.');
        fprintf('\n%s \n',repmat('*',1,100'));
        OptimalCost = DP(genData,loadData);
        % Reserve requirement added
    case 4
        fprintf('\n\t\tSolving Using Particle Swarm Optimization.');
        fprintf('\n%s \n',repmat('*',1,100'));
        OptimalCost = PSO(genData,loadData);
    otherwise
        msgbox('Please specify a method!','WARNING!','warn');
end    

t=toc;
fprintf('\n\n%s \n',repmat('*',1,100'));
fprintf('\n The Optimal Total Cost is $%10.4f.',OptimalCost);
fprintf('\n Elapsed time: %10.4f sec.\n\n',t)
end