function flag=check_feasibility(S,Z1,z1,z2)
%% flag=1, z2 is reachable from z1 with occupation measure Z1; otherwise flag=0
n=S.n;
m=S.m;
T=S.T;
flag=1;
tol=1e-5;
for i=1:n
   err(i)=ones(1,n)*(reshape(T(:,i,:),[n,m]).*Z1)*ones(m,1)-z2(i);
end
% abs(ones(1,n)*Z1*ones(m,1)-1)
% min(min(Z1))
% max(abs(Z1*ones(m,1)-z1))
% max(abs(err))
if  abs(ones(1,n)*Z1*ones(m,1)-1)>=tol | min(min(Z1))<=-tol | max(abs(Z1*ones(m,1)-z1))>=tol |   max(abs(err))>=tol
    flag=0;
end
end