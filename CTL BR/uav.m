%% UAV
clear
clc
close all
%% MDP model

%A 5-by-5 grid world bounded by borders,
% with 4 possible actions (North = 1, South = 2, East = 3, West = 4, stay = 5).
numx=4;
numy=4;

%% number of state
n=dot(numx,numy);

%% number of action
m=4;

%% transition matrix
%T(i,j,k)   transition from state i to state j under action k
% action up :1
% action down :3
% action left: 4
% action right: 2
T = transition_collision(n,m)

% 0 1 0
% 4 0 2
% 0 3 0

for iii=1:m
    for jjj1=1:m
        sumT(jjj1,iii)=sum(T(jjj1,:,iii));
    end
end
% 
% %state 1
% T(1,6,1)=1/3;
% T(1,2,2)=1/3;
% T(1,1,5)=1/3;
% 
% %state 5
% T(5,10,1)=1/3;
% T(5,4,4)=1/3;
% T(5,5,5)=1/3;
% 
% %state 7
% T(7,12,1)=1/5;
% T(7,8,2)=1/5;
% T(7,2,3)=1/5;
% T(7,6,4)=1/5;
% T(7,7,5)=1/5;
% 
% % state 2-4
% for i = 2:1:4
% T(i,i+5,1)=1/4;
% T(i,i+1,2)=1/4;
% T(i,i-1,4)=1/4;
% T(i,i,5)=1/4;
% end
% 
% % state 6-11-16
% for i = 6:5:16
% T(i,i+5,1)=1/4;
% T(i,i+1,2)=1/4;
% T(i,i-5,3)=1/4;
% T(i,i,5)=1/4;
% end
% 
% % state 7-9,12-14,17-19
% for i = 7:1:9
% T(i,i+5,1)=1/5;
% T(i,i+1,2)=1/5;
% T(i,i-5,3)=1/5;
% T(i,i-1,4)=1/5;
% T(i,i,5)=1/5;
% end
% 
% for i = 12:1:14
% T(i,i+5,1)=1/5;
% T(i,i+1,2)=1/5;
% T(i,i-5,3)=1/5;
% T(i,i-1,4)=1/5;
% T(i,i,5)=1/5;
% end
% 
% for i = 17:1:19
% T(i,i+5,1)=1/5;
% T(i,i+1,2)=1/5;
% T(i,i-5,3)=1/5;
% T(i,i-1,4)=1/5;
% T(i,i,5)=1/5;
% end
% 
% 
% % state 10-15-20
% for i = 10:5:20
% T(i,i+5,1)=1/4;
% T(i,i+1,2)=1/4;
% T(i,i-5,3)=1/4;
% T(i,i,5)=1/4;
% end
% 
% % state 21
% T(21,22,1)=1/3;
% T(21,16,3)=1/3;
% T(21,21,5)=1/3;
% 
% % state 22-24
% for i = 22:1:24
% T(i,i-5,3)=1/4;
% T(i,i+1,2)=1/4;
% T(i,i-1,4)=1/4;
% T(i,i,5)=1/4;
% end
% 
% % state 25
% T(25,20,3)=1/3;
% T(25,24,4)=1/3;
% T(25,25,5)=1/3;
% 
% 
% %%
% % recreate transition probability states: A = [7 19 22];  B = [8 9 17 20 23 3 4];
% % state 7
% T(7,7+5,1)=0.2/4;
% T(7,7+1,2)=0.2/4;
% T(7,7-5,3)=0.2/4;
% T(7,7-1,4)=0.2/4;
% T(7,7,5)=0.8;
% %state 19
% T(19,19+5,1)=0.2/4;
% T(19,19+1,2)=0.2/4;
% T(19,19-5,3)=0.2/4;
% T(19,19-1,4)=0.2/4;
% T(19,19,5)=0.8;
% %state 22
% T(22,22+1,2)=0.2/3;
% T(22,22-5,3)=0.2/3;
% T(22,22-1,4)=0.2/3;
% T(22,22,5)=0.8;
% 
% %around 7
% T(8,8+5,1)=0.99/4;
% T(8,8+1,2)=0.99/4;
% T(8,8-5,3)=0.99/4;
% T(8,8-1,4)=0.01;
% T(8,8,5)=0.99/4;
% 
% T(12,12+5,1)=0.99/4;
% T(12,12+1,2)=0.99/4;
% T(12,12-5,4)=0.99/4;
% T(12,12-1,3)=0.01;
% T(12,12,5)=0.99/4;
% 
% T(6,6+5,1)=0.99/3;
% T(6,6+1,2)=0.01;
% T(6,6-5,3)=0.99/3;
% % T(8,8-1,4)=0.01;
% T(6,6,5)=0.99/3;
% 
% % around 19
% T(14,14+5,1)=0.01;
% T(14,14+1,2)=0.99/4;
% T(14,14-5,3)=0.99/4;
% T(14,14-1,4)=0.99/4;
% T(14,14,5)=0.99/4;
% 
% T(18,18+5,1)=0.99/4;
% T(18,18+1,2)=0.01;
% T(18,18-5,3)=0.99/4;
% T(18,18-1,4)=0.99/4;
% T(18,18,5)=0.99/4;
% 
% T(20,20+5,1)=0.99/3;
% % T(20,20+1,2)=0.01;
% T(20,20-5,3)=0.99/3;
% T(20,20-1,4)=0.01;
% T(20,20,5)=0.99/3;
% 
% T(24,24+5,1)=0.99/4;
% T(24,24+1,2)=0.99/4;
% T(24,24-5,3)=0.01;
% T(24,24-1,4)=0.99/4;
% T(24,24,5)=0.99/4;
% 
% % around 22
% 
% T(17,17+5,1)=0.01;
% T(17,17+1,2)=0.99/4;
% T(17,17-5,3)=0.99/4;
% T(17,17-1,4)=0.99/4;
% T(17,17,5)=0.99/4;
% 
% % T(21,21+5,1)=0.99/4;
% T(21,21+1,2)=0.01;
% T(21,21-5,3)=0.99/2;
% % T(21,21-1,4)=0.99/4;
% T(21,21,5)=0.99/2;
% 
% % T(24,24+5,1)=0.99/4;
% T(23,23+1,2)=0.99/3;
% T(23,23-5,3)=0.99/3;
% T(23,23-1,4)=0.01;
% T(23,23,5)=0.99/3;
%% define adminisble control action for each state
% % state 1
% U_admin{1}=[1 2 5];
% 
% % state 2-4
% for i = 2:1:4
% U_admin{i}=[1 2 4 5];
% end
% 
% % state 5
% U_admin{5}=[1 4 5];
% 
% % state 6-11-16
% for i = 6:5:16
% U_admin{i}=[1 2 5];
% end
% % state 7-9,12-14,17-19
% for i = 7:1:9
% U_admin{i}=[1 2 3 4 5];
% end
% for i = 12:1:14
% U_admin{i}=[1 2 3 4 5];
% end
% for i = 17:1:19
% U_admin{i}=[1 2 3 4 5];
% end
% 
% % state 10-15-20
% for i = 10:5:20
% U_admin{i}=[1 4 5];
% end
% 
% % state 21
% U_admin{21}=[2 3 5];
% 
% % state 22-24
% for i = 22:1:24
% U_admin{i}=[2 3 5];
% end
% 
% % state 25
% U_admin{25}=[3 4 5];

%% define deterministic policies
% combin_control=combvec(U_admin{:});
% for i=1:size(combin_control,2)
%     T_determin{i}=[];
%     for j=1:n
%         T_determin{i}=[T_determin{i};T(j,:,combin_control(j,i))];
%     end
% end


%Define Sat(A U B)
%Define Sat(not_obsacle U goal points)
A = [10 11];
states = [1:16];
notA = setdiff(states,A);
B = [7 8];


%% MDP model
% A 4 state MDP,
% 3 actions.
MDP.n=n;
MDP.m=m;
MDP.T=T;
% MDP.T_determin_num=size(combin_control,2);
% MDP.T_determin=T_determin;


%% Approximate solution for existential cae
BR_Sample_num=500;
Nmax=25;
pi_ini = [1 zeros(1,15)]';
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
cns=[cns, sum(z1(notA))>=0.9];
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
%%
i=1;
flag=1;
while(i<=Nmax && flag)
    item=find_convexhull(Vert_BRexist{i},pi_ini);
    if(abs(item-1)<=0.01)
        flag=0;
    else
        Vert_BRexist{i+1}=BRexist(MDP,Vert_BRexist{i},notA,0.9,BR_Sample_num);
        i=i+1;
    end
end
toc
