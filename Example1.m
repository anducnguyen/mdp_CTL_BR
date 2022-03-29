clear all
close all
clc

%% number of state 
n=3;

%% number of action
m=3;

%% transition matrix
%%T(i,j,k)   transition from state i to state j under action k
% action 1
T(1,1,1)=1; 
T(2,1,1)=0.9;
T(2,2,1)=0.1;
T(3,1,1)=0.2;
T(3,2,1)=0.7;
T(3,3,1)=0.1;

% action 2
T(1,1,2)=0.9; 
T(1,2,2)=0.1;
T(2,1,2)=0.2;
T(2,2,2)=0.7;
T(2,3,2)=0.1;
T(3,2,2)=0.5;
T(3,3,2)=0.5;

% action 3
T(1,1,3)=0.2; 
T(1,2,3)=0.7;
T(1,3,3)=0.1;
T(2,1,3)=0.6; 
T(2,3,3)=0.4;
T(3,1,3)=0.5; 
T(3,2,3)=0.3;
T(3,3,3)=0.2;

%% construnct MDP
MDP.n=n;
MDP.m=m;
MDP.T=T;
%% simplex
z = sdpvar(n,1);
cns=[];
cns=[cns, ones(1,n)*z==1];
cns=[cns, z>=0];
S=Polyhedron(cns);

