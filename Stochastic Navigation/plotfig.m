
clc
clear all 
close all


pp{1}=[1 7];
pp{2}=[3 7];
pp{3}=[5 7];
pp{4}=[7 7];
pp{5}=[1 5];
pp{6}=[3 5];
pp{7}=[5 5];
pp{8}=[7 5];
pp{9}=[1 3];
pp{10}=[3 3];
pp{11}=[5 3];
pp{12}=[7 3];
pp{13}=[1 1];
pp{14}=[3 1];
pp{15}=[5 1];
pp{16}=[7 1];
ds=0.67;
c4=[0.84 1];

%% MDP
n=16;
m=4;
T=transition_collision(n,m);
Target=[7 8]';
Obs=[10 11]';

%% plot DoA
load('DoA_data.mat')

pi0=Vert_DoA{4}{5}(154,:);

%% DoA from pi(1,:)
tic
N=6;
z = sdpvar(n+n*m*N,1);
z1=z(1:n);
z2=pi0';
for k=1:N
    Zz{k}=reshape(z(n+(k-1)*n*m+1:n+k*n*m),[n,m]);
end
cns=[];
for k=1:N-1
    cns=[cns, ones(1,n)*Zz{k}*ones(m,1)==1];
    for j=1:n
        cns=[cns, Zz{k}(j,:)>=zeros(1,m)];
        temp(j,1)=ones(1,n)*(reshape(T(:,j,:),[n,m]).*Zz{k})*ones(m,1);
    end
    cns=[cns, temp==Zz{k+1}*ones(m,1)];
end
cns=[cns, ones(1,n)*Zz{N}*ones(m,1)==1];
cns=[cns, Zz{1}*ones(m,1)==z2];
cns=[cns, Zz{N}*ones(m,1)==z1];
cns=[cns, ones(1,n)*z1==1];
cns=[cns, z1>=zeros(n,1)];
%obj=(Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1);
obj=-sum(z1(Target)); %norm(Sample(:,kkk)-z1,inf); %  (Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1); %
ops = sdpsettings('solver','mosek');
BRreach=optimize(cns,obj,ops);
Tt=value(z);
toc

% Tt(find(Tt<= 1.0000e-8))=0;
% if(sum(Tt)>=1.0000e-8)
%     Tt=Tt/sum(Tt);
% end
zz1=Tt(1:n);
for k=1:N
    Zzz{k}=reshape(Tt(n+(k-1)*n*m+1:n+k*n*m),[n,m]);
end
for k=1:N
    pi(:,k)=Zzz{k}*ones(m,1);
end
pi1=pi;

%%
figure
c4=[min(min(pi))  max(max(pi))];
nnn=1;
posfig{nnn}=subplot(2,3,nnn)
for kk=1:n
    x=pp{kk}(1);
    y=pp{kk}(2);
    xx=[x-ds/2 x+ds/2];
    yy=[y-ds/2 y+ds/2];
    imagesc(xx,yy,pi(kk,nnn))
    hold on
end
axis([0 8 0 8])
    colorbar
    caxis(c4)
  set(gca,'ydir','normal');
xlabel(['$x$',newline,'{\bf (a)} $\pi_0$'],'FontSize',16,'interpreter','latex')
ylabel('$y$','FontSize',16,'interpreter','latex')
xticks([1 3 5 7])
xticklabels({'1','2','3','4'})
yticks([1 3 5 7])
yticklabels({'1','2','3','4'})
hold on
grid off

nnn=2;
posfig{nnn}=subplot(2,3,nnn)
for kk=1:n
    x=pp{kk}(1);
    y=pp{kk}(2);
    xx=[x-ds/2 x+ds/2];
    yy=[y-ds/2 y+ds/2];
    imagesc(xx,yy,pi(kk,nnn))
    hold on
end
    colorbar
    caxis(c4)
  set(gca,'ydir','normal');
