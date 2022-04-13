function flag=find_convexhull(Z,z)
Z=Z';
[N,M]=size(Z);
    yalmip('clear')
    cns=[];
    alpha = sdpvar(M,1);
    cns=[cns, alpha>=zeros(M,1)];
    cns=[cns, alpha'*ones(M,1)==1];
    cns=[cns, Z*alpha==z];
    %ops =   sdpsettings('solver','sedumi','sedumi.eps',1e-12,'sedumi.maxiter',200,'sedumi.numtol',1e-12);
    ops = sdpsettings('solver','mosek','verbose',0);
    BRreach=optimize(cns,'',ops);
    if   BRreach.problem<=0.01  %abs(flag-1)<=0.001
        flag=1;
    else
        flag=0;
    end
end