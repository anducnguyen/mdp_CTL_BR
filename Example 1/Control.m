function C=Control(S,V)
n=S.n;
m=S.m;
T=S.T;

z = sdpvar(n+n*m+n,1);
z1=z(1:n);
z2=z(n+n*m+1:n+n*m+n);
Z1=reshape(z(n+1:n+n*m),[n,m]);

cns=[];
cns=[cns, ones(1,n)*Z1*ones(m,1)==1];
cns=[cns, Z1(:,:)>=zeros(n,m)];
cns=[cns, Z1*ones(m,1)==z1];

for i=1:n
   cns=[cns, ones(1,n)*(reshape(T(:,i,:),[n,m]).*Z1)*ones(m,1)==z2(i)];
end

cns=[cns, V.A*z2<=V.b];
cns=[cns,V.Ae*z2==V.be];

Ce=Polyhedron(cns);
C=Ce.projection(1:n);
[C,sol]= C.minHRep();
end