%% BR for MDP

clear

close

%% number of state

n=4;

%% number of action

m=3;

%% transition matrix

%%T(i,j,k) transition from state i to state j under action k

% action a

T(1,2,1)=1;
T(3,3,1)=1;
T(4,1,1)=1;

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

%E = EquiSet(MDP);

%% Approximate solution

BR_Sample_num=15;
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

ops = sdpsettings('solver','mosek');

BRreach = optimizer(cns,obj,ops,Chosen_sample,z1);

parfor kkk=1:BR_Sample_num

zz(:,kkk)=BRreach(Sample(:,kkk));

end

zz1=zz';

zz1(find(zz1<= 1.0000e-8))=0;

parfor kkk=1:size(zz1,1)

zz1(kkk,:)=zz1(kkk,:)/sum(zz1(kkk,:));

end

%

% for i=1:BR_Sample_num

% yalmip('clear')

% z=sdpvar(MDP.n,1);

% cns=[];

% cns=[cns,E.A*z<=E.b];

% cns=[cns, z(:)>=zeros(MDP.n,1)];

% cns=[cns, ones(1,MDP.n)*z==1];

%

% ops = sdpsettings('solver','quadprog','verbose',0);

% optimize(cns,sign(rand-0.5)*rand(1,MDP.n)*z,ops);

% BR_sample(i,:)=value(z)';

% end

% figure

% Control_E=Control(MDP,E); -> minHRep, H-representation

% Control_E.plot('color', 'red')

% hold on

% sample_BR=[];

% for i=1:BR_Sample_num

% sample_BR=[sample_BR;Approx_Control(MDP, BR_sample(i,:)',BR_Sample_num)];

% end

% figure

% plot3(sample_BR(:,1),sample_BR(:,2),sample_BR(:,3),'k*')

% hold on

% %end

%

% [k1,av1] = convhull(sample_BR(:,1),sample_BR(:,2),sample_BR(:,3));

% trisurf(k1,sample_BR(:,1),sample_BR(:,2),sample_BR(:,3),'FaceColor','cyan')

%

% xlabel('$\pi(1)$','FontSize',12,'interpreter','latex')

% ylabel('$\pi(2)$','FontSize',12,'interpreter','latex')

% zlabel('$\pi(3)$','FontSize',12,'interpreter','latex')

%%