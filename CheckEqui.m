function Q=CheckEqui(S,x)
n=S.n;
m=S.m;
T=S.T;
yalmip('clear')
z = sdpvar(n*m,1);
Z=reshape(z,[n,m]);
cns=[];
cns=[cns, sum(sum(Z))==1];
cns=[cns, x-sum(Z,2)==zeros(n,1)];

for i=1:n
    temp=reshape(T(:,i,:),[n,m]);
   cns=[cns, sum(Z(i,:))-sum(sum(temp.*Z))==0];
   for j=1:m
       cns=[cns, Z(i,j)>=0];
   end
end
ops = sdpsettings('solver', 'ipopt');
diagnostics = optimize(cns,[ ],ops);
if diagnostics.problem == 0
 Q=reshape(value(z),[n,m]);
else
 disp('Solver thinks it is infeasible')
 %Q=zeros(n,m);
 Q=reshape(value(z),[n,m]);
end
% Ee=Polyhedron(cns);
% E=Ee.projection(1:n);
% [E,sol]= E.minHRep();
end