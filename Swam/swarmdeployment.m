%% Swarm deployment
clear
clc
close all
%% MDP model


%A 21-by-21 grid world bounded by borders,
% with 4 possible actions (North = 1, South = 2, East = 3, West = 4, Nomove = 5).
numx=17;
numy=16;
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

KTHK=["[3,1]";"[4,1]";"[5,1]";"[6,1]";"[7,1]";"[8,1]";"[9,1]";"[10,1]";"[11,1]";"[12,1]";"[13,1]";...
    "[8,2]";"[7,2]";"[6,2]";"[6,3]";"[5,3]";"[5,4]";"[4,4]";"[4,5]";"[3,5]";...
    "[9,2]";"[10,2]";"[10,3]";"[11,3]";"[11,4]";"[12,4]";"[12,5]";"[13,5]"];
KTHT=["[3,7]";"[3,8]";"[3,9]";"[3,10]";"[3,11]";...
    "[4,9]";"[5,9]";"[6,9]";"[7,9]";"[8,9]";"[9,9]";"[10,9]";"[11,9]";"[12,9]";"[13,9]"];
KTHH=["[3,13]";"[4,13]";"[5,13]";"[6,13]";"[7,13]";"[8,13]";"[9,13]";"[10,13]";"[11,13]";"[12,13]";"[13,13]";...
    "[3,17]";"[4,17]";"[5,17]";"[6,17]";"[7,17]";"[8,17]";"[9,17]";"[10,17]";"[11,17]";"[12,17]";"[13,17]";...
    "[8,14]";"[8,15]";"[8,16]"];

GW.TerminalStates = [KTHK;KTHT;KTHH];
MDP.TerminalStatesidx=state2idx(GW,GW.TerminalStates);

