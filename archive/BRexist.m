%% Approximate solution
function Vert_BRexist = BRexist(MDP,pi_init,A,alpha1,B,alpha2,Num_sample)
% alpha 1: acceptance distribution sat(A)
% alpha 2: acceptance distribution sat(B)

n = MDP.n;
m = MDP.m;
T = MDP.T;
BR_Sample_num= Num_sample;
Nmax=3; %max iteration
pi_ini = pi_init;
for i=1:BR_Sample_num-n
    Sample(:,i)=3*rand(n,1)-1.5;
    Sample(end,i)=1-sum(Sample(1:end-1,i));
end
Sample=[Sample eye(n)];


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
aa = [];
bb = [];
for i = 1:1:n
    for j=1:1:length(A)
        if i == A(j)
        aa = [aa z(i)];
        sumA = sum(aa);
        cns=[cns, sumA>=alpha1];
        end
    end
end

for i = 1:1:n
    for j=1:1:length(B)
        if i == B(j)
        bb = [bb z(i)];
        sumB = sum(bb);
        cns=[cns, sumB>=alpha2];
        end
    end
end

for i=1:n
    cns=[cns, ones(1,n)*(reshape(T(:,i,:),[n,m]).*Z1)*ones(m,1)==z2(i)];
end
obj=norm(Chosen_sample-z1); %norm(Sample(:,kkk)-z1,inf); % (Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1); %
ops = sdpsettings('solver','mosek','verbose',0);
BRreachCTL_init = optimizer(cns,obj,ops,Chosen_sample,z1);


% parfor kkk=1:BR_Sample_num
% zz(:,kkk)=BRreach(Sample(:,kkk));
% end
% zz1=zz';
% zz1(find(zz1<= 1.0000e-8))=0;
% parfor kkk=1:size(zz1,1)
% zz1(kkk,:)=zz1(kkk,:)/sum(zz1(kkk,:));
% end
%

tic
% initialization
for i=1:BR_Sample_num-n
    Sample(:,i)=3*rand(n,1)-1.5;
    Sample(end,i)=1-sum(Sample(1:end-1,i));
end
Sample=[Sample eye(n)];


z11=zeros(n,BR_Sample_num);
parfor k=1:BR_Sample_num
    z11(:,k)=BRreachCTL_init(Sample(:,k));
    % zz1=[zz1;z1'];
end
zz1=z11';

zz1(find(zz1<= 1.0000e-8))=0;
for kkk=1:size(zz1,1)
    zz1(kkk,:)=zz1(kkk,:)/sum(zz1(kkk,:));
end
Vert_BR{1}=zz1;
%RA_BRtotal=Vert_BR{1};


% 
% i=1;
% flag=1;
% while(i<=Nmax && flag)
%     item=find_convexhull(Vert_BR{i},pi_ini);
% 
%     if(abs(item-1)<=0.01)
%         flag=0;
%     else
%         Vert_BR{i+1}=Approx_CTL(MDP,Vert_BR{i},BR_Sample_num);
%         i=i+1;
%     end
%     % RA_BRtotal=[RA_BRtotal; Vert_BR{i+1}];
%     % waitbar(i/Nmax,figbar,'Domain of Acctraction')
% end
% % Comtime_SW(nnn)=toc;
% % Vert_SW{nnn}=Vert_BR;
% % nnn

