function zz1=Approx_Control(S,ZZ2,Num_sample,Target)
n=S.n;
m=S.m;
T=S.T;
Num_vert=size(ZZ2,1);
%Num_sample=10;
for i=1:Num_sample
    Sample(:,i)=3*rand(n,1)-1.5;
    Sample(end,i)=1-sum(Sample(1:end-1,i));
end
zz1=[];
for kkk=1:Num_sample
yalmip('clear')
z = sdpvar(n+n+n*m+Num_vert,1);
z1=z(1:n);
z2=z(n+1:n+n);
Z1=reshape(z(n+n+1:n+n+n*m),[n,m]);
alpha=z(n+n+n*m+1:end);

cns=[];
cns=[cns, ones(1,n)*Z1*ones(m,1)==1];
cns=[cns, z1(:)>=zeros(n,1)];
cns=[cns, ones(1,n)*z1(:,:)==1];
cns=[cns, Z1*ones(m,1)==z1];
cns=[cns, alpha>=zeros(Num_vert,1)];
cns=[cns, ones(1,Num_vert)*alpha==1];
cns=[cns, z2==ZZ2'*alpha];
for i=1:n
    cns=[cns, Z1(i,:)>=zeros(1,m)];
   cns=[cns, ones(1,n)*(reshape(T(:,i,:),[n,m]).*Z1)*ones(m,1)==z2(i)];
end

%obj=(Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1);
%obj=(Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1); %norm(Sample(:,kkk)-z1,inf); %  (Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1); %
 rad=rand(n,1);
      rad(Target)=100;
      Q=diag(rad);
    obj=z1'*Q*z1;
%ops =   sdpsettings('solver','sedumi','sedumi.eps',1e-12,'sedumi.maxiter',200,'sedumi.numtol',1e-12);
 ops = sdpsettings('solver','quadprog');
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

for kkk=1:n
    yalmip('clear')
z = sdpvar(n+n+n*m+Num_vert,1);
z1=z(1:n);
z2=z(n+1:n+n);
Z1=reshape(z(n+n+1:n+n+n*m),[n,m]);
alpha=z(n+n+n*m+1:end);
cns=[];
cns=[cns, ones(1,n)*Z1*ones(m,1)==1];
cns=[cns, z1(:)>=zeros(n,1)];
cns=[cns, ones(1,n)*z1(:,:)==1];
cns=[cns, Z1*ones(m,1)==z1];
cns=[cns, alpha>=zeros(Num_vert,1)];
cns=[cns, ones(1,Num_vert)*alpha==1];
cns=[cns, z2==ZZ2'*alpha];
for i=1:n
    cns=[cns, Z1(i,:)>=zeros(1,m)];
   cns=[cns, ones(1,n)*(reshape(T(:,i,:),[n,m]).*Z1)*ones(m,1)==z2(i)];
end
 c=zeros(n,1);
 c(kkk)=-1;
 obj= c'*z1;
%ops =   sdpsettings('solver','sedumi','sedumi.eps',1e-12,'sedumi.maxiter',200,'sedumi.numtol',1e-12);
ops = sdpsettings('solver','quadprog');
 BRreach=optimize(cns,obj,ops);
  z1=value(z1);
% Z1=value(Z1);
  % flag=check_feasibility(S,Z1,z1,z2);
if   BRreach.problem<=0.01  %abs(flag-1)<=0.001
zz1=[zz1;z1'];
end
end

for kkk=1:n
    yalmip('clear')
z = sdpvar(n+n+n*m+Num_vert,1);
z1=z(1:n);
z2=z(n+1:n+n);
Z1=reshape(z(n+n+1:n+n+n*m),[n,m]);
alpha=z(n+n+n*m+1:end);
cns=[];
cns=[cns, ones(1,n)*Z1*ones(m,1)==1];
cns=[cns, z1(:)>=zeros(n,1)];
cns=[cns, ones(1,n)*z1(:,:)==1];
cns=[cns, Z1*ones(m,1)==z1];
cns=[cns, alpha>=zeros(Num_vert,1)];
cns=[cns, ones(1,Num_vert)*alpha==1];
cns=[cns, z2==ZZ2'*alpha];
for i=1:n
    cns=[cns, Z1(i,:)>=zeros(1,m)];
   cns=[cns, ones(1,n)*(reshape(T(:,i,:),[n,m]).*Z1)*ones(m,1)==z2(i)];
end
 c=zeros(n,1);
 c(kkk)=1;
 obj= c'*z1;
%ops =   sdpsettings('solver','sedumi','sedumi.eps',1e-12,'sedumi.maxiter',200,'sedumi.numtol',1e-12);
 ops = sdpsettings('solver','quadprog');
 BRreach=optimize(cns,obj,ops);
  z1=value(z1);
% Z1=value(Z1);
  % flag=check_feasibility(S,Z1,z1,z2);
if   BRreach.problem<=0.01  %abs(flag-1)<=0.001
zz1=[zz1;z1'];
end
end
end

