function [P, Cost] = ED(a,b,c,GMax,GMin,Load,state)
global DEBUG;
warning off %#ok<WNOFF>

state = logical(state);           % tranform to logical expression 
% F(P) = a+b*P+c*P^2
NG = length(GMin);
P = zeros(NG,1);

lb = GMin(state);
ub = GMax(state);
H = 2*diag(c(state));
f = b(state);
Aeq = ones(1,NG);
Aeq = Aeq(state');
beq = Load;
options = optimset('Display','Off');
[Gen,Cost,exitflag] = quadprog(H,f,[],[],Aeq,beq,lb,ub,[],options);
if exitflag == 1
    Cost = Cost + a*state;
    P(state) = Gen;
else
    Cost = Inf;
    if DEBUG
        msg = ['No feasible dispatch for current combination: ',num2str(state'), '!'];
        msgbox(msg,'WARNING!','warn');
    end
    return;
end

end