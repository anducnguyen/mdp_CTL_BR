function [Y]=find_convexhull(X)
[m,n]=size(X);
Z=X;
idx=1;
for i=1:m
    yalmip('clear')
    cns=[];
    N=size(Z,1)-1;
    alpha = sdpvar(1,N);
    cns=[cns, alpha>=zeros(1,N)];
    cns=[cns, alpha*ones(N,1)==1];
    temp=Z;
    temp(idx,:)=[];
    cns=[cns, Z(idx,:)==alpha*temp];
    ops =   sdpsettings('solver','sedumi','sedumi.eps',1e-12,'sedumi.maxiter',200,'sedumi.numtol',1e-12);
    % ops = sdpsettings('solver','quadprog');
    BRreach=optimize(cns,alpha*alpha',ops);
    if   BRreach.problem<=0.01  %abs(flag-1)<=0.001
        Z=temp;
    else
        idx=idx+1;
    end
end
Y=Z;
end