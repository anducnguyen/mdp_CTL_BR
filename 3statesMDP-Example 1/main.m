%% BR for MDP
clear all
close all

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


%% define adminisble control action for each state
% state 1
U_admin{1}=[1 2 3];

% state 2
U_admin{2}=[1 2 3];

% state 3
U_admin{3}=[1 2 3];

%% define deterministic policies
combin_control=combvec(U_admin{:});
for i=1:size(combin_control,2)
    T_determin{i}=[];
    for j=1:n
        T_determin{i}=[T_determin{i};T(j,:,combin_control(j,i))];
    end
end


%%Define safe set and target set
% safe set
z = sdpvar(n,1);
cns=[];
cns=[cns, ones(1,n)*z==1];
cns=[cns, z>=0];
for i=1:n
    cns=[cns, -0.5<=z(i)-1/3<=0.5];
end
Aset=Polyhedron(cns);

% target set
z = sdpvar(n,1);
cns=[];
cns=[cns, ones(1,n)*z==1];
cns=[cns, z>=0];
for i=1:n
    cns=[cns, -0.1<=z(i)-1/3<=0.1];
end
Bset=Polyhedron(cns);


% obs set
z = sdpvar(n,1);
cns=[];
cns=[cns, ones(1,n)*z==1];
cns=[cns, z>=0];
cns=[cns, -0.05<=z(1)-0.1<=0.05];
cns=[cns, -0.05<=z(2)-0.7<=0.05];
ns=[cns, -0.05<=z(3)-0.2<=0.05];
Obs=Polyhedron(cns);


%% MDP model
% A 4 state MDP,
% 3 actions.
MDP.n=n;
MDP.m=m;
MDP.T=T;
MDP.T_determin_num=size(combin_control,2);
MDP.T_determin=T_determin;

% number of sample
Num_sample=50;
Iter_max=5;

%% simplex in 3-D
xx=[1 0 0 1
    0 1 0 0
    0 0 1 0];
%% plot env
figure
plot3(xx(1,:),xx(2,:),xx(3,:),'-k','LineWidth',1.2)
hold on
Obs.plot('color','blue','shade',0.5)
hold on
Bset.plot('color','red','shade',0.5)
hold on

xlabel('$\pi(x_1)$','FontSize',14,'interpreter','latex')
ylabel('$\pi(x_2)$','FontSize',14,'interpreter','latex')
zlabel('$\pi(x_3)$','FontSize',14,'interpreter','latex')
 set(gca,'FontSize',14)


%% existential negation  not Obs until Bset

% complement of Obs
elpssion=0.001;
Com_set={};
for i=1:length(Obs.b)
    z = sdpvar(n,1);
    cns=[];
    Aicom=Obs.A(i,:);
    bicom=Obs.b(i);
    cns=[cns, ones(1,n)*z==1];
    cns=[cns, z>=0];
    cns=[cns, Aicom*z>=bicom+elpssion];
    itemset=Polyhedron(cns);
    if ~isempty(itemset.V)
        Com_set=[Com_set itemset];
    end
end

% figure
% for i=1:length(Com_set)
%     Com_set(i).plot
%     hold on
% end

Satexneguntil=[];
for i=1:length(Com_set)
    itemset=existentialuntil(MDP,Com_set(i),Bset,Num_sample);
    if size(itemset,2)>=n-1
        Satexneguntil=[Satexneguntil {itemset}];
    end
end

%Plot

for i=1:length(Satexneguntil)
    figure
    plot3(xx(1,:),xx(2,:),xx(3,:),'-k','LineWidth',1.2)
    hold on
    sampleSatexneguntil{i}=find_convexhull(Satexneguntil{i}{end});
    SSatexneguntil{i} = Polyhedron('V', sampleSatexneguntil{i});
    SSatexneguntil{i}.plot('color', 'cyan','shade',0.5);
    hold on
    Obs.plot('color','blue','shade',0.5)
    hold on
    plot3(Satexneguntil{i}{end}(:,1),Satexneguntil{i}{end}(:,2),Satexneguntil{i}{end}(:,3),'pm','MarkerSize',10,'MarkerFaceColor','m')
    hold on
    xlabel('$\pi(x_1)$','FontSize',14,'interpreter','latex')
    ylabel('$\pi(x_2)$','FontSize',14,'interpreter','latex')
    zlabel('$\pi(x_3)$','FontSize',14,'interpreter','latex')
    set(gca,'FontSize',14)
end


%% forall negation next neg Obs
%complement of Obs
elpssion=0.001;
Com_set={};
for i=1:length(Obs.b)
    z = sdpvar(n,1);
    cns=[];
    Aicom=Obs.A(i,:);
    bicom=Obs.b(i);
    cns=[cns, ones(1,n)*z==1];
    cns=[cns, z>=0];
    cns=[cns, Aicom*z>=bicom+elpssion];
    itemset=Polyhedron(cns);
    if ~isempty(itemset.V)
        Com_set=[Com_set itemset];
    end
end

% figure
% for i=1:length(Com_set)
%     Com_set(i).plot
%     hold on
% end

Satforallnegnext=[];
for i=1:length(Com_set)
    itemset1=forallnext(MDP,Com_set(i),Num_sample);
    if size(itemset1,2)>=n-1
        Satforallnegnext=[Satforallnegnext {itemset1}];
    end
end

%Plot

for i=1:length(Satforallnegnext)
    figure
    plot3(xx(1,:),xx(2,:),xx(3,:),'-k','LineWidth',1.2)
    hold on
    sampleSatforallnegnext{i}=find_convexhull(Satforallnegnext{i});
    Sset{i} = Polyhedron('V', sampleSatforallnegnext{i});
    Sset{i}.plot('color', 'cyan','shade',0.5);
    hold on
    Obs.plot('color','blue','shade',0.5)
    hold on
     xlabel('$\pi(x_1)$','FontSize',14,'interpreter','latex')
    ylabel('$\pi(x_2)$','FontSize',14,'interpreter','latex')
    zlabel('$\pi(x_3)$','FontSize',14,'interpreter','latex')
    set(gca,'FontSize',14)
    hold on
    plot3(Satforallnegnext{i}(:,1),Satforallnegnext{i}(:,2),Satforallnegnext{i}(:,3),'pm','MarkerSize',10,'MarkerFaceColor','m')
    hold on
end

