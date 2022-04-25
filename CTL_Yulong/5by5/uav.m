%% UAV
clear
clc
close all

%% define grid world
numx=5;
numy=5;
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

Obs=["[2,2]";"[2,3]";"[2,4]";"[3,3]";"[4,2]";"[4,3]";"[4,4]"];


GW.ObstacleStates = [Obs];
GW.TerminalStates=["[1,5]"];
MDP.ObstacleStatesidx=state2idx(GW,GW.ObstacleStates);
MDP.TerminalStatesidx=state2idx(GW,GW.TerminalStates);
MDP.ini_state=["[5,1]"];
MDP.ini_stateidx=state2idx(GW,MDP.ini_state);


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



Ternum=[];
for k=1:length(GW.TerminalStates)
    item=GW.TerminalStates(k);
    item=erase(item,"[");
    item=erase(item,"]");
    item=replace(item,',',' ');
    item=split(item);
    item=str2double(item);
    Ternum=[Ternum;item'];
end
Ternum=[Ternum(:,2) abs(Ternum(:,1)-numy-1)];

Ininum=[];
for k=1:length(MDP.ini_state)
    item=MDP.ini_state(k);
    item=erase(item,"[");
    item=erase(item,"]");
    item=replace(item,',',' ');
    item=split(item);
    item=str2double(item);
    Ininum=[Ininum;item'];
end
Ininum=[Ininum(:,2) abs(Ininum(:,1)-numy-1)];




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

for k=1:length(MDP.ini_state)
    x=Ininum(k,1)*2-1;
    y=Ininum(k,2)*2-1;
    XX=[x-1 x+1 x+1 x-1];
    YY=[y-1 y-1 y+1 y+1];
    fill(XX,YY,'b')
    hold on
end

for k=1:length(GW.TerminalStates)
    x=Ternum(k,1)*2-1;
    y=Ternum(k,2)*2-1;
    XX=[x-1 x+1 x+1 x-1];
    YY=[y-1 y-1 y+1 y+1];
    fill(XX,YY,'r')
    hold on
end

axis([0 2*numx 0 2*numy])

xticks([1:2:2*numx])
xticklabels({'1','2','3','4','5'})
yticks([1:2:2*numy])
yticklabels({'1','2','3','4','5'})
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
friction_pro=0;
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

%% define obsset and target set
A = MDP.ObstacleStatesidx;
states = 1:MDP.n;
notA = setdiff(states,A);
B = MDP.TerminalStatesidx;
alpha1=1;
alpha2=0.9;




n=MDP.n;
m=MDP.m;
T=MDP.T;

Iter_max=2;
BR_Sample_num=100;
Nmax=20;

%% define initial distribution 
pi_ini = zeros(1,n)';
pi_ini(MDP.ini_stateidx)=1;

%% initil optimization BR
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


for nnn=1:Iter_max
    tic
    %% Approximate solution for existential cae
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
    Vert_BRexist{nnn}{1}=zz1;
    %%
    i=1;
    flag=1;
    while(i<=Nmax && flag)
        item=find_convexhull(Vert_BRexist{nnn}{i},pi_ini);
        if(abs(item-1)<=0.01)
            flag=0;
        else
            Vert_BRexist{nnn}{i+1}=BRexist(MDP,Vert_BRexist{nnn}{i},notA,1,BR_Sample_num);
            i=i+1;
        end
    end
    Com_time(nnn)=toc;
end



