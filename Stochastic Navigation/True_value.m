function [pro_DoA,maxPro_DoA,Horizon_DoA,pro_RAV,maxPro_RAV,Horizon_RAV]=True_value(MDP,Target,Obs)
n=MDP.n;
m=MDP.m;
T=MDP.T;
Max_N=20;

%% true DoA
for N=1:Max_N
    for i=1:MDP.n
        z = sdpvar(n+n*m*N,1);
        z1=z(1:n);
        z2=zeros(n,1);
        z2(i)=1;
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
        cns=[cns, Zz{1}*ones(m,1)==z2];
        cns=[cns, Zz{N}*ones(m,1)==z1];
        cns=[cns, ones(1,n)*z1==1];
        cns=[cns, z1>=zeros(n,1)];
        %obj=(Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1);
        obj=-sum(z1(Target)); %norm(Sample(:,kkk)-z1,inf); %  (Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1); %
        ops =   sdpsettings('solver','sedumi','sedumi.eps',1e-12,'sedumi.maxiter',200,'sedumi.numtol',1e-12);
        % ops = sdpsettings('solver','quadprog');
        BRreach=optimize(cns,obj,ops);
         Tt=value(z1);
        Tt(find(Tt<= 1.0000e-8))=0;
        if(sum(Tt)>=1.0000e-8)
            Tt=Tt/sum(Tt);
        end
        pro_DoA(N,i)=sum(Tt(Target));
    end
        %     % Z1=value(Z1);
        %     % flag=check_feasibility(S,Z1,z1,z2);
        %     if   BRreach.problem<=0.01  %abs(flag-1)<=0.001
        %         zz1=[zz1;z1'];
        %     end
end

% for i=1:size(pro_DoA,1)
%     true_pro_DoA(i)=sum(pro_DoA(Target,i));
%     for k=1:10
%         true_DoA_uni{k}=find(true_pro_DoA>=0.05+0.1*(k-1));
%     end
% end

% true RAV A={7,23,39,55}
for N=1:Max_N
    for i=1:MDP.n
        z = sdpvar(n+n*m*N,1);
        z1=z(1:n);
        z2=zeros(n,1);
        z2(i)=1;
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
        cns=[cns, Zz{1}*ones(m,1)==z2];
        cns=[cns, Zz{N}*ones(m,1)==z1];
        cns=[cns, ones(1,n)*z1==1];
        cns=[cns, z1>=zeros(n,1)];
        obj=-sum(z1(Target)); %norm(Sample(:,kkk)-z1,inf); %  (Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1); %
        ops =   sdpsettings('solver','sedumi','sedumi.eps',1e-12,'sedumi.maxiter',200,'sedumi.numtol',1e-12);
        %ops = sdpsettings('solver','quadprog');
        BRreach=optimize(cns,obj,ops);
        Tt=value(z1);
        Tt(find(Tt<= 1.0000e-8))=0;
        if(sum(Tt)>=1.0000e-8)
            Tt=Tt/sum(Tt);
        end
        pro_RAV(N,i)=sum(Tt(Target));
    end
end

for i=1:n
    [maxPro_DoA(i),Horizon_DoA(i)]=max(pro_DoA(:,i));
    [maxPro_RAV(i),Horizon_RAV(i)]=max(pro_RAV(:,i));
end


% for i=1:size(pro_RAV,1)
%     true_pro_RAV(i)=sum(pro_RAV(Target,i));
%     for k=1:10
%         true_RAV_uni{k}=find(true_pro_RAV>=0.05+0.1*(k-1));
%     end
% end
end