axis([0 8 0 8])
xlabel(['$x$',newline,'{\bf (b)} $\pi_1$'],'FontSize',16,'interpreter','latex')
ylabel('$y$','FontSize',16,'interpreter','latex')
xticks([1 3 5 7])
xticklabels({'1','2','3','4'})
yticks([1 3 5 7])
yticklabels({'1','2','3','4'})
hold on
grid off


nnn=3;
posfig{nnn}=subplot(2,3,nnn)
for kk=1:n
    x=pp{kk}(1);
    y=pp{kk}(2);
    xx=[x-ds/2 x+ds/2];
    yy=[y-ds/2 y+ds/2];
    imagesc(xx,yy,pi(kk,nnn))
    hold on
end
    colorbar
    caxis(c4)
  set(gca,'ydir','normal');
axis([0 8 0 8])
xlabel(['$x$',newline,'{\bf (c)} $\pi_2$'],'FontSize',16,'interpreter','latex')
ylabel('$y$','FontSize',16,'interpreter','latex')
xticks([1 3 5 7])
xticklabels({'1','2','3','4'})
yticks([1 3 5 7])
yticklabels({'1','2','3','4'})
hold on
grid off

nnn=4;
posfig{nnn}=subplot(2,3,nnn)
for kk=1:n
    x=pp{kk}(1);
    y=pp{kk}(2);
    xx=[x-ds/2 x+ds/2];
    yy=[y-ds/2 y+ds/2];
    imagesc(xx,yy,pi(kk,nnn))
    hold on
end
    colorbar
    caxis(c4)
  set(gca,'ydir','normal');
axis([0 8 0 8])
xlabel(['$x$',newline,'{\bf (d)} $\pi_3$'],'FontSize',16,'interpreter','latex')
ylabel('$y$','FontSize',16,'interpreter','latex')
xticks([1 3 5 7])
xticklabels({'1','2','3','4'})
yticks([1 3 5 7])
yticklabels({'1','2','3','4'})
hold on
grid off


nnn=5;
posfig{nnn}=subplot(2,3,nnn)
for kk=1:n
    x=pp{kk}(1);
    y=pp{kk}(2);
    xx=[x-ds/2 x+ds/2];
    yy=[y-ds/2 y+ds/2];
    imagesc(xx,yy,pi(kk,nnn))
    hold on
end

    colorbar
    caxis(c4)
  set(gca,'ydir','normal');
  axis([0 8 0 8])
xlabel(['$x$',newline,'{\bf (e)} $\pi_4$'],'FontSize',16,'interpreter','latex')
ylabel('$y$','FontSize',16,'interpreter','latex')
xticks([1 3 5 7])
xticklabels({'1','2','3','4'})
yticks([1 3 5 7])
yticklabels({'1','2','3','4'})
hold on
grid off

nnn=6;
posfig{nnn}=subplot(2,3,nnn)
for kk=1:n
    x=pp{kk}(1);
    y=pp{kk}(2);
    xx=[x-ds/2 x+ds/2];
    yy=[y-ds/2 y+ds/2];
    imagesc(xx,yy,pi(kk,nnn))
    hold on
end
    set(gca,'ydir','normal');
  axis([0 8 0 8])
xlabel(['$x$',newline,'{\bf (f)} $\pi_5$'],'FontSize',16,'interpreter','latex')
ylabel('$y$','FontSize',16,'interpreter','latex')
xticks([1 3 5 7])
xticklabels({'1','2','3','4'})
yticks([1 3 5 7])
yticklabels({'1','2','3','4'})
hold on
grid off

 pos3=get(posfig{3}, 'Position');
  pos6=get(posfig{6}, 'Position');
colormap jet
h=colorbar;
set(h, 'Position', [pos6(1)+pos6(3)+0.01 pos6(2)+0.04 pos6(3)*0.1 pos3(4)+pos3(4)+0.08])
 %ylabel(h,'infinite-horizon invariance probability')
