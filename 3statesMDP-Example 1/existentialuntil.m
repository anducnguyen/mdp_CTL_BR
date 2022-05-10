function BRexuntil=existentialuntil(MDP,Aset,Bset,Num_sample)
%% Approximate solution for existential cae

n = MDP.n;
m = MDP.m;
T = MDP.T;

yalmip('clear')
z1=sdpvar(n,1);
z2=sdpvar(n,1);
Z1=sdpvar(n,m);
Chosen_sample=sdpvar(n,1);
cns=[];
cns=[cns, ones(1,n)*Z1*ones(m,1)==1];
cns=[cns, Z1>=zeros(n,m)];
cns=[cns, Z1*ones(m,1)==z1];
cns=[cns, Aset.A*z1<=Aset.b];
cns=[cns, Bset.A*z2<=Bset.b];
for i=1:n
    cns=[cns, ones(1,n)*(reshape(T(:,i,:),[n,m]).*Z1)*ones(m,1)==z2(i)];
end
obj=norm(Chosen_sample-z1); %norm(Sample(:,kkk)-z1,inf); % (Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1); %
ops = sdpsettings('solver','mosek','verbose',0);
BRexist_init = optimizer(cns,obj,ops,Chosen_sample,z1);



tic
% initialization
for i=1:Num_sample-n
    Sample(:,i)=3*rand(n,1)-1.5;
    Sample(end,i)=1-sum(Sample(1:end-1,i));
end
Sample=[Sample eye(n)];


z11=[];
parfor k=1:Num_sample
    [item,errorcode] =BRexist_init(Sample(:,k));
    if ~errorcode
        z11=[z11 item];
    end
end
if isempty(z11)
    BRexnext=0;
else
    zz1=z11';
    zz1(find(zz1<= 1.0000e-8))=0;
    for kkk=1:size(zz1,1)
        zz1(kkk,:)=zz1(kkk,:)/sum(zz1(kkk,:));
    end
    BRexuntil{1}=zz1;
end


Nmax=5;
i=1;
flag=1;
for i=1:Nmax
    BRexuntil{i+1}=BRexist(MDP,BRexuntil{i},Aset,Num_sample);
end

end

