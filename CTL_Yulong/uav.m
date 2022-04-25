%% UAV
clear
clc
close all

%% define grid world
numx=20;
numy=20;
GW = createGridWorld(numy,numx);

Statenum=[];
for k=1:length(GW.States)
    item=GW.States(k);
    item=erase(item,"[");
    item=erase(item,"]");
    item=replace(item,',',' ');
    item=split(item);
    item=str2double(item);
    Statenum=[Statenum;item'];
end

Statenum=[Statenum(:,2) abs(Statenum(:,1)-numy-1)];


%% specify KTH

Obs1=["[4,1]";"[4,2]";"[4,3]";"[4,4]";"[4,5]";"[5,3]";"[6,3]";"[7,3]";"[8,3]";"[9,3]";"[10,3]";...
    "[11,3]";"[12,3]";"[13,3]";"[14,3]";"[15,3]";"[16,1]";"[16,2]";"[16,3]";"[16,4]";"[16,5]"];
Obs2=["[4,9]";"[4,10]";"[4,11]";"[4,12]";"[4,13]";"[5,11]";"[6,11]";"[7,11]";"[8,11]";"[9,11]";"[10,11]";...
    "[11,11]";"[12,11]";"[13,11]";"[14,11]";"[15,11]";"[16,9]";"[16,10]";"[16,11]";"[16,12]";"[16,13]"];
Obs3=["[4,16]";"[4,17]";"[4,18]";"[4,19]";"[4,20]";"[5,18]";"[6,18]";"[7,18]";"[8,18]";"[9,18]";"[10,18]";...
    "[11,18]";"[12,18]";"[13,18]";"[14,18]";"[15,18]";"[16,16]";"[16,17]";"[16,18]";"[16,19]";"[16,20]"];


GW.ObstacleStates = [Obs1;Obs2;Obs3];
GW.TerminalStates=["[1,19]";"[1,20]";"[2,19]";"[2,20]"];
MDP.ObstacleStatesidx=state2idx(GW,GW.ObstacleStates);
MDP.TerminalStatesidx=state2idx(GW,GW.TerminalStates);

Obsnum=[];
for k=1:length(GW.ObstacleStates)
    item=GW.ObstacleStates(k);
    item=erase(item,"[");
    item=erase(item,"]");
    item=replace(item,',',' ');
    item=split(item);
    item=str2double(item);
    Obsnum=[Obsnum;item'];
end

Obsnum=[Obsnum(:,2) abs(Obsnum(:,1)-numy-1)];





%% initial figure
figure
for k=0:1:numx
    plot([k*2 k*2], [0 2*numx],'b-')
    hold on
end

for i=0:1:numy
    plot([0 2*numy],[i*2 i*2],'b-')
    hold on
end

for k=1:length(GW.ObstacleStates)
    x=Obsnum(k,1)*2-1;
    y=Obsnum(k,2)*2-1;
    XX=[x-1 x+1 x+1 x-1];
    YY=[y-1 y-1 y+1 y+1];
    fill(XX,YY,'c')
    hold on
end

axis([0 2*numx 0 2*numy])

xticks([1:2:2*numx])
xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20'})
yticks([1:2:2*numy])
yticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20'})
hold on



%% redefine
MDP.GridSize=GW.GridSize;
MDP.States=GW.States;
MDP.Actions=GW.Actions;
MDP.T=GW.T;
MDP.Actions=[MDP.Actions;'nomove'];
% update transition probability
MDP.T(:,:,5)=eye(length(MDP.States));

%MDP.TerminalStatesidx=sort(MDP.TerminalStatesidx);
MDP.n=length(MDP.States);
MDP.m=length(MDP.Actions);

%% define neighboring states
for i=1:MDP.n
    item=MDP.States(i);
    item=erase(item,"[");
    item=erase(item,"]");
    item=replace(item,',',' ');
    item=split(item);
    item=str2double(item);
    Statenum=item';
    xax=max(Statenum(1)-1,1):1:min(Statenum(1)+1,numx);
    yax=max(Statenum(2)-1,1):1:min(Statenum(2)+1,numx);
    item=combvec(xax,yax);
    item=item';
    item=string(item);
    Neighstate{i}='['+item(:,1)+','+item(:,2)+']';
    Neighstateidx{i}=state2idx(GW,Neighstate{i});
end
MDP.Neigh=Neighstate;
MDP.Neighstateidx=Neighstateidx;
%% noisy the transition probability
friction_pro=0.2;
for i=1:MDP.n
    for k=1:MDP.m-1
        if sum(MDP.T(i,:,k))>0.05
            % if rand<=0.5
            idx=find(MDP.T(i,:,k)>0);
            MDP.T(i,MDP.Neighstateidx{i},k)=friction_pro/(numel(MDP.Neighstateidx{i})-1);
            MDP.T(i,idx,k)=1-friction_pro;
            % end
        end
    end
end


for iii=1:MDP.m
    for jjj1=1:MDP.n
        sumT(jjj1,iii)=sum(MDP.T(jjj1,:,iii));
    end
end

A = MDP.ObstacleStatesidx;
states = 1:MDP.n;
notA = setdiff(states,A);
B = MDP.TerminalStatesidx;



n=MDP.n;
m=MDP.m;
T=MDP.T;
%% Approximate solution for existential cae
BR_Sample_num=1000;
Nmax=5;
%pi_ini = [1 zeros(1,15)]';
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
cns=[cns, sum(z1(notA))==1];
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
   % item=find_convexhull(Vert_BRexist{i},pi_ini);
   % if(abs(item-1)<=0.01)
   %     flag=0;
   % else
        Vert_BRexist{i+1}=BRexist(MDP,Vert_BRexist{i},notA,1,BR_Sample_num);
        i=i+1;
   % end
end
toc



