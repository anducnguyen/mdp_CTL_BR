%% BR for MDP
clear
close

%% number of state
n=4;

%% number of action
m=3;

%% transition matrix
%%T(i,j,k)   transition from state i to state j under action k
% action a
T(1,2,1)=1;
T(3,3,1)=1;
T(4,4,1)=1;

% action b
T(2,1,2)=0.7;
T(2,2,2)=0.3;

% action c
T(2,3,3)=0.5;
T(2,4,3)=0.5;

%% MDP model
% A 4 state MDP,
% 3 actions.
MDP.n=n;
MDP.m=m;
MDP.T=T;

% E = EquiSet(MDP);
%% Approximate solution

BR_Sample_num=100;
Nmax=3;
pi_ini = [1;0;0;0];
for i=1:BR_Sample_num-n
    Sample(:,i)=3*rand(n,1)-1.5;
    Sample(end,i)=1-sum(Sample(1:end-1,i));
end
Sample=[Sample eye(n)];

yalmip('clear')
z1=sdpvar(n,1);
z2=sdpvar(n,1);
Z1=sdpvar(n,m);
Chosen_sample=sdpvar(n,1);
cns=[];
cns=[cns, ones(1,n)*Z1*ones(m,1)==1];
cns=[cns, Z1>=zeros(n,m)];
cns=[cns, Z1*ones(m,1)==z1];
cns=[cns, sum(z2(2)+z2(4))>=0.9];
cns=[cns, sum(z1(1)+z1(2)+z1(3))>=0.9];
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



i=1;
flag=1;
while(i<=Nmax && flag)
    item=find_convexhull(Vert_BR{i},pi_ini);

    if(abs(item-1)<=0.01)
        flag=0;
    else
        Vert_BR{i+1}=Approx_CTL(MDP,Vert_BR{i},BR_Sample_num);
        i=i+1;
    end
    % RA_BRtotal=[RA_BRtotal; Vert_BR{i+1}];
    % waitbar(i/Nmax,figbar,'Domain of Acctraction')
end
% Comtime_SW(nnn)=toc;
% Vert_SW{nnn}=Vert_BR;
% nnn


%% Plot
sample_BR=Vert_BR{end};
figure
plot3(sample_BR(:,1),sample_BR(:,2),sample_BR(:,3),'k*')
hold on
%end

[k1,av1] = convhull(sample_BR(:,1),sample_BR(:,2),sample_BR(:,3));
trisurf(k1,sample_BR(:,1),sample_BR(:,2),sample_BR(:,3),'FaceColor','cyan')

xlabel('$\pi(1)$','FontSize',12,'interpreter','latex')
ylabel('$\pi(2)$','FontSize',12,'interpreter','latex')
zlabel('$\pi(3)$','FontSize',12,'interpreter','latex')
