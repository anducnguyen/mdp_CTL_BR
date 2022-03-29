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


%% Equilibrium set
 E=EquiSet(MDP);
 
%%number of sample
FR_Sample_num=15;
 for i=1:FR_Sample_num
    yalmip('clear')
    z=sdpvar(MDP.n,1);  
    cns=[];
    cns=[cns,E.A*z<=E.b];
    cns=[cns, z(:)>=zeros(MDP.n,1)];
    cns=[cns, ones(1,MDP.n)*z==1];
     c=   sign(rand(1,MDP.n)-0.5)+1;
    %   c=zeros(1,MDP.n); %sign(rand(1,MDP.n)-0.5)+1;
      ops = sdpsettings('solver','quadprog');
      optimize(cns,sign(rand-0.5)*rand(1,MDP.n)*z,ops);
    %% feasibility check
     FR_sample(i,:)=value(z)';
end

%% forward reach
 figure
 Reach_E=Reach(MDP,E);
 Reach_E.plot('color', 'red')
 hold on
 
  sample_FR=[];
 for i=1:FR_Sample_num
    sample_FR=[sample_FR;Approx_Reach(MDP, FR_sample(i,:)')];
 end
 
%  sample_FR=[];
%  for i=1:size(E.V,1)
%   %   temp=rand(1,size(E.V,1));
%      sample(i,:)=E.V(i,:);
%       sample_FR=[sample_FR;Approx_Reach(MDP, sample(i,:)')];
%  end
 
 %for i=1:size(sample_FR,1)
  plot3(sample_FR(:,1),sample_FR(:,2),sample_FR(:,3),'k*')
 %hold on
 %end
  [k1,av1] = convhull(sample_FR(:,1),sample_FR(:,2),sample_FR(:,3));
 trisurf(k1,sample_FR(:,1),sample_FR(:,2),sample_FR(:,3),'FaceColor','cyan')
 
xlabel('$\pi(1)$','FontSize',12,'interpreter','latex')
ylabel('$\pi(2)$','FontSize',12,'interpreter','latex')
zlabel('$\pi(3)$','FontSize',12,'interpreter','latex')

% % %% check Equilibrium 
% % Q=CheckEqui(MDP,E.V(2,:)');

% 
 %% backward 
%  
BR_sample=FR_sample;
BR_Sample_num=40;
for i=1:BR_Sample_num
    temp=rand(1,FR_Sample_num);
    temp=temp/sum(temp);
     BR_sample(i+FR_Sample_num,:)=temp*FR_sample;
end

 figure
 Control_E=Control(MDP,E);
Control_E.plot('color', 'red')
 hold on
 sample_BR=[];
 for i=1:FR_Sample_num+BR_Sample_num
      sample_BR=[sample_BR;Approx_Control(MDP, BR_sample(i,:)')];
 end
%  
%  sample_BR=[];
%  for i=1:size(E.V,1)
%   %   temp=rand(1,size(E.V,1));
%      sample(i,:)=E.V(i,:);
%       sample_BR=[sample_BR;Approx_Control(MDP, sample(i,:)')];
%  end
 
%for i=1:size(sample_FR,1)
   plot3(sample_BR(:,1),sample_BR(:,2),sample_BR(:,3),'k*')
  hold on
%end
 
 [k1,av1] = convhull(sample_BR(:,1),sample_BR(:,2),sample_BR(:,3));
  trisurf(k1,sample_BR(:,1),sample_BR(:,2),sample_BR(:,3),'FaceColor','cyan')
 
xlabel('$\pi(1)$','FontSize',12,'interpreter','latex')
ylabel('$\pi(2)$','FontSize',12,'interpreter','latex')
zlabel('$\pi(3)$','FontSize',12,'interpreter','latex')
