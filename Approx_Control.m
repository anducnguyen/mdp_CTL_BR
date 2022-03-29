function zz1=Approx_Control(S,z2,Num_sample)
n=S.n;
m=S.m;
T=S.T;
%Num_sample=10;
for i=1:Num_sample
    Sample(:,i)=3*rand(n,1)-1.5;
    Sample(end,i)=1-sum(Sample(1:end-1,i));
end
zz1=[];
for kkk=1:Num_sample
yalmip('clear')
z = sdpvar(n+n*m,1);
z1=z(1:n);
Z1=reshape(z(n+1:end),[n,m]);
cns=[];
cns=[cns, ones(1,n)*Z1*ones(m,1)==1];
cns=[cns, z1(:,:)>=zeros(n,1)];
cns=[cns, ones(1,n)*z1(:,:)==1];
cns=[cns, Z1*ones(m,1)==z1];
for i=1:n
    cns=[cns, Z1(i,:)>=zeros(1,m)];
   cns=[cns, ones(1,n)*(reshape(T(:,i,:),[n,m]).*Z1)*ones(m,1)==z2(i)];
end
%obj=(Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1);
obj=(Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1); %norm(Sample(:,kkk)-z1,inf); %  (Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1); %
ops =   sdpsettings('solver','sedumi','verbose',0,'sedumi.eps',1e-12,'sedumi.maxiter',500,'sedumi.numtol',1e-12);
% ops = sdpsettings('solver','quadprog');
 BRreach=optimize(cns,obj,ops);
  z1=value(z1);
% Z1=value(Z1);
  % flag=check_feasibility(S,Z1,z1,z2);
if   BRreach.problem<=0.01  %abs(flag-1)<=0.001
zz1=[zz1;z1'];
end
% ops = sdpsettings('solver','qsopt','verbose',1,'debug',1);
% optimize(cns,(sign(rand(1,n)-0.5)-1)*z1,ops);
% z1=value(z1);
% z1=z1';

end
end

% 
% function z1=Approx_Control(S,z2)
% n=S.n;
% m=S.m;
% T=S.T;
% 
% yalmip('clear')
% Z1=sdpvar(n,m);
% z1=sdpvar(n,1);
% 
% cns=[];
% cns=[cns, 1<=ones(1,n)*Z1*ones(m,1)<=1];
% cns=[cns, Z1(:,:)>=0];
% cns=[cns, z1(:)>=0];
% cns=[cns, 1<=ones(1,n)*z1(:)<=1];
% for i=1:n
%    cns=[cns, z2(i)<=ones(1,n)*(reshape(T(:,i,:),[n,m]).*Z1)*ones(m,1)<=z2(i)];
% end
% 
% ops = sdpsettings('solver','sdpt3','verbose',1,'debug',1);
% optimize(cns,(sign(rand(1,n)-0.5)-1)*z1,ops);
% z1=value(z1);
% z1=z1';
% end