%% Approximate solution
function Vert_BRforall = BRforall(MDP,ZZ2,A,alpha1,Num_sample)
% alpha 1: acceptance distribution sat(A)
% alpha 2: acceptance distribution sat(B)

n = MDP.n;
m = MDP.m;
T = MDP.T;
Num_vert=size(ZZ2,1);
T_determin_num=MDP.T_determin_num;
T_determin=MDP.T_determin;
for i=1:Num_sample-n
    Sample(:,i)=3*rand(n,1)-1.5;
    Sample(end,i)=1-sum(Sample(1:end-1,i));
end
Sample=[Sample eye(n)];


yalmip('clear')
z1=sdpvar(n,1);
z2=sdpvar(n,1);
alpha=sdpvar(Num_vert,1);
Chosen_sample=sdpvar(n,1);
cns=[];

cns=[cns, ones(1,n)*z1==1];
cns=[cns, z1>=zeros(n,1)];
cns=[cns, alpha>=zeros(Num_vert,1)];
cns=[cns, ones(1,Num_vert)*alpha==1];
cns=[cns, z2==ZZ2'*alpha];
cns=[cns, sum(z1(A))>=alpha1];
for j=1:MDP.T_determin_num
         cns=[cns, T_determin{j}'*z1==z2]; 
end
obj=norm(Chosen_sample-z1); %norm(Sample(:,kkk)-z1,inf); % (Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1); %
ops = sdpsettings('solver','mosek','verbose',0);
BRreachforall = optimizer(cns,obj,ops,Chosen_sample,z1);


z11=zeros(n,Num_sample);
parfor k=1:Num_sample
    z11(:,k)=BRreachforall(Sample(:,k));
end
zz1=z11';

zz1(find(zz1<= 1.0000e-8))=0;
for kkk=1:size(zz1,1)
    zz1(kkk,:)=zz1(kkk,:)/sum(zz1(kkk,:));
end
Vert_BRforall=zz1;
end
