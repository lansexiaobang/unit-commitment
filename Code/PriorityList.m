function [states, GMax, GMin] = PriorityList(G)
global DEBUG;

NG = length(G.Pmin);          % # of generation

% Generations are ranked based on their average fuel cost
% cheapest one comes first.
FAvgCost = G.Coef_a ./ G.Pmax + G.Coef_b + G.Coef_c .* G.Pmax; 
[~,index] = sort(FAvgCost);

% Generate the priority list, each column stands for a state
% the latter column concludes one more cheapest generator
states = triu(ones(NG));
states(index,:) = states(1:NG,:);
states = logical(states);           % tranform to logical expression 
GMax = cumsum(G.Pmax(index));
GMin = cumsum(G.Pmin(index));

if DEBUG
    % Unittest is performed to print out the result of this function
    UnitTest(1,states,GMax,GMin);
end

end
