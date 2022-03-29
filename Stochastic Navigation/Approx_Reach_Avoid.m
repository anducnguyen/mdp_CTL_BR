function zz1=Approx_Reach_Avoid(S,ZZ2,Num_sample,Obs)
n=S.n;
m=S.m;
T=S.T;
Num_vert=size(ZZ2,1);
%Num_sample=10;
for i=1:Num_sample-n
    Sample(:,i)=3*rand(n,1)-1.5;
    Sample(end,i)=1-sum(Sample(1:end-1,i));
end
Sample=[Sample eye(n)];


%% construct optimization problem
yalmip('clear')
z1=sdpvar(n,1);
z2=sdpvar(n,1);
Z1=sdpvar(n,m);
alpha=sdpvar(Num_vert,1);
Chosen_sample=sdpvar(n,1);
cns=[];
cns=[cns, ones(1,n)*Z1*ones(m,1)==1];
cns=[cns, Z1>=zeros(n,m)];
cns=[cns, Z1*ones(m,1)==z1];
cns=[cns, alpha>=zeros(Num_vert,1)];
cns=[cns, ones(1,Num_vert)*alpha==1];
cns=[cns, z2==ZZ2'*alpha];
cns=[cns, sum(z1(Obs))==0];
for i=1:n
    cns=[cns, ones(1,n)*(reshape(T(:,i,:),[n,m]).*Z1)*ones(m,1)==z2(i)];
end

obj=norm(Chosen_sample-z1); %norm(Sample(:,kkk)-z1,inf); %  (Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1); %
ops = sdpsettings('solver','mosek');
BRreach = optimizer(cns,obj,ops,Chosen_sample,z1);


parfor kkk=1:Num_sample
     zz(:,kkk)=BRreach(Sample(:,kkk));
end    
zz1=zz';
zz1(find(zz1<= 1.0000e-8))=0;
parfor kkk=1:size(zz1,1)
  zz1(kkk,:)=zz1(kkk,:)/sum(zz1(kkk,:));
end
end