% 
% 
%   
%   
% 
% 
% %% Forward Reachable set
% % horizon 
% N=5;
% z = sdpvar(n,1);
% cns=[];
% cns=[cns, [0.1;0.2;0.7]<=z<=[0.1;0.2;0.7]];
% R{1}=Polyhedron(cns);
% pi0=[0.1;0.2;0.7];
% for i=1:N
%     R{i+1}=Reach(MDP,R{i});
% end
% 
% 
% figure
% subplot(1,4,1)
% S.plot('FaceColor', 'none')
% hold on
%  R{2}.plot('color', 'red')
%     hold on
%  alpha(0.6)
%   hold on
% plot3(pi0(1),pi0(2), pi0(3) ,'*k','Marker','*','MarkerFaceColor','black','MarkerSize',5)
%  hold on
%  xlabel(['$\pi(1)$',newline,'\bf(a)'],'FontSize',12,'interpreter','latex')
%   ylabel('$\pi(2)$','FontSize',12,'interpreter','latex')
%   zlabel('$\pi(3)$','FontSize',12,'interpreter','latex')
%   
%  subplot(1,4,2)
% S.plot('color', 'blue')
% hold on
%  R{3}.plot('color', 'red')
%     hold on
%  alpha(0.6)
%  hold on
% plot3(pi0(1),pi0(2), pi0(3) ,'*k','Marker','*','MarkerFaceColor','black','MarkerSize',5)
%  hold on
%   xlabel(['$\pi(1)$',newline,'\bf(b)'],'FontSize',12,'interpreter','latex')
%   ylabel('$\pi(2)$','FontSize',12,'interpreter','latex')
%   zlabel('$\pi(3)$','FontSize',12,'interpreter','latex')
%  
%  subplot(1,4,3)
%  S.plot('color', 'blue')
% hold on
%  R{4}.plot('color', 'red')
%    hold on
%  alpha(0.6)
%  hold on
% plot3(pi0(1),pi0(2), pi0(3) ,'*k','Marker','*','MarkerFaceColor','black','MarkerSize',5)
%  hold on
%   xlabel(['$\pi(1)$',newline,'\bf(c)'],'FontSize',12,'interpreter','latex')
%   ylabel('$\pi(2)$','FontSize',12,'interpreter','latex')
%   zlabel('$\pi(3)$','FontSize',12,'interpreter','latex')
%  
%  subplot(1,4,4)
%   S.plot('color', 'blue')
% hold on
%  R{6}.plot('color', 'red')
%  hold on
%  alpha(0.6)
%  hold on
% plot3(pi0(1),pi0(2), pi0(3) ,'*k','Marker','*','MarkerFaceColor','black','MarkerSize',5)
%  hold on
%  xlabel(['$\pi(1)$',newline,'\bf(d)'],'FontSize',12,'interpreter','latex')
%   ylabel('$\pi(2)$','FontSize',12,'interpreter','latex')
%   zlabel('$\pi(3)$','FontSize',12,'interpreter','latex')
%  
% 
%   
%  
% 
% %% Apporximate Forward Reachable set
% N=1;
% FR_Num_sample=20;
% pi0=[0.1;0.2;0.7];
% FR_Sample_num(1)=1;
% FR_sample{1}(1,:)=pi0';
% Vert_FR{1}=FR_sample{1};
% Approx_R{i}=Polyhedron('V', Vert_FR{1});
%   for i=1:N
%       sample_FR{i+1}=[];
%     for nnn=1:FR_Sample_num(i)
%     sample_FR{i+1}=[sample_FR{i+1};Approx_Reach(MDP, FR_sample{i}(nnn,:)',FR_Num_sample)];
%     end
%     sample_FR{i+1}=uniquetol(sample_FR{i+1},0.05,'ByRows',true);
%      [k1,av1] = convhull(sample_FR{i+1}(:,1),sample_FR{i+1}(:,2),sample_FR{i+1}(:,3));
%     temp=reshape(k1,size(k1,1)*size(k1,2),1) ;
%     ind=unique(temp);
%     FR_Sample_num(i+1)=length(ind);
%     Vert_FR{i+1}=sample_FR{i+1}(ind,:);
%     FR_sample{i+1}=Vert_FR{i+1};
%     Approx_R{i+1}= Polyhedron('V', Vert_FR{i+1});
%   end
%   
%   figure
% %subplot(1,4,1)
% S.plot('color', 'white')
% hold on
%   R{2}.plot('color', 'red')
%   hold on
% Approx_R{2}.plot('color', 'cyan')
% hold on
%  alpha(0.6)
%   hold on
% plot3(pi0(1),pi0(2), pi0(3) ,'*k','Marker','*','MarkerFaceColor','black','MarkerSize',5)
% hold on
% plot3(sample_FR{2}(:,1),sample_FR{2}(:,2),sample_FR{2}(:,3),'*k','Marker','o','MarkerFaceColor','blue','MarkerSize',5)
%  hold on
%  xlabel(['$\pi(1)$',newline,'\bf(a)'],'FontSize',12,'interpreter','latex')
%   ylabel('$\pi(2)$','FontSize',12,'interpreter','latex')
%   zlabel('$\pi(3)$','FontSize',12,'interpreter','latex')
%   
% %  subplot(1,4,2)
% % S.plot('color', 'white')
% % hold on
% %   R{3}.plot('color', 'red')
% %      hold on
% % Approx_R{3}.plot('color', 'cyan')
% % hold on
% %  alpha(0.6)
% %   hold on
% % plot3(pi0(1),pi0(2), pi0(3) ,'*k','Marker','*','MarkerFaceColor','black','MarkerSize',5)
% % hold on
% % plot3(sample_FR{3}(:,1),sample_FR{3}(:,2),sample_FR{3}(:,3),'*k','Marker','o','MarkerFaceColor','blue','MarkerSize',5)
% %  hold on
% %   xlabel(['$\pi(1)$',newline,'\bf(b)'],'FontSize',12,'interpreter','latex')
% %   ylabel('$\pi(2)$','FontSize',12,'interpreter','latex')
% %   zlabel('$\pi(3)$','FontSize',12,'interpreter','latex')
% %  
% %  subplot(1,4,3)
% %  S.plot('color', 'white')
% % hold on
% %   R{4}.plot('color', 'red')
% %   hold on
% % Approx_R{4}.plot('color', 'cyan')
% % hold on
% %  alpha(0.6)
% %   hold on
% % plot3(pi0(1),pi0(2), pi0(3) ,'*k','Marker','*','MarkerFaceColor','black','MarkerSize',5)
% % hold on
% % plot3(sample_FR{4}(:,1),sample_FR{4}(:,2),sample_FR{4}(:,3),'*k','Marker','o','MarkerFaceColor','blue','MarkerSize',5)
% %  hold on
% %   xlabel(['$\pi(1)$',newline,'\bf(c)'],'FontSize',12,'interpreter','latex')
% %   ylabel('$\pi(2)$','FontSize',12,'interpreter','latex')
% %   zlabel('$\pi(3)$','FontSize',12,'interpreter','latex')
% %  
% %  subplot(1,4,4)
% %   S.plot('color', 'white')
% % hold on
% %   R{6}.plot('color', 'red')
% %   hold on
% % Approx_R{6}.plot('color', 'cyan')
% % hold on
% %  alpha(0.6)
% %   hold on
% % plot3(pi0(1),pi0(2), pi0(3) ,'*k','Marker','*','MarkerFaceColor','black','MarkerSize',5)
% % hold on
% % plot3(sample_FR{6}(:,1),sample_FR{6}(:,2),sample_FR{6}(:,3),'*k','Marker','o','MarkerFaceColor','blue','MarkerSize',5)
% %  hold on
% %  xlabel(['$\pi(1)$',newline,'\bf(d)'],'FontSize',12,'interpreter','latex')
% %   ylabel('$\pi(2)$','FontSize',12,'interpreter','latex')
% %   zlabel('$\pi(3)$','FontSize',12,'interpreter','latex')
% %  
% 
% 
% 
% 
%  %% Backward reachable set
%  N=5;
%  z = sdpvar(n,1);
%  cns=[];
% %cns=[cns,[0.5;0.2;0.3]<=z<=[0.5;0.2;0.3]];
% cns=[cns,[0.5;0.2;0.3]<=z<=[0.5;0.2;0.3]];
% 
%  C{1}=Polyhedron(cns);
%  pi0=[0.5;0.2;0.3];
% for i=1:N
%     C{i+1}=Control(MDP,C{i});
% end
% 
% 
% 
% 
% figure
% subplot(1,2,1)
% S.plot('color', 'blue');
% hold on
%  C{2}.plot('color', 'red')
%    hold on
%   alpha(0.6)
%  hold on
% plot3(pi0(1),pi0(2), pi0(3) ,'*k','Marker','*','MarkerFaceColor','black','MarkerSize',5)
%  hold on
%  xlabel(['$\pi(1)$',newline,'\bf(a)'],'FontSize',12,'interpreter','latex')
%   ylabel('$\pi(2)$','FontSize',12,'interpreter','latex')
%   zlabel('$\pi(3)$','FontSize',12,'interpreter','latex')
%   
%  subplot(1,2,2)
% S.plot('color', 'blue')
% hold on
%  C{3}.plot('color', 'red')
%  alpha(0.6)
%  hold on
% plot3(pi0(1),pi0(2), pi0(3) ,'*k','Marker','*','MarkerFaceColor','black','MarkerSize',5)
%  hold on
%   xlabel(['$\pi(1)$',newline,'\bf(b)'],'FontSize',12,'interpreter','latex')
%   ylabel('$\pi(2)$','FontSize',12,'interpreter','latex')
%   zlabel('$\pi(3)$','FontSize',12,'interpreter','latex')
%  
%   
%  %% Apporximate Backward Reachable set
% N=1;
% BR_Num_sample=40;
% pi0=[0.5;0.2;0.3];
% BR_Sample_num(1)=1;
% BR_sample{1}(1,:)=pi0';
% Vert_BR{1}=BR_sample{1};
% Approx_C{i}=Polyhedron('V', Vert_BR{1});
%   for i=1:N
%       sample_BR{i+1}=[];
%     for nnn=1:BR_Sample_num(i)
%     sample_BR{i+1}=[sample_BR{i+1};Approx_Control(MDP,BR_sample{i}(nnn,:)',BR_Num_sample)];
%     end
%     sample_BR{i+1}=uniquetol(sample_BR{i+1},0.05,'ByRows',true);
%      [k1,av1] = convhull(sample_BR{i+1}(:,1),sample_BR{i+1}(:,2),sample_BR{i+1}(:,3));
%     temp=reshape(k1,size(k1,1)*size(k1,2),1) ;
%     ind=unique(temp);
%     BR_Sample_num(i+1)=length(ind);
%     Vert_BR{i+1}=sample_BR{i+1}(ind,:);
%     BR_sample{i+1}=Vert_BR{i+1};
%     Approx_C{i+1}= Polyhedron('V', Vert_BR{i+1});
%   end
%   
%  
%   figure
% subplot(1,2,1)
% S.plot('color', 'blue');
% hold on
%  C{2}.plot('color', 'red')
%    hold on
%     Approx_C{2}.plot('color', 'cyan')
% hold on
%   alpha(0.6)
%  hold on
% plot3(pi0(1),pi0(2), pi0(3) ,'*k','Marker','*','MarkerFaceColor','black','MarkerSize',5)
%  hold on
%  plot3(sample_BR{2}(:,1),sample_BR{2}(:,2),sample_BR{2}(:,3),'*k','Marker','o','MarkerFaceColor','blue','MarkerSize',5)
%  hold on
%  xlabel(['$\pi(1)$',newline,'\bf(a)'],'FontSize',12,'interpreter','latex')
%   ylabel('$\pi(2)$','FontSize',12,'interpreter','latex')
%   zlabel('$\pi(3)$','FontSize',12,'interpreter','latex')
%   
%  subplot(1,2,2)
% % S.plot('color', 'blue')
% % hold on
%  C{3}.plot('color', 'red')
%  hold on
%  Approx_C{3}.plot('color', 'cyan')
% hold on
%  alpha(0.6)
%  hold on
% plot3(pi0(1),pi0(2), pi0(3) ,'*k','Marker','*','MarkerFaceColor','black','MarkerSize',5)
%  hold on
%   plot3(sample_BR{3}(:,1),sample_BR{3}(:,2),sample_BR{3}(:,3),'*k','Marker','o','MarkerFaceColor','blue','MarkerSize',5)
%  hold on
%   xlabel(['$\pi(1)$',newline,'\bf(b)'],'FontSize',12,'interpreter','latex')
%   ylabel('$\pi(2)$','FontSize',12,'interpreter','latex')
%   zlabel('$\pi(3)$','FontSize',12,'interpreter','latex')
%  
% %    subplot(1,3,3)
% % S.plot('color', 'blue')
% % hold on
% %  C{4}.plot('color', 'red')
% %  hold on
% %  Approx_C{4}.plot('color', 'cyan')
% % hold on
% %  alpha(0.6)
% %  hold on
% % plot3(pi0(1),pi0(2), pi0(3) ,'*k','Marker','*','MarkerFaceColor','black','MarkerSize',5)
% %  hold on
% %   plot3(sample_BR{4}(:,1),sample_BR{4}(:,2),sample_BR{4}(:,3),'*k','Marker','o','MarkerFaceColor','blue','MarkerSize',5)
% %  hold on
% %   xlabel(['$\pi(1)$',newline,'\bf(b)'],'FontSize',12,'interpreter','latex')
% %   ylabel('$\pi(2)$','FontSize',12,'interpreter','latex')
% %   zlabel('$\pi(3)$','FontSize',12,'interpreter','latex')
%   
% %    subplot(1,4,4)
% % S.plot('color', 'blue')
% % hold on
% %  C{6}.plot('color', 'red')
% %  hold on
% %  Approx_C{6}.plot('color', 'cyan')
% % hold on
% %  alpha(0.6)
% %  hold on
% % plot3(pi0(1),pi0(2), pi0(3) ,'*k','Marker','*','MarkerFaceColor','black','MarkerSize',5)
% %  hold on
% %   plot3(sample_BR{6}(:,1),sample_BR{6}(:,2),sample_BR{6}(:,3),'*k','Marker','o','MarkerFaceColor','blue','MarkerSize',5)
% %  hold on
% %   xlabel(['$\pi(1)$',newline,'\bf(b)'],'FontSize',12,'interpreter','latex')
% %   ylabel('$\pi(2)$','FontSize',12,'interpreter','latex')
% %   zlabel('$\pi(3)$','FontSize',12,'interpreter','latex')
  
  

 %% Invariant set
 
 z = sdpvar(n,1);
 cns=[];
cns=[cns,z>=0];
cns=[cns,1<=ones(1,n)*z<=1];
cns=[cns,[0 0 1]*z>=0.2];
cns=[cns,[0 2 1]*z<=1];
Safeset=Polyhedron(cns);
Inter_inv{1}=Safeset;
err=1;
i=1;
while(err>10^-5)
    temp=Control(MDP,Inter_inv{i});
    Inter_inv{i+1}= intersect(temp,Inter_inv{i});
    err=abs(Inter_inv{i+1}.volume-Inter_inv{i}.volume);
    i=i+1;
end
Invset=Inter_inv{end};
[Invset,sol]= Invset.minHRep();

pi(:,1)=[0 0 1]';

for iii=1:10
    yalmip('clear')
z = sdpvar(n+n*m,1);
z1=z(1:n);
Z1=reshape(z(n+1:n+n*m),[n,m]);
cns=[];
cns=[cns, 1<=ones(1,n)*Z1*ones(m,1)<=1];
cns=[cns, Z1>=0];
cns=[cns, pi(:,iii)<=Z1*ones(m,1)<=pi(:,iii)];
for i=1:n
   cns=[cns, z1(i)<=ones(1,n)*(reshape(T(:,i,:),[n,m]).*Z1)*ones(m,1)<=z1(i)];
end
cns=[cns, Invset.A*z1<=Invset.b];
cns=[cns, Invset.be<=Invset.Ae*z1<=Invset.be];
Ce=Polyhedron(cns);
C=Ce.projection(1:n);
[C,sol]= C.minHRep();
Num_vert=size(C.V,1);
lamada=rand(1,Num_vert);
lamada=lamada/sum(lamada);
pi(:,iii+1)=(lamada*C.V)';
end


  
figure
plot(S,'color', 'blue');
hold on
plot(Safeset,'color', 'cyan')
   hold on
 plot(Invset,'color', 'red')
   hold on
  alpha(0.6)
 hold on
  plot3(pi(1,:),pi(2,:), pi(3,:) , '-ok','LineWidth',1)
hold on
 plot3(pi(1,1),pi(2,1), pi(3,1) ,'*k','Marker','*','MarkerFaceColor','black','MarkerSize',5)
 xlabel('$\pi(1)$','FontSize',12,'interpreter','latex')
  ylabel('$\pi(2)$','FontSize',12,'interpreter','latex')
  zlabel('$\pi(3)$','FontSize',12,'interpreter','latex')
  
 
  figure
% S.plot('color', 'blue');
% hold on
 plot(Safeset,'color', 'cyan')
   hold on
 plot(Invset,'color', 'red')
   hold on
  alpha(0.6)
 hold on
  plot3(pi(1,:),pi(2,:), pi(3,:) , '-ok','LineWidth',1)
hold on
 plot3(pi(1,1),pi(2,1), pi(3,1) ,'*k','Marker','*','MarkerFaceColor','black','MarkerSize',5)
 xlabel('$\pi(1)$','FontSize',12,'interpreter','latex')
  ylabel('$\pi(2)$','FontSize',12,'interpreter','latex')
  zlabel('$\pi(3)$','FontSize',12,'interpreter','latex')
  
