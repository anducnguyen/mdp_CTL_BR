function R=Reach(S,V)
n=S.n;
m=S.m;
T=S.T;

z = sdpvar(n+n*m,1);
z1=z(1:n);
Z2=reshape(z(n+1:end),[n,m]);

cns=[];
% cns=[cns, 1<=ones(1,n)*Z1*ones(m,1)<=1];
% cns=[cns, Z1>=0];
% cns=[cns, z1<=Z1*ones(m,1)<=z1];
cns=[cns, z1(:)>=zeros(n,1)];
cns=[cns, ones(1,n)*z1==1];
cns=[cns, ones(1,n)*Z2*ones(m,1)==1];
cns=[cns, Z2>=zeros(n,m)];

for i=1:n
   cns=[cns, ones(1,n)*(reshape(T(:,i,:),[n,m]).*Z2)*ones(m,1)==z1(i)];
end


cns=[cns, V.A*Z2*ones(m,1)<=V.b];
%cns=[cns, V.Ae*Z2*ones(m,1)==V.be];

Re=Polyhedron(cns);
%R=Polyhedron(Re.V(:,1:n)); 
 R=Re.projection(1:n);
 [R,sol]= R.minHRep();
end