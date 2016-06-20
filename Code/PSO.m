function [OptimalCost,Pg] = PSO(G,Load)

% Setting the parameter for PSO
C1      = 2.02;         % Acceleration Coefficients
C2      = 2.05;
Xmin    = 0.0;          % Partile position limit
Xmax    = 1.0;
Wmin    = 0.2;         % The inertia weight limit
Wmax    = 1.0;
MaxIter = 500;        % The maximum iteration times

% Solve the UC
NG = length(G.Pmin);    % # of generation
Nh = length(Load);      % # of load hour
X  = zeros(NG,Nh);      % The position of the particle(ON/OFF states)
V  = zeros(NG,Nh);      % Velocity of the i-th dimension      
Pg = zeros(NG,Nh);      % Global best record
D  = 2^NG;              % Dimension of the search space

% The fitness objective 
FITg = ones(MaxIter,1) * Inf;        % global best
FITp = ones(D,1) * Inf;              % personal best

% Define the swarm of the particle in the whole search space
S  = cell(2,D);                      % Current position
Pb = cell(1,D);                      % Personal best position   

% Initialize the particles and velocity
for k = 1 : D
    for i = 1 : NG
        for j = 1 : Nh
            X(i,j) = randi([Xmin,Xmax]);            % random initialize position  
            V(i,j) = Xmin + rand * (Xmax - Xmin);   % random initialize velocity
        end
    end
    Pb{k}  = X;
    S{1,k} = X;
    S{2,k} = V;
end

% PSO iteration to search the global optimal objective
for iter = 1 : MaxIter
    w = Wmax - (Wmax - Wmin)*iter/MaxIter;      % inertial weight approach
    for k = 1 : D
        X = S{1,k};
        V = S{2,k};
        for i = 1 : NG
            for j = 1 : Nh
                % Update the velocity
                V(i,j) = w*V(i,j) + C1*rand*(Pb{k}(i,j)-X(i,j)) + C2*rand*(Pg(i,j)-X(i,j));
                
                % Using sigmoid function as a threshold
                if(rand < sigmoid(V(i,j)))
                    X(i,j) = 1;
                else
                    X(i,j) = 0;
                end
            end
        end
        
        % Update the current particle
        S{1,k} = X;
        S{2,k} = V;
        
        % Calculate the fitness for current particle
        FIT = fitness(G,Load,X);
        
        % Update the personal best position vector
        if FIT < FITp(k)
            FITp(k) = FIT;
            Pb{k} = X;
        end
    end
    
    % Update the global best position vector
    [FITg(iter), index] = min(FITp);
    Pg = Pb{index}; 
end

if FITg(iter) == Inf
    OptimalCost = Inf;
    fprintf('Not Converge!');
    %msgbox('PSO does not converge!','WARNING','warn');
    return;
end

% Plot the iteration of the optimal cost
figure;
plot(FITg,'LineWidth',2);
xlabel('Iteration Times');
ylabel('Total Cost($)');
title('Particle Convergency of PSO');

% Determine the initial state
IniState = (G.IniState > 0)';
States = [IniState,Pg];

% Print the scheduling result 
PrintResult(G,Load,States);
OptimalCost = FITg(iter);

end