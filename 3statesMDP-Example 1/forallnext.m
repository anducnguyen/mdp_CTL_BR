function BRforallnext=forallnext(MDP,Bset,Num_sample)
%% Approximate solution for existential cae

n = MDP.n;
m = MDP.m;
T = MDP.T;
T_determin_num=MDP.T_determin_num;
T_determin=MDP.T_determin;

yalmip('clear')
z1=sdpvar(n,1);
z2=sdpvar(n,1);
Chosen_sample=sdpvar(n,1);
cns=[];
cns=[cns, ones(1,n)*z1==1];
cns=[cns, z1>=zeros(n,1)];
for j=1:MDP.T_determin_num
    cns=[cns, Bset.A*T_determin{j}'*z1<=Bset.b];
end
obj=norm(Chosen_sample-z1); %norm(Sample(:,kkk)-z1,inf); % (Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1); %
ops = sdpsettings('solver','sedumi','verbose',0);
BRforall_init = optimizer(cns,obj,ops,Chosen_sample,z1);


% initialization
for i=1:Num_sample-n
    Sample(:,i)=3*rand(n,1)-1.5;
    Sample(end,i)=1-sum(Sample(1:end-1,i));
end
Sample=[Sample eye(n)];


z11=[];
parfor k=1:Num_sample
    [item,errorcode] =BRforall_init(Sample(:,k));
    if ~errorcode
        z11=[z11 item];
    end
end
if isempty(z11)
    BRforallnext=0;
else
    zz1=z11';
    zz1(find(zz1<= 1.0000e-8))=0;
    for kkk=1:size(zz1,1)
        zz1(kkk,:)=zz1(kkk,:)/sum(zz1(kkk,:));
    end
    BRforallnext=zz1;
end
end