caxis(c4)

 
subplot(2,3,1)
colorbar off
subplot(2,3,2)
colorbar off
subplot(2,3,3)
colorbar off
subplot(2,3,4)
colorbar off
subplot(2,3,5)
colorbar off


%% 
%% plot RAV
%clear DoA_data
load('RA_data.mat')

pi0=Vert_RA{12}{3}(25,:);

%% RAV from pi(1,:)
tic
N=6;
z = sdpvar(n+n*m*N,1);
z1=z(1:n);
z2=pi0';
for k=1:N
    Zz{k}=reshape(z(n+(k-1)*n*m+1:n+k*n*m),[n,m]);
end
cns=[];
for k=1:N-1
    cns=[cns, ones(1,n)*Zz{k}*ones(m,1)==1];
    for j=1:n
        cns=[cns, Zz{k}(j,:)>=zeros(1,m)];
        temp(j,1)=ones(1,n)*(reshape(T(:,j,:),[n,m]).*Zz{k})*ones(m,1);
    end
    cns=[cns, temp==Zz{k+1}*ones(m,1)];
end
 for k=2:N
            temp=Zz{k}*ones(m,1);
            cns=[cns, temp(Obs)==zeros(length(Obs),1)];
        end
cns=[cns, ones(1,n)*Zz{N}*ones(m,1)==1];
cns=[cns, Zz{1}*ones(m,1)==z2];
cns=[cns, Zz{N}*ones(m,1)==z1];
cns=[cns, ones(1,n)*z1==1];
cns=[cns, z1>=zeros(n,1)];
%obj=(Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1);
obj=-sum(z1(Target)); %norm(Sample(:,kkk)-z1,inf); %  (Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1); %
ops = sdpsettings('solver','mosek');
BRreach=optimize(cns,obj,ops);
Tt=value(z);
toc
% Tt(find(Tt<= 1.0000e-8))=0;
% if(sum(Tt)>=1.0000e-8)
%     Tt=Tt/sum(Tt);
% end
zz1=Tt(1:n);
for k=1:N
    Zzz{k}=reshape(Tt(n+(k-1)*n*m+1:n+k*n*m),[n,m]);
end
for k=1:N
    pi(:,k)=Zzz{k}*ones(m,1);
end



%%
figure
c4=[min(min(pi))  max(max(pi))];
nnn=1;
posfig{nnn}=subplot(2,3,nnn)
for kk=1:n
    x=pp{kk}(1);
    y=pp{kk}(2);
    xx=[x-ds/2 x+ds/2];
    yy=[y-ds/2 y+ds/2];
    imagesc(xx,yy,pi(kk,nnn))
    hold on
end
axis([0 8 0 8])
    colorbar
    caxis(c4)
  set(gca,'ydir','normal');
xlabel(['$x$',newline,'{\bf (a)} $\pi_0$'],'FontSize',16,'interpreter','latex')
ylabel('$y$','FontSize',16,'interpreter','latex')
xticks([1 3 5 7])
xticklabels({'1','2','3','4'})
yticks([1 3 5 7])
yticklabels({'1','2','3','4'})
hold on
grid off

nnn=2;
posfig{nnn}=subplot(2,3,nnn)
for kk=1:n
    x=pp{kk}(1);
    y=pp{kk}(2);
    xx=[x-ds/2 x+ds/2];
    yy=[y-ds/2 y+ds/2];
    imagesc(xx,yy,pi(kk,nnn))
    hold on
end
    colorbar
    caxis(c4)
  set(gca,'ydir','normal');
axis([0 8 0 8])
xlabel(['$x$',newline,'{\bf (b)} $\pi_1$'],'FontSize',16,'interpreter','latex')
ylabel('$y$','FontSize',16,'interpreter','latex')
xticks([1 3 5 7])
xticklabels({'1','2','3','4'})
yticks([1 3 5 7])
yticklabels({'1','2','3','4'})
hold on
grid off


