clear all
close all
clc
format longEng

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
T(2,2,2)=1;
T(3,2,2)=0.5;
T(3,3,2)=0.5;

% action 3
T(1,1,3)=0.2; 
T(1,2,3)=0.7;
T(1,3,3)=0.1;
T(2,1,3)=0.6; 
T(2,3,3)=0.4;
T(3,3,3)=1;

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

%% Equilibrium set
 E=EquiSet(MDP);
%S.plot('color', 'white')
%hold on
E.plot('color', 'red')
xlabel('$\pi(1)$','FontSize',12,'interpreter','latex')
ylabel('$\pi(2)$','FontSize',12,'interpreter','latex')
zlabel('$\pi(3)$','FontSize',12,'interpreter','latex')


% %% check Equilibrium 
% Q=CheckEqui(MDP,[0.6;0;0.4]);

%% reachable set from P_X
N=10;
z = sdpvar(n,1);
 cns=[];
 cns=[cns, z(:)>=0];
 cns=[cns, sum(z(:))==1];
 P_X=Polyhedron(cns);
 Theta_plus{1}=P_X;
 for i=1:N
Theta_plus{i+1}=Reach(MDP,  Theta_plus{i});
 end 
 
%  for i=1:N+1
%     figure
%     Theta_plus{i}.plot('color', 'blue')
%   xlabel('$\pi(1)$','FontSize',12,'interpreter','latex')
%   ylabel('$\pi(2)$','FontSize',12,'interpreter','latex')
%   zlabel('$\pi(3)$','FontSize',12,'interpreter','latex')
%   %  
%  end


 figure
S.plot('color', 'blue');
hold on
Theta_plus{end}.plot('color', 'cyan')
hold on
 E.plot('color', 'red')
 hold on
  alpha(0.6)
hold on
 xlabel('$\pi(1)$','FontSize',12,'interpreter','latex')
  ylabel('$\pi(2)$','FontSize',12,'interpreter','latex')
  zlabel('$\pi(3)$','FontSize',12,'interpreter','latex')
  
% %% reachable set from P_X
%  z = sdpvar(n,1);
%  cns=[];
%  cns=[cns, z(:)>=0];
%  cns=[cns, sum(z(:))==1];
%  P_X=Polyhedron(cns);
%  
% Theta_plus=Reach(MDP, P_X);
% figure
%   Theta_plus.plot('color', 'blue')
%   
% Theta_minus=Control(MDP, P_X);
% figure
% Theta_minus.plot('color', 'blue')
% 
% 
% %% Reachable set
% % horizon 
% N=5;
% % z = sdpvar(n,1);
% % cns=[];
% % cns=[cns, [1;0;0]<=z<=[1;0;0]];
% % R{1}=Polyhedron(cns);
% 
% R{1}=E;
% for i=1:N
%     R{i+1}=Reach(MDP,R{i});
% end
% 
% for i=1:N+1
%     figure
%     R{i}.plot('color', 'red')
%   xlabel('$\pi(1)$','FontSize',12,'interpreter','latex')
%   ylabel('$\pi(2)$','FontSize',12,'interpreter','latex')
%   zlabel('$\pi(3)$','FontSize',12,'interpreter','latex')
% end
% for i=1:N
%    Rcontain(i)=R{i+1}.contains(R{i});
% end
% % 
% % %% Controllable set
% % % horizon 
% % N=5;
% % z = sdpvar(n,1);
% % cns=[];
% % cns=[cns, [1;0;0]<=z<=[1;0;0]];
% % C{1}=Polyhedron(cns);
% % %C{1}=E;
% % for i=1:N
% %     C{i+1}=Control(MDP,C{i});
% % end
% % 
% % for i=1:N+1
% %     figure
% %     C{i}.plot('color', 'red')
% %   xlabel('$\pi(1)$','FontSize',12,'interpreter','latex')
% %   ylabel('$\pi(2)$','FontSize',12,'interpreter','latex')
% %   zlabel('$\pi(3)$','FontSize',12,'interpreter','latex')
% % end
% % 
% % for i=1:N
% %    Ccontain(i)=C{i+1}.contains(C{i});
% % end