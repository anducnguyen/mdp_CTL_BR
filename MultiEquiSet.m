function E=MultiEquiSet(S,N)
n=S.n;
m=S.m;
T=S.T;
cns=[];
z = sdpvar(n+n*m*N,1);
for k=1:N
Z{k}=reshape(z(n+n*m*(k-1)+1:n+n*m*k),[n,m]);
cns=[cns, ones(1,n)*Z{k}*ones(m,1)==1];
cns=[cns, Z{k}>=0];
end
cns=[cns, z(1:n)==Z{1}*ones(m,1)];
cns=[cns, z(1:n)==Z{N}*ones(m,1)];
for k=1:N-1
    for i=1:n
        cns=[cns, Z{k+1}(i,:)*ones(m,1)==ones(1,n)*(reshape(T(:,i,:),[n,m]).*Z{k})*ones(m,1)];
    end
end

Ee=Polyhedron(cns);
E=uniquetol(Ee.V(:,1:3),'ByRows',true);  % unique(Ee.V(:,1:3),'rows');
%K = convhull(E(:,1),E(:,2),E(:,3));
E=Polyhedron('V', E);
% E=Ee.projection(1:n);
% [E,sol]= E.minHRep();
end