clc
clear all
close all

%%%% number of the grid
Nums1=16;
Numu=4;

%% number of state 
n=Nums1;

%% number of action
m=Numu;

T=transition_collision(Nums1,Numu);




for iii=1:Numu
    for jjj1=1:Nums1
          sumT(jjj1,iii)=sum(T(jjj1,:,iii));
    end
end



%% construnct MDP
MDP.n=n;
MDP.m=m;
MDP.T=T;
Target=[7 8]';
Obs=[10 11]';
%  %[pro_DoA,maxPro_DoA,Horizon_DoA,pro_RAV,maxPro_RAV,Horizon_RAV]=True_value(MDP,Target,Obs);
% 
% 
% 
% % set A={7,23,39,55}
% % Backward reachable set
%  N=20;
% % initial sample
% BR_Sample_num=30;
% epsilon=0.9;
% 
% 
% for i=1:BR_Sample_num
%     yalmip('clear')
%     z=sdpvar(MDP.n,1);  
%     cns=[];
%      cns=[cns, z(:)>=0];
%   cns=[cns, sum(z(:))==1];
%      cns=[cns, sum(z(Target))>=epsilon];
%    c=3*rand(n,1)-1.5;
%    c(end)=1-sum(c(1:end-1));
%  obj= (c-z)'*(c-z);
%     ops =   sdpsettings('solver','sedumi','sedumi.eps',1e-12,'sedumi.maxiter',500,'sedumi.numtol',1e-12);
%     optimize(cns,obj,ops);
%     Vert_BR{1}(i,:)=value(z)';
% end
% 
% for i=1:MDP.n
%      yalmip('clear')
%     z=sdpvar(MDP.n,1);  
%     cns=[];
%      cns=[cns, z(:)>=0];
%   cns=[cns, sum(z(:))==1];
%     cns=[cns, sum(z(Target))>=epsilon];
%    c=zeros(MDP.n,1);
%    c(i)=-1;
%  obj= c'*z;
%     ops =   sdpsettings('solver','sedumi','sedumi.eps',1e-12,'sedumi.maxiter',500,'sedumi.numtol',1e-12);
%     optimize(cns,obj,ops);
%     Vert_BR{1}(i+BR_Sample_num,:)=value(z)';
% end
% 
% % 
% % Vert_BR{1}(find(Vert_BR{1}<= 1.0000e-8))=0;
% %     for kkk=1:size(Vert_BR{1},1)
% %         Vert_BR{1}(kkk,:)=Vert_BR{1}(kkk,:)/sum(Vert_BR{1}(kkk,:));
% %     end
%     
% 
% % Vert_BRunion=[];
% % for i=1:1
% %     Vert_BRunion=[Vert_BRunion;Vert_BR{i}];
% % end
% 
% %Vert_BRunion=uniquetol(Vert_BRunion,0.05,'ByRows',true);
% 
% figbar= waitbar(0,'Domain of Acctraction');
% 
% %Approx_C{i}=Polyhedron('V', Vert_BR{1});
%   for i=1:N
%    %   Y = randsample(size(Vert_BRunion,1),BR_Sample_num);
%     sample_BR{i+1}=Approx_Control(MDP,Vert_BR{i},BR_Sample_num,Target);
%     sample_BR{i+1}(find(sample_BR{i+1}<= 1.0000e-8))=0;
%     for kkk=1:size(sample_BR{i+1},1)
%         sample_BR{i+1}(kkk,:)=sample_BR{i+1}(kkk,:)/sum(sample_BR{i+1}(kkk,:));
%     end
%      sample_BR{i+1}=uniquetol(sample_BR{i+1},0.05,'ByRows',true);
%     Vert_BR{i+1}=sample_BR{i+1};
%   %  Vert_BRunion=[Vert_BRunion;Vert_BR{i+1};];
% %    Vert_BRunion=uniquetol(Vert_BRunion,0.05,'ByRows',true);
%    % Approx_C{i+1}= Polyhedron('V', Vert_BR{i+1});
%     waitbar(i/N,figbar,'Domain of Acctraction')
%   end
%   
  
%   %% reach-avoid
 N=20;
epsilon=0.80;

%% obstacle set B=[8 10 11 24 26 27 40  42 43 56 58 59] 

tic
%% initial sample
BR_Sample_num=30;
Vert_BR{1}=[];


for i=1:BR_Sample_num
    yalmip('clear')
    z=sdpvar(MDP.n,1);  
    cns=[];
     cns=[cns, z(:)>=0];
  cns=[cns, sum(z(:))==1];
    cns=[cns, sum(z(Target))>=epsilon];
     cns=[cns, z(Obs)==zeros(length(Obs),1)];
   c=3*rand(n,1)-1.5;
   c(end)=1-sum(c(1:end-1));
 obj= (c-z)'*(c-z);
    ops =   sdpsettings('solver','sedumi','sedumi.eps',1e-12,'sedumi.maxiter',500,'sedumi.numtol',1e-12);
    optimize(cns,obj,ops);
    Vert_BR{1}(i,:)=value(z)';
end

for i=1:MDP.n
     yalmip('clear')
    z=sdpvar(MDP.n,1);  
    cns=[];
     cns=[cns, z(:)>=0];
  cns=[cns, sum(z(:))==1];
    cns=[cns, sum(z(Target))>=epsilon];
     cns=[cns, z(Obs)==zeros(length(Obs),1)];
   c=zeros(MDP.n,1);
   c(i)=-1;
 obj= c'*z;
    ops =   sdpsettings('solver','sedumi','sedumi.eps',1e-12,'sedumi.maxiter',500,'sedumi.numtol',1e-12);
    optimize(cns,obj,ops);
    Vert_BR{1}(i+BR_Sample_num,:)=value(z)';
end

Vert_BR{1}(find(Vert_BR{1}<= 1.0000e-8))=0;
    for kkk=1:size(Vert_BR{1},1)
        Vert_BR{1}(kkk,:)=Vert_BR{1}(kkk,:)/sum(Vert_BR{1}(kkk,:));
    end
    
%Approx_C{i}=Polyhedron('V', Vert_BR{1});
%figbarreach= waitbar(0,'ReachAvoid');
  for i=1:N
    sample_BR{i+1}=Approx_Reach_Avoid(MDP,Vert_BR{i},BR_Sample_num,Obs,Target);
    sample_BR{i+1}(find(sample_BR{i+1}<= 1.0000e-8))=0;
    for kkk=1:size(sample_BR{i+1},1)
        sample_BR{i+1}(kkk,:)=sample_BR{i+1}(kkk,:)/sum(sample_BR{i+1}(kkk,:));
    end
     sample_BR{i+1}=uniquetol(sample_BR{i+1},0.01,'ByRows',true);
    
%      [k1,av1] = convhulln(sample_BR{i+1});
%     temp=reshape(k1,size(k1,1)*size(k1,2),1) ;
%     ind=unique(temp);
    Vert_BR{i+1}=sample_BR{i+1}; %find_convexhull(sample_BR{i+1});
    %Approx_C{i+1}= Polyhedron('V', Vert_BR{i+1});
%waitbar(i/N,figbarreach,'ReachAvoid');
  end
  
  toc

