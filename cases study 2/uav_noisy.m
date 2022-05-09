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

Obs=["[2,2]";"[2,3]";"[3,3]";"[4,3]";"[4,4]"];


GW.ObstacleStates = [Obs];
GW.TerminalStates=["[1,5]"];
MDP.ObstacleStatesidx=state2idx(GW,GW.ObstacleStates);
MDP.TerminalStatesidx=state2idx(GW,GW.TerminalStates);
MDP.ini_state=["[5,1]"];
MDP.ini_stateidx=state2idx(GW,MDP.ini_state);

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
    Statenumitem=item';
    xax=max(Statenumitem(1)-1,1):1:min(Statenumitem(1)+1,numx);
    yax=max(Statenumitem(2)-1,1):1:min(Statenumitem(2)+1,numx);
    item=combvec(xax,yax);
    item=item';
    item=string(item);
    Neighstate{i}='['+item(:,1)+','+item(:,2)+']';
    Neighstateidx{i}=state2idx(GW,Neighstate{i});
end
MDP.Neigh=Neighstate;
MDP.Neighstateidx=Neighstateidx;
%% noisy the transition probability
friction_pro=0.05;
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

for i=1:length(MDP.ObstacleStatesidx)
    for k=1:MDP.m
        MDP.T(MDP.ObstacleStatesidx(i),:,k)=0;
        MDP.T(MDP.ObstacleStatesidx(i),MDP.ObstacleStatesidx(i),k)=1;
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
alpha1=0.85;
alpha2=0.8;




n=MDP.n;
m=MDP.m;
T=MDP.T;

Iter_max=100;
BR_Sample_num=400;
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
cns=[cns, ones(1,n)*z2==1];
cns=[cns, z2>=zeros(n,1)];
cns=[cns, sum(z1(notA))>=alpha1];
cns=[cns, sum(z2(B))>=alpha2];
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
        Sample(:,i)=10*rand(n,1)-5;
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
    Vert_BRexist_union{nnn}{1}=Vert_BRexist{nnn}{1};
    %%
    i=1;
    flag=1;
    while(i<=Nmax && flag)
        % item=find_convexhull(Vert_BRexist{nnn}{i},pi_ini);
        if length(find(Vert_BRexist{nnn}{i}(:,MDP.ini_stateidx)>0.99))>0.1
            item=1;
        else
            item=0;
        end
        if(abs(item-1)<=0.01)
            flag=0;
        else
            Vert_BRexist{nnn}{i+1}=BRexist(MDP,Vert_BRexist_union{nnn}{i},notA,alpha1,BR_Sample_num);
            Vert_BRexist_union{nnn}{i+1}=[Vert_BRexist_union{nnn}{i};Vert_BRexist{nnn}{i+1}];
            i=i+1;
        end
    end
    Com_time(nnn)=toc;
    nnn
end


for nnn=1:Iter_max
    for i=1:length(Vert_BRexist{nnn})
        maxini(nnn,i)=max(Vert_BRexist{nnn}{i}(:,MDP.ini_stateidx));
    end
end


