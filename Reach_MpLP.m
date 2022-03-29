function R=Reach_MpLP(S,V)
n=S.n;
m=S.m;
T=S.T;

z = sdpvar(n+n*m+n+n*m,1);
z1=z(1:n);
z2=z(n+n*m+1:n+n*m+n);
Z1=reshape(z(n+1:n+n*m),[n,m]);
Z2=reshape(z(n+n+n*m+1:end),[n,m]);

cns=[];
cns=[cns, ones(1,n)*Z1*ones(m,1)==1];
cns=[cns, Z1>=0];
cns=[cns, z1==Z1*ones(m,1)];
cns=[cns, ones(1,n)*Z2*ones(m,1)==1];
cns=[cns, Z2>=0];
cns=[cns, z2==Z2*ones(m,1)];

for i=1:n
   cns=[cns, Z1(i,:)*ones(m,1)==ones(1,n)*(reshape(T(:,i,:),[n,m]).*Z2)*ones(m,1)];
end

for i=1:n
   cns=[cns, Z1(i,:)*ones(m,1)==ones(1,n)*(reshape(T(:,i,:),[n,m]).*Z2)*ones(m,1)];
end

cns=[cns, V.A*z2<=V.b];
cns=[cns, V.Ae*z2==V.be];

Re=Polyhedron(cns);
R=Re.projection(1:n);
[R,sol]= R.minHRep();
end