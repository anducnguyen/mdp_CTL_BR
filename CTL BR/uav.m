%% UAV
clear
clc
close all
%% MDP model

%A 5-by-5 grid world bounded by borders,
% with 4 possible actions (North = 1, South = 2, East = 3, West = 4, stay = 5).
numx=5;
numy=5;

%% number of state
n=dot(numx,numy);

%% number of action
m=5;

%% transition matrix
%%T(i,j,k)   transition from state i to state j under action k
% action up :1
% for i = 1:1:length(n)
% T(i,i+5,1)
% end
T(3,3,1)=1;
T(4,4,1)=1;

% action down :3
T(2,1,2)=0.7;
T(2,2,2)=0.3;

% action left: 4
T(2,3,3)=0.5;
T(2,4,3)=0.5;

% action right: 2
T(2,3,3)=0.5;
T(2,4,3)=0.5;

% action stay: 5


%% define adminisble control action for each state
% state 1
U_admin{1}=[1 2 5];

% state 2-4
for i = 2:1:4
U_admin{i}=[1 2 4 5];
end

% state 5
U_admin{5}=[1 4 5];

% state 6-11-16
for i = 6:5:16
U_admin{i}=[1 2 5];
end
% state 7-9,12-14,17-19
for i = 7:1:9
U_admin{i}=[1 2 3 4 5];
end
for i = 12:1:14
U_admin{i}=[1 2 3 4 5];
end
for i = 17:1:19
U_admin{i}=[1 2 3 4 5];
end

% state 10-15-20
for i = 10:5:20
U_admin{i}=[1 4 5];
end

% state 21
U_admin{21}=[2 3 5];

% state 22-24
for i = 22:1:24
U_admin{i}=[2 3 5];
end

% state 25
U_admin{25}=[3 4 5];

%% define deterministic policies
combin_control=combvec(U_admin{:});
for i=1:size(combin_control,2)
    T_determin{i}=[];
    for j=1:n
        T_determin{i}=[T_determin{i};T(j,:,combin_control(j,i))];
    end
end


%Define Sat(A U B)
%Define Sat(not_obsacle U goal points)
A = [7 19 22];
states = 1:25;
notA = setdiff(states,A);
B = [8 9 17 20 23 3 4];


%% MDP model
% A 4 state MDP,
% 3 actions.
MDP.n=n;
MDP.m=m;
MDP.T=T;
MDP.T_determin_num=size(combin_control,2);
MDP.T_determin=T_determin;


%% Approximate solution for existential cae
BR_Sample_num=10;
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
cns=[cns, sum(z1(A))>=0.9];
cns=[cns, sum(z2(B))>=0.9];
for i=1:n
    cns=[cns, ones(1,n)*(reshape(T(:,i,:),[n,m]).*Z1)*ones(m,1)==z2(i)];
end
obj=norm(Chosen_sample-z1); %norm(Sample(:,kkk)-z1,inf); % (Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1); %
ops = sdpsettings('solver','mosek','verbose',0);
BRexist_init = optimizer(cns,obj,ops,Chosen_sample,z1);



tic
% initialization
for i=1:BR_Sample_num-n
    Sample(:,i)=3*rand(n,1)-1.5;
    Sample(end,i)=1-sum(Sample(1:end-1,i));
end
Sample=[Sample eye(n)];


z11=zeros(n,BR_Sample_num);
parfor k=1:BR_Sample_num
    z11(:,k)=BRexist_init(Sample(:,k));
end
zz1=z11';

zz1(find(zz1<= 1.0000e-8))=0;
for kkk=1:size(zz1,1)
    zz1(kkk,:)=zz1(kkk,:)/sum(zz1(kkk,:));
end
Vert_BRexist{1}=zz1;

i=1;
flag=1;
while(i<=Nmax && flag)
    item=find_convexhull(Vert_BRexist{i},pi_ini);
    if(abs(item-1)<=0.01)
        flag=0;
    else
        Vert_BRexist{i+1}=BRexist(MDP,Vert_BRexist{i},A,0.9,BR_Sample_num);
        i=i+1;
    end
end

%% Approximate solution for universal cae
BR_Sample_num=10;
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
Chosen_sample=sdpvar(n,1);
cns=[];
cns=[cns, ones(1,n)*z1==1];
cns=[cns, z1>=zeros(n,1)];
cns=[cns, sum(z1(A))>=0.9];
cns=[cns, sum(z2(B))>=0.9];
for j=1:MDP.T_determin_num
        cns=[cns, T_determin{j}'*z1==z2]; %new state dist update
end
obj=norm(Chosen_sample-z1); %norm(Sample(:,kkk)-z1,inf); % (Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1); %
ops = sdpsettings('solver','mosek','verbose',0);
BRforall_init = optimizer(cns,obj,ops,Chosen_sample,z1);



tic
% initialization
for i=1:BR_Sample_num-n
    Sample(:,i)=3*rand(n,1)-1.5;
    Sample(end,i)=1-sum(Sample(1:end-1,i));
end
Sample=[Sample eye(n)];


z11=zeros(n,BR_Sample_num);
parfor k=1:BR_Sample_num
    z11(:,k)=BRforall_init(Sample(:,k));
end
zz1=z11';

zz1(find(zz1<= 1.0000e-8))=0;
for kkk=1:size(zz1,1)
    zz1(kkk,:)=zz1(kkk,:)/sum(zz1(kkk,:));
end
Vert_BRforall{1}=zz1;

i=1;
flag=1;
while(i<=Nmax && flag)
    item=find_convexhull(Vert_BRforall{i},pi_ini);
    if(abs(item-1)<=0.01)
        flag=0;
    else
        Vert_BRforall{i+1}=BRforall(MDP,Vert_BRforall{i},A,0.9,BR_Sample_num);
        i=i+1;
    end
end