function zz1=Approx_Reach_Avoid(S,ZZ2,Num_sample,Obs,Target)
n=S.n;
m=S.m;
T=S.T;
zz1=[];
Num_vert=size(ZZ2,1);
    for kkk=1:Num_sample
        Sample(:,kkk)=3*rand(n,1)-1.5;
        Sample(end,kkk)=1-sum(Sample(1:end-1,kkk));
    end
    for kkk=1:Num_sample
        yalmip('clear')
    z = sdpvar(n+n+n*m+Num_vert,1);
    z1=z(1:n);
    z2=z(n+1:n+n);
    Z1=reshape(z(n+n+1:n+n+n*m),[n,m]);
    alpha=z(n+n+n*m+1:end);
    
    cns=[];
    cns=[cns, ones(1,n)*Z1*ones(m,1)==1];
    cns=[cns, z1(:)>=zeros(n,1)];
    cns=[cns, ones(1,n)*z1(:,:)==1];
    cns=[cns, Z1*ones(m,1)==z1];
    cns=[cns, alpha>=zeros(Num_vert,1)];
    cns=[cns, ones(1,Num_vert)*alpha==1];
    cns=[cns, z2==ZZ2'*alpha];
    cns=[cns, z1(Obs)==zeros(length(Obs),1)];
    for jjj=1:n
        cns=[cns, Z1(jjj,:)>=zeros(1,m)];
        cns=[cns, ones(1,n)*(reshape(T(:,jjj,:),[n,m]).*Z1)*ones(m,1)==z2(jjj)];
    end
        
        %obj=(Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1);
      %  obj=(Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1); %norm(Sample(:,kkk)-z1,inf); %  (Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1); %
      rad=rand(n,1);
      rad(Target)=100;
      Q=diag(rad);
    obj=z1'*Q*z1;
%ops =   sdpsettings('solver','sedumi','sedumi.eps',1e-12,'sedumi.maxiter',200,'sedumi.numtol',1e-12);
 ops = sdpsettings('solver','quadprog');
        BRreach=optimize(cns,obj,ops);
        z1=value(z1);
        % Z1=value(Z1);
        % flag=check_feasibility(S,Z1,z1,z2);
        BRreach.problem
        if   BRreach.problem<=0.01  %abs(flag-1)<=0.001
            zz1=[zz1;z1'];
        end
    end
    
for kkk=1:n
    yalmip('clear')
    z = sdpvar(n+n+n*m+Num_vert,1);
    z1=z(1:n);
    z2=z(n+1:n+n);
    Z1=reshape(z(n+n+1:n+n+n*m),[n,m]);
    alpha=z(n+n+n*m+1:end);
    
    cns=[];
    cns=[cns, ones(1,n)*Z1*ones(m,1)==1];
    cns=[cns, z1(:)>=zeros(n,1)];
    cns=[cns, ones(1,n)*z1(:,:)==1];
    cns=[cns, Z1*ones(m,1)==z1];
    cns=[cns, alpha>=zeros(Num_vert,1)];
    cns=[cns, ones(1,Num_vert)*alpha==1];
    cns=[cns, z2==ZZ2'*alpha];
    cns=[cns, z1(Obs)==zeros(length(Obs),1)];
    for jjj=1:n
        cns=[cns, Z1(jjj,:)>=zeros(1,m)];
        cns=[cns, ones(1,n)*(reshape(T(:,jjj,:),[n,m]).*Z1)*ones(m,1)==z2(jjj)];
    end
    c=zeros(n,1);
    c(kkk)=-1;
    obj= c'*z1;
   % ops =   sdpsettings('solver','sedumi','sedumi.eps',1e-12,'sedumi.maxiter',200,'sedumi.numtol',1e-12);
    ops = sdpsettings('solver','quadprog');
    BRreach=optimize(cns,obj,ops);
    z1=value(z1);
    % Z1=value(Z1);
    % flag=check_feasibility(S,Z1,z1,z2);
    if   BRreach.problem<=0.01  %abs(flag-1)<=0.001
        zz1=[zz1;z1'];
    end
end

for kkk=1:n
    yalmip('clear')
    z = sdpvar(n+n+n*m+Num_vert,1);
    z1=z(1:n);
    z2=z(n+1:n+n);
    Z1=reshape(z(n+n+1:n+n+n*m),[n,m]);
    alpha=z(n+n+n*m+1:end);
    
    cns=[];
    cns=[cns, ones(1,n)*Z1*ones(m,1)==1];
    cns=[cns, z1(:)>=zeros(n,1)];
    cns=[cns, ones(1,n)*z1(:,:)==1];
    cns=[cns, Z1*ones(m,1)==z1];
    cns=[cns, alpha>=zeros(Num_vert,1)];
    cns=[cns, ones(1,Num_vert)*alpha==1];
    cns=[cns, z2==ZZ2'*alpha];
    cns=[cns, z1(Obs)==zeros(length(Obs),1)];
    for jjj=1:n
        cns=[cns, Z1(jjj,:)>=zeros(1,m)];
        cns=[cns, ones(1,n)*(reshape(T(:,jjj,:),[n,m]).*Z1)*ones(m,1)==z2(jjj)];
    end
    c=zeros(n,1);
    c(kkk)=1;
    obj= c'*z1;
    %ops =   sdpsettings('solver','sedumi','sedumi.eps',1e-12,'sedumi.maxiter',200,'sedumi.numtol',1e-12);
    ops = sdpsettings('solver','quadprog');
    BRreach=optimize(cns,obj,ops);
    z1=value(z1);
    % Z1=value(Z1);
    % flag=check_feasibility(S,Z1,z1,z2);
    if   BRreach.problem<=0.01  %abs(flag-1)<=0.001
        zz1=[zz1;z1'];
    end
end
%Num_sample=10;
end




% function zz1=Approx_Reach_Avoid(S,ZZ2,Num_sample,Obs)
% n=S.n;
% m=S.m;
% T=S.T;
% zz1=[];
% Num_vert=size(ZZ2,1);
% for iii=1: Num_vert
%     for kkk=1:Num_sample
%         Sample(:,kkk)=3*rand(n,1)-1.5;
%         Sample(end,kkk)=1-sum(Sample(1:end-1,kkk));
%     end
%     for kkk=1:Num_sample
% yalmip('clear')
%     z = sdpvar(n+n+n*m+Num_vert,1);
%     z1=z(1:n);
%     z2=z(n+1:n+n);
%     Z1=reshape(z(n+n+1:n+n+n*m),[n,m]);
%     alpha=z(n+n+n*m+1:end);
%
%     cns=[];
%     cns=[cns, ones(1,n)*Z1*ones(m,1)==1];
%     cns=[cns, z1(:)>=zeros(n,1)];
%     cns=[cns, ones(1,n)*z1(:,:)==1];
%     cns=[cns, Z1*ones(m,1)==z1];
%     cns=[cns, alpha>=zeros(Num_vert,1)];
%     cns=[cns, ones(1,Num_vert)*alpha==1];
%     cns=[cns, z2==ZZ2'*alpha];
%     cns=[cns, z1(Obs)==zeros(length(Obs),1)];
%     for jjj=1:n
%         cns=[cns, Z1(jjj,:)>=zeros(1,m)];
%         cns=[cns, ones(1,n)*(reshape(T(:,jjj,:),[n,m]).*Z1)*ones(m,1)==z2(jjj)];
%     end
%
%     %obj=(Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1);
%     obj=(Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1)-alpha(iii); %norm(Sample(:,kkk)-z1,inf); %  (Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1); %
%     ops =   sdpsettings('solver','sedumi','sedumi.eps',1e-12,'sedumi.maxiter',200,'sedumi.numtol',1e-12);
%     % ops = sdpsettings('solver','quadprog');
%     BRreach=optimize(cns,obj,ops);
%     z1=value(z1);
%     % Z1=value(Z1);
%     % flag=check_feasibility(S,Z1,z1,z2);
%     if   BRreach.problem<=0.01  %abs(flag-1)<=0.001
%         zz1=[zz1;z1'];
%     end
%     end
% end
% %Num_sample=10;
%
%
%
% for kkk=1:n
%     yalmip('clear')
%     z = sdpvar(n+n+n*m+Num_vert,1);
%     z1=z(1:n);
%     z2=z(n+1:n+n);
%     Z1=reshape(z(n+n+1:n+n+n*m),[n,m]);
%     alpha=z(n+n+n*m+1:end);
%
%     cns=[];
%     cns=[cns, ones(1,n)*Z1*ones(m,1)==1];
%     cns=[cns, z1(:)>=zeros(n,1)];
%     cns=[cns, ones(1,n)*z1(:,:)==1];
%     cns=[cns, Z1*ones(m,1)==z1];
%     cns=[cns, alpha>=zeros(Num_vert,1)];
%     cns=[cns, ones(1,Num_vert)*alpha==1];
%     cns=[cns, z2==ZZ2'*alpha];
%     cns=[cns, z1(Obs)==zeros(length(Obs),1)];
%     for jjj=1:n
%         cns=[cns, Z1(jjj,:)>=zeros(1,m)];
%         cns=[cns, ones(1,n)*(reshape(T(:,jjj,:),[n,m]).*Z1)*ones(m,1)==z2(jjj)];
%     end
%     c=zeros(n,1);
%     c(kkk)=-1;
%     obj= c'*z1;
%     ops =   sdpsettings('solver','sedumi','sedumi.eps',1e-12,'sedumi.maxiter',200,'sedumi.numtol',1e-12);
%     % ops = sdpsettings('solver','quadprog');
%     BRreach=optimize(cns,obj,ops);
%     z1=value(z1);
%     % Z1=value(Z1);
%     % flag=check_feasibility(S,Z1,z1,z2);
%     if   BRreach.problem<=0.01  %abs(flag-1)<=0.001
%         zz1=[zz1;z1'];
%     end
% end
%
% for kkk=1:n
%     yalmip('clear')
%     z = sdpvar(n+n+n*m+Num_vert,1);
%     z1=z(1:n);
%     z2=z(n+1:n+n);
%     Z1=reshape(z(n+n+1:n+n+n*m),[n,m]);
%     alpha=z(n+n+n*m+1:end);
%
%     cns=[];
%     cns=[cns, ones(1,n)*Z1*ones(m,1)==1];
%     cns=[cns, z1(:)>=zeros(n,1)];
%     cns=[cns, ones(1,n)*z1(:,:)==1];
%     cns=[cns, Z1*ones(m,1)==z1];
%     cns=[cns, alpha>=zeros(Num_vert,1)];
%     cns=[cns, ones(1,Num_vert)*alpha==1];
%     cns=[cns, z2==ZZ2'*alpha];
%     cns=[cns, z1(Obs)==zeros(length(Obs),1)];
%     for jjj=1:n
%         cns=[cns, Z1(jjj,:)>=zeros(1,m)];
%         cns=[cns, ones(1,n)*(reshape(T(:,jjj,:),[n,m]).*Z1)*ones(m,1)==z2(jjj)];
%     end
%     c=zeros(n,1);
%     c(kkk)=1;
%     obj= c'*z1;
%     ops =   sdpsettings('solver','sedumi','sedumi.eps',1e-12,'sedumi.maxiter',200,'sedumi.numtol',1e-12);
%     % ops = sdpsettings('solver','quadprog');
%     BRreach=optimize(cns,obj,ops);
%     z1=value(z1);
%     % Z1=value(Z1);
%     % flag=check_feasibility(S,Z1,z1,z2);
%     if   BRreach.problem<=0.01  %abs(flag-1)<=0.001
%         zz1=[zz1;z1'];
%     end
% end
% end
%