nnn=3;
posfig{nnn}=subplot(2,3,nnn)
for kk=1:n
    x=pp{kk}(1);
    y=pp{kk}(2);
    xx=[x-ds/2 x+ds/2];
    yy=[y-ds/2 y+ds/2];
    imagesc(xx,yy,pi(kk,nnn))
    hold on
end
    colorbar
    caxis(c4)
  set(gca,'ydir','normal');
axis([0 8 0 8])
xlabel(['$x$',newline,'{\bf (c)} $\pi_2$'],'FontSize',16,'interpreter','latex')
ylabel('$y$','FontSize',16,'interpreter','latex')
xticks([1 3 5 7])
xticklabels({'1','2','3','4'})
yticks([1 3 5 7])
yticklabels({'1','2','3','4'})
hold on
grid off

nnn=4;
posfig{nnn}=subplot(2,3,nnn)
for kk=1:n
    x=pp{kk}(1);
    y=pp{kk}(2);
    xx=[x-ds/2 x+ds/2];
    yy=[y-ds/2 y+ds/2];
    imagesc(xx,yy,pi(kk,nnn))
    hold on
end
    colorbar
    caxis(c4)
  set(gca,'ydir','normal');
axis([0 8 0 8])
xlabel(['$x$',newline,'{\bf (d)} $\pi_3$'],'FontSize',16,'interpreter','latex')
ylabel('$y$','FontSize',16,'interpreter','latex')
xticks([1 3 5 7])
xticklabels({'1','2','3','4'})
yticks([1 3 5 7])
yticklabels({'1','2','3','4'})
hold on
grid off


nnn=5;
posfig{nnn}=subplot(2,3,nnn)
for kk=1:n
    x=pp{kk}(1);
    y=pp{kk}(2);
    xx=[x-ds/2 x+ds/2];
    yy=[y-ds/2 y+ds/2];
    imagesc(xx,yy,pi(kk,nnn))
    hold on
end

    colorbar
    caxis(c4)
  set(gca,'ydir','normal');
  axis([0 8 0 8])
xlabel(['$x$',newline,'{\bf (e)} $\pi_4$'],'FontSize',16,'interpreter','latex')
ylabel('$y$','FontSize',16,'interpreter','latex')
xticks([1 3 5 7])
xticklabels({'1','2','3','4'})
yticks([1 3 5 7])
yticklabels({'1','2','3','4'})
hold on
grid off

nnn=6;
posfig{nnn}=subplot(2,3,nnn)
for kk=1:n
    x=pp{kk}(1);
    y=pp{kk}(2);
    xx=[x-ds/2 x+ds/2];
    yy=[y-ds/2 y+ds/2];
    imagesc(xx,yy,pi(kk,nnn))
    hold on
end
    set(gca,'ydir','normal');
  axis([0 8 0 8])
xlabel(['$x$',newline,'{\bf (f)} $\pi_5$'],'FontSize',16,'interpreter','latex')
ylabel('$y$','FontSize',16,'interpreter','latex')
xticks([1 3 5 7])
xticklabels({'1','2','3','4'})
yticks([1 3 5 7])
yticklabels({'1','2','3','4'})
hold on
grid off

 pos3=get(posfig{3}, 'Position');
  pos6=get(posfig{6}, 'Position');
colormap jet
h=colorbar;
set(h, 'Position', [pos6(1)+pos6(3)+0.01 pos6(2)+0.04 pos6(3)*0.1 pos3(4)+pos3(4)+0.08])
 %ylabel(h,'infinite-horizon invariance probability')
caxis(c4)

 
subplot(2,3,1)
colorbar off
subplot(2,3,2)
colorbar off
subplot(2,3,3)
colorbar off
subplot(2,3,4)
colorbar off
subplot(2,3,5)
colorbar off
