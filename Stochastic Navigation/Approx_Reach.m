function zz2=Approx_Reach(S,z1,Num_sample)
n=S.n;
m=S.m;
T=S.T;
%Num_sample=10;
for i=1:Num_sample
    %Sample(:,i)=2*rand(n,1);
    Sample(:,i)=2*rand(n,1)-1;
    Sample(end,i)=1-sum(Sample(1:end-1,i));
end
zz2=[];
for kkk=1:Num_sample
    yalmip('clear')
    z = sdpvar(n+n*m,1); %? -> n means initial distribution + number of action * induced state
   z2=z(1:n);
   Z1=reshape(z(n+1:end),[n,m]);
    cns=[];
    cns=[cns, ones(1,n)*Z1*ones(m,1)==1]; %sum of occupation =1
    cns=[cns, z2(:)>=zeros(n,1)]; % state dist >0
    cns=[cns, ones(1,n)*z2==1]; %sum diestribution =1
    cns=[cns, Z1*ones(m,1)==z1]; %occupation measure (Q*1) in Pi
    for i=1:n
        cns=[cns, Z1(i,:)>=zeros(1,m)]; %occupation >0
        cns=[cns, ones(1,n)*(reshape(T(:,i,:),[n,m]).*Z1)*ones(m,1)==z2(i)]; %new state dist update
    end
    obj= (Sample(:,kkk)-z2)'*(Sample(:,kkk)-z2); %norm(Sample(:,kkk)-z2,inf); %norm(Sample(:,kkk)-z2,2);   %  (Sample(:,kkk)-z2)'*(Sample(:,kkk)-z2);
    %  obj=Sample(:,kkk)'*z2;
    ops =   sdpsettings('solver','sedumi','sedumi.eps',1e-12,'sedumi.maxiter',500,'sedumi.numtol',1e-12);
  %  ops = sdpsettings('solver','quadprog');
    FReach=optimize(cns,obj,ops);
    %% feasibility check
    z2=value(z2);
   % Z1=value(Z1);
    % flag=check_feasibility(S,Z1,z1,z2);
%    if   FReach.problem<=0.01  %(abs(flag-1)<=0.001)
        zz2=[zz2;z2'];
  %  end
end
end