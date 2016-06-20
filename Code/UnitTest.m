function UnitTest(varargin)

if varargin{1} == 1             % Unit test for priority list states
    states = varargin{2};
    GMax = varargin{3};
    GMin = varargin{4};
    printStates(states,GMax,GMin);
    
elseif varargin{1} == 2          % Unit test for enumerate states
    states = varargin{2};
    GMax = varargin{3};
    GMin = varargin{4};
    printStates(states,GMax,GMin);
    
elseif varargin{1} == 3         % Unit test for feasible states search
    states = varargin{2};
    GMax = varargin{3};
    GMin = varargin{4};
    printStates(states,GMax,GMin);
    
elseif varargin{1} == 4
    disp('PSO');
end

end


function printStates(states,GMax,GMin)
NG = size(states,1);
fprintf('   State No.      MW min        MW max                     Units\n');
fprintf('%s',repmat(' ',1,23));
fprintf(['               ',repmat('    %5d ', 1, NG)],1:NG);
fprintf('\n %s \n',repmat('-',1,80'));
for i=1:size(states,2)
    fprintf('      %2d       %8.1f      %8.1f ',i,GMax(i),GMin(i));
    fprintf([repmat('       %2d ', 1, size(states,1)) '\n'], states(:,i));
end
fprintf('%s \n',repmat('-',1,80'));
end