% N=10;
% 
% yalmip('clear')
% z1=sdpvar(n,1);
% z2=sdpvar(n,1);
% for i=1:N
%     Z1{i}=sdpvar(n,m);
% end
% 
% Chosen_sample=sdpvar(n,1);
% cns=[];
% cns=[cns, Z1{1}*ones(m,1)==pi_ini];
% for i=1:N
%     cns=[cns, ones(1,n)*Z1{i}*ones(m,1)==1];
%     cns=[cns, Z1{i}>=zeros(n,m)];
%     item=Z1{i}*ones(m,1);
%     %cns=[cns, Z1{i}*ones(m,1)==z1];
%     cns=[cns, sum(item(notA))>=alpha1];
% end
% 
% cns=[cns, ones(1,n)*z2==1];
% cns=[cns, z2>=zeros(n,1)];
% cns=[cns, sum(z2(notA))>=alpha1];
% cns=[cns, sum(z2(B))>=alpha2];
% for k=1:N-1
%     for i=1:n
%         cns=[cns, ones(1,n)*(reshape(T(:,i,:),[n,m]).*Z1{k})*ones(m,1)==Z1{k+1}(i,:)*ones(m,1)];
%     end
% end
% for i=1:n
%     cns=[cns, ones(1,n)*(reshape(T(:,i,:),[n,m]).*Z1{N})*ones(m,1)==z2(i)];
% end
% obj=0;
% 
% % for i=1:N
% %     item=Z1{i}*ones(m,1);
% %     %cns=[cns, Z1{i}*ones(m,1)==z1];
% %     obj=obj-sum(sum(item(A)));
% % end
% obj=obj-sum(sum(z2(A)));
% %obj=norm(Chosen_sample-z1); %norm(Sample(:,kkk)-z1,inf); % (Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1); %
% ops = sdpsettings('solver','mosek','verbose',0);
% BRexist_init = optimize(cns,obj,ops);
% 
% for k=1:N
%     Z1v{k}=value(Z1{k});
%     pv(:,k)=Z1v{k}*ones(m,1);
% end
% pv(:,N+1)=value(z2);
% 
% 
% 
% 
% 
% %% plot figure
% ds=0.67;
% c4=[min(min(pv)) max(max(pv))];
% figure
% posfig{1}=subplot(2,5,1)
% for kk=1:n
%     x=Statenum(kk,1)*2-1;
%     y=Statenum(kk,2)*2-1;
%     xx=[x-ds/2 x+ds/2];
%     yy=[y-ds/2 y+ds/2];
%     imagesc(xx,yy,pv(kk,2))
%     hold on
% end
% axis([0 10 0 10])
% colorbar
% caxis(c4)
% set(gca,'ydir','normal');
% xlabel(['{\bf (a)} $\pi_1$'],'FontSize',16,'interpreter','latex')  %  ylabel('$y$','FontSize',16,'interpreter','latex')
% xticks([1:2:20])
% xticklabels({'1','2','3','4','5'})
% yticks([1:2:20])
% yticklabels({'1','2','3','4','5'})
% hold on
% grid off
% 
% posfig{2}=subplot(2,5,2)
% for kk=1:n
%     x=Statenum(kk,1)*2-1;
%     y=Statenum(kk,2)*2-1;
%     xx=[x-ds/2 x+ds/2];
%     yy=[y-ds/2 y+ds/2];
%     imagesc(xx,yy,pv(kk,3))
%     hold on
% end
% axis([0 10 0 10])
% colorbar
% caxis(c4)
% set(gca,'ydir','normal');
% xlabel(['{\bf (b)} $\pi_2$'],'FontSize',16,'interpreter','latex')%  ylabel('$y$','FontSize',16,'interpreter','latex')
% xticks([1:2:20])
% xticklabels({'1','2','3','4','5'})
% yticks([1:2:20])
% yticklabels({'1','2','3','4','5'})
% hold on
% grid off
% 
% posfig{3}=subplot(2,5,3)
% for kk=1:n
%     x=Statenum(kk,1)*2-1;
%     y=Statenum(kk,2)*2-1;
%     xx=[x-ds/2 x+ds/2];
%     yy=[y-ds/2 y+ds/2];
%     imagesc(xx,yy,pv(kk,4))
%     hold on
% end
% axis([0 10 0 10])
% colorbar
% caxis(c4)
% set(gca,'ydir','normal');
% xlabel(['{\bf (c)} $\pi_3$'],'FontSize',16,'interpreter','latex')  %  ylabel('$y$','FontSize',16,'interpreter','latex')
% xticks([1:2:20])
% xticklabels({'1','2','3','4','5'})
% yticks([1:2:20])
% yticklabels({'1','2','3','4','5'})
% hold on
% grid off
% 
% posfig{4}=subplot(2,5,4)
% for kk=1:n
%     x=Statenum(kk,1)*2-1;
%     y=Statenum(kk,2)*2-1;
%     xx=[x-ds/2 x+ds/2];
%     yy=[y-ds/2 y+ds/2];
%     imagesc(xx,yy,pv(kk,5))
%     hold on
% end
% axis([0 10 0 10])
% colorbar
% caxis(c4)
% set(gca,'ydir','normal');
% xlabel(['{\bf (d)} $\pi_4$'],'FontSize',16,'interpreter','latex')
% xticks([1:2:20])
% xticklabels({'1','2','3','4','5'})
% yticks([1:2:20])
% yticklabels({'1','2','3','4','5'})
% hold on
% grid off
% 
% posfig{5}=subplot(2,5,5)
% for kk=1:n
%     x=Statenum(kk,1)*2-1;
%     y=Statenum(kk,2)*2-1;
%     xx=[x-ds/2 x+ds/2];
%     yy=[y-ds/2 y+ds/2];
%     imagesc(xx,yy,pv(kk,6))
%     hold on
% end
% axis([0 10 0 10])
% colorbar
% caxis(c4)
% set(gca,'ydir','normal');
% xlabel(['{\bf (e)} $\pi_5$'],'FontSize',16,'interpreter','latex')
% xticks([1:2:20])
% xticklabels({'1','2','3','4','5'})
% yticks([1:2:20])
% yticklabels({'1','2','3','4','5'})
% hold on
% grid off
% 
% posfig{6}=subplot(2,5,6)
% for kk=1:n
%     x=Statenum(kk,1)*2-1;
%     y=Statenum(kk,2)*2-1;
%     xx=[x-ds/2 x+ds/2];
%     yy=[y-ds/2 y+ds/2];
%     imagesc(xx,yy,pv(kk,7))
%     hold on
% end
% axis([0 10 0 10])
% colorbar
% caxis(c4)
% set(gca,'ydir','normal');
% xlabel(['{\bf (f)} $\pi_6$'],'FontSize',16,'interpreter','latex')
% xticks([1:2:20])
% xticklabels({'1','2','3','4','5'})
% yticks([1:2:20])
% yticklabels({'1','2','3','4','5'})
% hold on
% grid off
% 
% posfig{6}=subplot(2,5,6)
% for kk=1:n
%     x=Statenum(kk,1)*2-1;
%     y=Statenum(kk,2)*2-1;
%     xx=[x-ds/2 x+ds/2];
%     yy=[y-ds/2 y+ds/2];
%     imagesc(xx,yy,pv(kk,7))
%     hold on
% end
% axis([0 10 0 10])
% colorbar
% caxis(c4)
% set(gca,'ydir','normal');
% xlabel(['{\bf (g)} $\pi_6$'],'FontSize',16,'interpreter','latex')
% xticks([1:2:20])
% xticklabels({'1','2','3','4','5'})
% yticks([1:2:20])
% yticklabels({'1','2','3','4','5'})
% hold on
% grid off
% 
% posfig{7}=subplot(2,5,7)
% for kk=1:n
%     x=Statenum(kk,1)*2-1;
%     y=Statenum(kk,2)*2-1;
%     xx=[x-ds/2 x+ds/2];
%     yy=[y-ds/2 y+ds/2];
%     imagesc(xx,yy,pv(kk,8))
%     hold on
% end
% axis([0 10 0 10])
% colorbar
% caxis(c4)
% set(gca,'ydir','normal');
% xlabel(['{\bf (h)} $\pi_7$'],'FontSize',16,'interpreter','latex')
% xticks([1:2:20])
% xticklabels({'1','2','3','4','5'})
% yticks([1:2:20])
% yticklabels({'1','2','3','4','5'})
% hold on
% grid off
% 
% posfig{8}=subplot(2,5,8)
% for kk=1:n
%     x=Statenum(kk,1)*2-1;
%     y=Statenum(kk,2)*2-1;
%     xx=[x-ds/2 x+ds/2];
%     yy=[y-ds/2 y+ds/2];
%     imagesc(xx,yy,pv(kk,9))
%     hold on
% end
% axis([0 10 0 10])
% colorbar
% caxis(c4)
% set(gca,'ydir','normal');
% xlabel(['{\bf (i)} $\pi_8$'],'FontSize',16,'interpreter','latex')
% xticks([1:2:20])
% xticklabels({'1','2','3','4','5'})
% yticks([1:2:20])
% yticklabels({'1','2','3','4','5'})
% hold on
% grid off
% 
% 
% posfig{9}=subplot(2,5,9)
% for kk=1:n
%     x=Statenum(kk,1)*2-1;
%     y=Statenum(kk,2)*2-1;
%     xx=[x-ds/2 x+ds/2];
%     yy=[y-ds/2 y+ds/2];
%     imagesc(xx,yy,pv(kk,10))
%     hold on
% end
% axis([0 10 0 10])
% colorbar
% caxis(c4)
% set(gca,'ydir','normal');
% xlabel(['{\bf (j)} $\pi_9$'],'FontSize',16,'interpreter','latex')
% xticks([1:2:20])
% xticklabels({'1','2','3','4','5'})
% yticks([1:2:20])
% yticklabels({'1','2','3','4','5'})
% hold on
% grid off
% 
% 
% posfig{10}=subplot(2,5,10)
% for kk=1:n
%     x=Statenum(kk,1)*2-1;
%     y=Statenum(kk,2)*2-1;
%     xx=[x-ds/2 x+ds/2];
%     yy=[y-ds/2 y+ds/2];
%     imagesc(xx,yy,pv(kk,11))
%     hold on
% end
% axis([0 10 0 10])
% colorbar
% caxis(c4)
% set(gca,'ydir','normal');
% xlabel(['{\bf (k)} $\pi_{10}$'],'FontSize',16,'interpreter','latex')
% xticks([1:2:20])
% xticklabels({'1','2','3','4','5'})
% yticks([1:2:20])
% yticklabels({'1','2','3','4','5'})
% hold on
% grid off
% 
% 
% pos5=get(posfig{5}, 'Position');
% pos10=get(posfig{10}, 'Position');
% colormap jet
% h=colorbar;
% 
% set(h, 'Position', [pos10(1)+pos10(3)+0.01 pos10(2)+0.04 pos10(3)*0.1 pos5(4)+pos5(4)+0.08])
% %ylabel(h,'infinite-horizon invariance probability')
% caxis(c4)
% 
% 
% subplot(2,5,1)
% colorbar off
% subplot(2,5,2)
% colorbar off
% subplot(2,5,3)
% colorbar off
% subplot(2,5,4)
% colorbar off
% subplot(2,5,5)
% colorbar off
% subplot(2,5,6)
% colorbar off
% subplot(2,5,7)
% colorbar off
% subplot(2,5,8)
% colorbar off
% subplot(2,5,9)
% colorbar off
