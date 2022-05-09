function E=EquiSet(S)
n=S.n;
m=S.m;
T=S.T;
yalmip('clear')
z = sdpvar(n+n*m,1);
Z=reshape(z(n+1:end),[n,m]);
cns=[];
cns=[cns, Z>=zeros(n,m)];
cns=[cns, ones(1,n)*Z*ones(m,1)==1];
cns=[cns, z(1:n,1)==Z*ones(m,1)];
for i=1:n
   cns=[cns, ones(1,n)*(reshape(T(:,i,:),[n,m]).*Z)*ones(m,1)==z(i)];
end

% Ee=Polyhedron(cns);
%  E=Ee.projection(1:n);
%  [E,sol]= E.minHRep();

 Ee=Polyhedron(cns);
E=Polyhedron(Ee.V(:,1:n));
end