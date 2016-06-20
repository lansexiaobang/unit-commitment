function [states,GMax,GMin] = Enumerate(G)
global DEBUG;

NG = length(G.Pmin);          % # of generation

% Generate the full states list, each column stands for a state
states = dec2bin(1:2^NG-1);
% tranform to logical expression
states = logical(sscanf(states,'%1d',size(states))); 
GMax = states * G.Pmax';
GMin = states * G.Pmin';
states = states';

if DEBUG
    UnitTest(2,states,GMax,GMin);
end

end