KTHnum=[];
for k=1:length(GW.TerminalStates)
    item=GW.TerminalStates(k);
    item=erase(item,"[");
    item=erase(item,"]");
    item=replace(item,',',' ');
    item=split(item);
    item=str2double(item);
    KTHnum=[KTHnum;item'];
end

KTHnum=[KTHnum(:,2) abs(KTHnum(:,1)-numy-1)];


%% initial figure
figure
for k=0:1:17
    plot([k*2 k*2], [0 32],'b-')
    hold on
end

for i=0:1:16
    plot([0 34],[i*2 i*2],'b-')
    hold on
end

for k=1:length(GW.TerminalStates)
    x=KTHnum(k,1)*2-1;
    y=KTHnum(k,2)*2-1;
    XX=[x-1 x+1 x+1 x-1];
    YY=[y-1 y-1 y+1 y+1];
    fill(XX,YY,'c')
    hold on
end

axis([0 34 0 32])

xticks([1:2:34])
xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17'})
yticks([1:2:32])
yticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16'})
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


%% noisy the transition probability
friction_pro=0.3;
for i=1:MDP.n
    for k=1:MDP.m-1
        if sum(MDP.T(i,:,k))>0.05
            % if rand<=0.5
            idx=find(MDP.T(i,:,k)>0);
            MDP.T(i,idx,k)=1-friction_pro;
            MDP.T(i,i,k)=friction_pro;
            % end
        end
    end
end

%%
n=MDP.n;
m=MDP.m;
T=MDP.T;

pi_ini=ones(n,1)/n;
%pi_f=zeros(n,1);
%pi_f(MDP.TerminalStatesidx)=1/length(MDP.TerminalStatesidx);

safebound=6/n; %length(MDP.TerminalStatesidx); %max(pi_f(MDP.TerminalStatesidx))*2;
targetlowerbound=2/n; %1/length(MDP.TerminalStatesidx);

%     tic
% 
%     %% optimization
%     N=6;
%     for k=1:N
%         Q{k}=sdpvar(n,m);
%     end
%     %pi_ini=sdpvar(n,1);
%     pi_f=sdpvar(n,1);
% 
%     cns=[];
%     for k=1:N
%         cns=[cns, ones(1,n)*Q{k}*ones(m,1)==1];
%         cns=[cns, Q{k}>=zeros(n,m)];
%     end
%     for k=1:N-1
%         for i=1:n
%             cns=[cns, ones(1,n)*(reshape(T(:,i,:),[n,m]).*Q{k})*ones(m,1)==Q{k+1}(i,:)*ones(m,1)];
%             cns=[cns, Q{k}(i,:)*ones(m,1)<=safebound];
%         end
%     end
%     for i=1:n
%         cns=[cns, Q{N}(i,:)*ones(m,1)<=safebound];
%     end
%     cns=[cns, Q{1}*ones(m,1)==pi_ini];
%     cns=[cns, Q{N}*ones(m,1)==pi_f];
%     cns=[cns, pi_f(MDP.TerminalStatesidx)>=targetlowerbound];
% 
% 
%     cns=[cns, sum(pi_f(MDP.TerminalStatesidx))>=0.90];
% 
%    obj= (pi_f(MDP.TerminalStatesidx)-1/length(MDP.TerminalStatesidx))'*(pi_f(MDP.TerminalStatesidx)-1/length(MDP.TerminalStatesidx));
% 
%     %[primalfeas,dualfeas] = check(cns);
%     ops = sdpsettings('solver','mosek');
%     %[model,recoverymodel] = export(cns,'',sdpsettings('solver','linprog'));
%     sol=optimize(cns,obj,ops);
%     for k=1:N
%         Qval{k}=value(Q{k});
%     end
%     % piini=value(pi_ini);
%     pif=value(pi_f);
%     for k=1:N
%         pi(:,k)=sum(Qval{k},2);
%     end
% 
%    %% recover policy
%    for k=1:N-1
%        for i=1:n
%         Uval{k}(i,:)=Qval{k}(i,:)/sum(Qval{k}(i,:));
%         FeaU{k,i}=find(Uval{k}(i,:)>=10^-6);
%         FeaUpro{k,i}=Uval{k}(i,FeaU{k,i});
%         FeaUprosum{k,i}(1)=FeaUpro{k,i}(1);
%         for j=1:length(FeaU{k,i})-1
%             FeaUprosum{k,i}(j+1)=sum(FeaUpro{k,i}(1:j+1));
%         end
%        end
%    end
%    toc

%    %% sample
%    total_sample=1000;
%    for nnn=1:total_sample
%    Num_agent_sample(nnn,:,1)=ones(1,n);
%    for k=1:N-1
%        Next_state=zeros(n,n);
%        for i=1:n
%            item=rand;
%            u(i,k)=FeaU{k,i}(min(find(FeaUprosum{k,i}>=item)));  %% randomly choose action
%            next_posstate=find(T(i,:,u(i,k))>0.01);
%            next_pro=T(i,next_posstate,u(i,k));
%            next_prosum(1)=next_pro(1);
%            for j=1:length(next_posstate)-1
%             next_prosum(j+1)=sum(next_pro(1:j+1));
%            end
%             item=rand;
%             next_state=next_posstate(min(find(next_prosum>=item)));
%           Next_state(i,next_state)=Num_agent_sample(nnn,i,k);
%        end
%        Num_agent_sample(nnn,:,k+1)=sum(Next_state,1);
%    end
%    end
% 
%    for k=1:N
%        for i=1:n
%            Num_agent(i,k)=sum(Num_agent_sample(:,i,k))/total_sample;
%        end
%    end
%   toc

  %% Approximate solution
Rand_num=2;
for nnn=1:Rand_num
    Nmax=9;
    BR_Sample_num=300;
    %% construct inial optimization problem
    yalmip('clear')
    z1=sdpvar(n,1);
    z2=sdpvar(n,1);
    Z1=sdpvar(n,m);
    Chosen_sample=sdpvar(n,1);
    cns=[];
    cns=[cns, ones(1,n)*Z1*ones(m,1)==1];
    cns=[cns, Z1>=zeros(n,m)];
    cns=[cns, Z1*ones(m,1)==z1];
%     cns=[cns, z1<=safebound];
%     cns=[cns, z2(MDP.TerminalStatesidx)>=targetlowerbound];
    cns=[cns, sum(z2(MDP.TerminalStatesidx))>=0.90];

    for i=1:n
        cns=[cns, Z1(i,:)>=zeros(1,m)];
        cns=[cns, ones(1,n)*(reshape(T(:,i,:),[n,m]).*Z1)*ones(m,1)==z2(i)];
    end
    obj=norm(Chosen_sample-z1); %norm(Sample(:,kkk)-z1,inf); %  (Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1); %
    ops = sdpsettings('solver','mosek');
    BRreachSW_ini = optimizer(cns,obj,ops,Chosen_sample,z1);

    tic
    % initialization
    for i=1:BR_Sample_num-n
        Sample(:,i)=3*rand(n,1)-1.5;
        Sample(end,i)=1-sum(Sample(1:end-1,i));
    end
    Sample=[Sample eye(n)];


    z11=zeros(n,BR_Sample_num);
    parfor k=1:BR_Sample_num
        z11(:,k)=BRreachSW_ini(Sample(:,k));
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
        Vert_BR{i+1}=Approx_Swarm(MDP,Vert_BR{i},BR_Sample_num,safebound);
        % RA_BRtotal=[RA_BRtotal; Vert_BR{i+1}];
        % waitbar(i/Nmax,figbar,'Domain of Acctraction')
        item=find_convexhull(Vert_BR{i+1});

        if(abs(item-1)<=0.01)
            flag=0;
        else
            i=i+1;
        end
    end
    Comtime_SW(nnn)=toc;
    Vert_SW{nnn}=Vert_BR;
    nnn;
end


% %% plot figure
% %     for k=1:N-1
% %         Num_agent=round(pi*n);
% %     end
%     % dec=sdpvar(n*m*N,1);
%     % cons=[];
%     % cons=[model.A*dec<=model.b, model.Aeq*dec==model.beq, model.lb<=dec<=model.ub];
%     % sol=optimize(cons,'',ops);
%     % Dec_val=value(dec);
%     % for k=1:N
%     % Dec_matrix{k}=reshape(Dec_val((k-1)*n*m+1:k*n*m),[n,m]);
%     % end
%
%     % Dec_val=linprog(model.c,model.A,model.b,model.Aeq,model.beq,model.lb,model.ub);
%     % for k=1:N
%     % Dec_matrix{k}=reshape(Dec_val((k-1)*n*m+1:k*n*m),[n,m]);
%     % end
%     % Dec_piini=Dec_val(N*n*m+1:end);
%     %
%     % for k=1:N
%     %     errmatrix(k)=norm(Qval{k}-Dec_matrix{k});
%     % end
%     % err_piini=Dec_piini-piini;
%
%
%     %% plot figure
%       ds=0.67;
%   %  c4=[min(min(Num_agent)) max(max(Num_agent))];
%     c4=[min(min(pi)) max(max(pi))];
%     figure
%     posfig{1}=subplot(2,3,1)
%     for kk=1:n
%         x=Statenum(kk,1)*2-1;
%         y=Statenum(kk,2)*2-1;
%         xx=[x-ds/2 x+ds/2];
%         yy=[y-ds/2 y+ds/2];
%         %imagesc(xx,yy,Num_agent(kk,1))
%         imagesc(xx,yy,pi(kk,1))
%         hold on
%     end
%     axis([0 34 0 32])
%     colorbar
%     caxis(c4)
%     set(gca,'ydir','normal');
%     xlabel(['{\bf (a)} $\pi_0$'],'FontSize',16,'interpreter','latex')
%    % ylabel('$y$','FontSize',16,'interpreter','latex')
%     xticks([1:2:34])
%     xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17'})
%     yticks([1:2:32])
%     yticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16'})
%     hold on
%     grid off
%
%
%  posfig{2}=subplot(2,3,2)
%     for kk=1:n
%         x=Statenum(kk,1)*2-1;
%         y=Statenum(kk,2)*2-1;
%         xx=[x-ds/2 x+ds/2];
%         yy=[y-ds/2 y+ds/2];
%         %imagesc(xx,yy,Num_agent(kk,2))
%         imagesc(xx,yy,pi(kk,2))
%         hold on
%     end
%     axis([0 34 0 32])
%     colorbar
%     caxis(c4)
%     set(gca,'ydir','normal');
%     xlabel(['{\bf (b)} $\pi_1$'],'FontSize',16,'interpreter','latex')
%   %  ylabel('$y$','FontSize',16,'interpreter','latex')
%     xticks([1:2:34])
%     xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17'})
%     yticks([1:2:32])
%     yticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16'})
%     hold on
%     grid off
%
%
%      posfig{3}=subplot(2,3,3)
%     for kk=1:n
%         x=Statenum(kk,1)*2-1;
%         y=Statenum(kk,2)*2-1;
%         xx=[x-ds/2 x+ds/2];
%         yy=[y-ds/2 y+ds/2];
%       %  imagesc(xx,yy,Num_agent(kk,3))
%         imagesc(xx,yy,pi(kk,3))
%         hold on
%     end
%     axis([0 34 0 32])
%     colorbar
%     caxis(c4)
%     set(gca,'ydir','normal');
%     xlabel(['{\bf (c)} $\pi_2$'],'FontSize',16,'interpreter','latex')
%    % ylabel('$y$','FontSize',16,'interpreter','latex')
%     xticks([1:2:34])
%     xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17'})
%     yticks([1:2:32])
%     yticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16'})
%     hold on
%     grid off
%
%
%
%  posfig{4}=subplot(2,3,4)
%     for kk=1:n
%         x=Statenum(kk,1)*2-1;
%         y=Statenum(kk,2)*2-1;
%         xx=[x-ds/2 x+ds/2];
%         yy=[y-ds/2 y+ds/2];
%         %imagesc(xx,yy,Num_agent(kk,2))
%         imagesc(xx,yy,pi(kk,4))
%         hold on
%     end
%     axis([0 34 0 32])
%     colorbar
%     caxis(c4)
%     set(gca,'ydir','normal');
%     xlabel(['{\bf (d)} $\pi_3$'],'FontSize',16,'interpreter','latex')
%    % ylabel('$y$','FontSize',16,'interpreter','latex')
%     xticks([1:2:34])
%     xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17'})
%     yticks([1:2:32])
%     yticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16'})
%     hold on
%     grid off
%
%
%      posfig{5}=subplot(2,3,5)
%     for kk=1:n
%         x=Statenum(kk,1)*2-1;
%         y=Statenum(kk,2)*2-1;
%         xx=[x-ds/2 x+ds/2];
%         yy=[y-ds/2 y+ds/2];
%       %  imagesc(xx,yy,Num_agent(kk,3))
%         imagesc(xx,yy,pi(kk,5))
%         hold on
%     end
%     axis([0 34 0 32])
%     colorbar
%     caxis(c4)
%     set(gca,'ydir','normal');
%     xlabel(['{\bf (e)} $\pi_4$'],'FontSize',16,'interpreter','latex')
%    % ylabel('$y$','FontSize',16,'interpreter','latex')
%     xticks([1:2:34])
%     xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17'})
%     yticks([1:2:32])
%     yticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16'})
%     hold on
%     grid off
%
%      posfig{6}=subplot(2,3,6)
%     for kk=1:n
%         x=Statenum(kk,1)*2-1;
%         y=Statenum(kk,2)*2-1;
%         xx=[x-ds/2 x+ds/2];
%         yy=[y-ds/2 y+ds/2];
%         imagesc(xx,yy,pi(kk,6))
%         hold on
%     end
%     axis([0 34 0 32])
%     colorbar
%     caxis(c4)
%     set(gca,'ydir','normal');
%     xlabel(['{\bf (f)} $\pi_5$'],'FontSize',16,'interpreter','latex')
%    % ylabel('$y$','FontSize',16,'interpreter','latex')
%     xticks([1:2:34])
%     xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17'})
%     yticks([1:2:32])
%     yticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16'})
%     hold on
%     grid off
%
%
%   pos3=get(posfig{3}, 'Position');
%   pos6=get(posfig{6}, 'Position');
%   colormap jet
% h=colorbar;
%
% set(h, 'Position', [pos6(1)+pos6(3)+0.01 pos6(2)+0.04 pos6(3)*0.1 pos3(4)+pos3(4)+0.08])
%  %ylabel(h,'infinite-horizon invariance probability')
% caxis(c4)
%
%
% subplot(2,3,1)
% colorbar off
% subplot(2,3,2)
% colorbar off
% subplot(2,3,3)
% colorbar off
% subplot(2,3,4)
% colorbar off
% subplot(2,3,5)
% colorbar off
%
%
% %% plot figure
%       ds=0.67;
%     c4=[min(min(Num_agent)) max(max(Num_agent))];
%     figure
%     posfig{1}=subplot(2,3,1)
%     for kk=1:n
%         x=Statenum(kk,1)*2-1;
%         y=Statenum(kk,2)*2-1;
%         xx=[x-ds/2 x+ds/2];
%         yy=[y-ds/2 y+ds/2];
%         imagesc(xx,yy,Num_agent(kk,1))
%         hold on
%     end
%     axis([0 34 0 32])
%     colorbar
%     caxis(c4)
%     set(gca,'ydir','normal');
%     xlabel(['{\bf (a)} $\bar{\bf n}_0$'],'FontSize',16,'interpreter','latex')
%   %  ylabel('$y$','FontSize',16,'interpreter','latex')
%     xticks([1:2:34])
%     xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17'})
%     yticks([1:2:32])
%     yticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16'})
%     hold on
%     grid off
%
%
%  posfig{2}=subplot(2,3,2)
%     for kk=1:n
%         x=Statenum(kk,1)*2-1;
%         y=Statenum(kk,2)*2-1;
%         xx=[x-ds/2 x+ds/2];
%         yy=[y-ds/2 y+ds/2];
%         imagesc(xx,yy,Num_agent(kk,2))
%         hold on
%     end
%     axis([0 34 0 32])
%     colorbar
%     caxis(c4)
%     set(gca,'ydir','normal');
%     xlabel(['{\bf (b)} $\bar{\bf n}_1$'],'FontSize',16,'interpreter','latex')
%    % ylabel('$y$','FontSize',16,'interpreter','latex')
%     xticks([1:2:34])
%     xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17'})
%     yticks([1:2:32])
%     yticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16'})
%     hold on
%     grid off
%
%
%      posfig{3}=subplot(2,3,3)
%     for kk=1:n
%         x=Statenum(kk,1)*2-1;
%         y=Statenum(kk,2)*2-1;
%         xx=[x-ds/2 x+ds/2];
%         yy=[y-ds/2 y+ds/2];
%         imagesc(xx,yy,Num_agent(kk,3))
%         hold on
%     end
%     axis([0 34 0 32])
%     colorbar
%     caxis(c4)
%     set(gca,'ydir','normal');
%     xlabel(['{\bf (c)} $\bar{\bf n}_2$'],'FontSize',16,'interpreter','latex')
%    % ylabel('$y$','FontSize',16,'interpreter','latex')
%     xticks([1:2:34])
%     xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17'})
%     yticks([1:2:32])
%     yticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16'})
%     hold on
%     grid off
%
%
%      posfig{4}=subplot(2,3,4)
%     for kk=1:n
%         x=Statenum(kk,1)*2-1;
%         y=Statenum(kk,2)*2-1;
%         xx=[x-ds/2 x+ds/2];
%         yy=[y-ds/2 y+ds/2];
%         imagesc(xx,yy,Num_agent(kk,3))
%         hold on
%     end
%     axis([0 34 0 32])
%     colorbar
%     caxis(c4)
%     set(gca,'ydir','normal');
%     xlabel(['{\bf (d)} $\bar{\bf n}_3$'],'FontSize',16,'interpreter','latex')
%    % ylabel('$y$','FontSize',16,'interpreter','latex')
%     xticks([1:2:34])
%     xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17'})
%     yticks([1:2:32])
%     yticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16'})
%     hold on
%     grid off
%
%
%      posfig{5}=subplot(2,3,5)
%     for kk=1:n
%         x=Statenum(kk,1)*2-1;
%         y=Statenum(kk,2)*2-1;
%         xx=[x-ds/2 x+ds/2];
%         yy=[y-ds/2 y+ds/2];
%         imagesc(xx,yy,Num_agent(kk,5))
%         hold on
%     end
%     axis([0 34 0 32])
%     colorbar
%     caxis(c4)
%     set(gca,'ydir','normal');
%     xlabel(['{\bf (e)} $\bar{\bf n}_4$'],'FontSize',16,'interpreter','latex')
%    % ylabel('$y$','FontSize',16,'interpreter','latex')
%     xticks([1:2:34])
%     xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17'})
%     yticks([1:2:32])
%     yticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16'})
%     hold on
%     grid off
%
%
%
%      posfig{6}=subplot(2,3,6)
%     for kk=1:n
%         x=Statenum(kk,1)*2-1;
%         y=Statenum(kk,2)*2-1;
%         xx=[x-ds/2 x+ds/2];
%         yy=[y-ds/2 y+ds/2];
%         imagesc(xx,yy,Num_agent(kk,6))
%         hold on
%     end
%     axis([0 34 0 32])
%     colorbar
%     caxis(c4)
%     set(gca,'ydir','normal');
%     xlabel(['{\bf (f)} $\bar{\bf n}_5$'],'FontSize',16,'interpreter','latex')
%   %  ylabel('$y$','FontSize',16,'interpreter','latex')
%     xticks([1:2:34])
%     xticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17'})
%     yticks([1:2:32])
%     yticklabels({'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16'})
%     hold on
%     grid off
%
%
%   pos3=get(posfig{3}, 'Position');
%   pos6=get(posfig{6}, 'Position');
%   colormap jet
% h=colorbar;
%
% set(h, 'Position', [pos6(1)+pos6(3)+0.01 pos6(2)+0.04 pos6(3)*0.1 pos3(4)+pos3(4)+0.08])
%  %ylabel(h,'infinite-horizon invariance probability')
% caxis(c4)
%
%
% subplot(2,3,1)
% colorbar off
% subplot(2,3,2)
% colorbar off
% subplot(2,3,3)
% colorbar off
% subplot(2,3,4)
% colorbar off
% subplot(2,3,5)
% colorbar off
%
%
