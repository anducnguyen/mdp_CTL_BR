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
%[pro_DoA,maxPro_DoA,Horizon_DoA,pro_RAV,maxPro_RAV,Horizon_RAV]=True_value(MDP,Target,Obs);


%% DoA
Rand_num=3;
nnn=1;

while(nnn<=Rand_num)
    clear Vert_BR
    Nmax=25;
    BR_Sample_num=300;
    epsilon=0.80;
    %True_DoA=sort(find(maxPro_DoA>=epsilon));
    True_DoA=[1 2 3 4 5 6 7 8  9 12 15 16];
    Appro_DoA=Target;
    DoA_BRtotal=[];



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
    cns=[cns, sum(z2(Target))>=epsilon];
    for i=1:n
        cns=[cns, Z1(i,:)>=zeros(1,m)];
        cns=[cns, ones(1,n)*(reshape(T(:,i,:),[n,m]).*Z1)*ones(m,1)==z2(i)];
    end
    obj=norm(Chosen_sample-z1); %norm(Sample(:,kkk)-z1,inf); %  (Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1);
    ops = sdpsettings('solver','mosek');
    BRreach_ini = optimizer(cns,obj,ops,Chosen_sample,z1);

    

    % % construct optimization problem
    % yalmip('clear')
    % z11=sdpvar(n,1);
    % z22=sdpvar(n,1);
    % Z11=sdpvar(n,m);
    % Chosen_sample=sdpvar(n,1);
    % ZZ2=sdpvar(n,BR_Sample_num);
    % alpha=sdpvar(BR_Sample_num,1);
    % cns=[];
    % cns=[cns, ones(1,n)*Z11*ones(m,1)==1];
    % cns=[cns, Z11>=zeros(n,m)];
    % cns=[cns, Z11*ones(m,1)==z11];
    % cns=[cns, alpha>=zeros(BR_Sample_num,1)];
    % cns=[cns, ones(1,BR_Sample_num)*alpha==1];
    % cns=[cns, z22==ZZ2*alpha];
    % for i=1:n
    %     cns=[cns, ones(1,n)*(reshape(T(:,i,:),[n,m]).*Z11)*ones(m,1)==z22(i)];
    % end
    %
    % obj=norm(Chosen_sample-z11); %norm(Sample(:,kkk)-z1,inf); %  (Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1);
    % ops = sdpsettings('solver','mosek');
    % BRreach = optimizer(cns,obj,ops,Chosen_sample,z11);
    %

    tic

    %initialization
    for i=1:BR_Sample_num-n
        Sample(:,i)=3*rand(n,1)-1.5;
        Sample(end,i)=1-sum(Sample(1:end-1,i));
    end
    Sample=[Sample eye(n)];

    % parpool(100)
    z11=zeros(n,BR_Sample_num);
    parfor k=1:BR_Sample_num
        z11(:,k)=BRreach_ini(Sample(:,k));
        % zz1=[zz1;z1'];
    end
    zz1=z11';

    zz1(find(zz1<= 1.0000e-8))=0;
    for kkk=1:size(zz1,1)
        zz1(kkk,:)=zz1(kkk,:)/sum(zz1(kkk,:));
    end
    Vert_BR{1}=zz1;
    DoA_BRtotal=Vert_BR{1};
    item=max(Vert_BR{1},[],1);
    idx=find(item>=0.99);
    Appro_DoA=[Appro_DoA;idx'];
    Appro_DoA=sort(unique(Appro_DoA));


    % %figbar= waitbar(0,'Domain of Acctraction');
    i=1;
    flag=1;
    Select_BR=DoA_BRtotal;
    Select_BR=Select_BR';
    while(i<=Nmax && flag)
        %     clear Sample
        %     for k=1:BR_Sample_num-n
        %         Sample(:,k)=3*rand(n,1)-1.5;
        %         Sample(end,k)=1-sum(Sample(1:end-1,k));
        %     end
        %     Sample=[Sample eye(n)];
        %
        %     parfor kkk=1:BR_Sample_num
        %         z1=BRreach({Sample(:,kkk),Select_BR});
        %         zz1=[zz1;z1'];
        %     end
        %
        %     zz1(find(zz1<= 1.0000e-8))=0;
        %     for kkk=1:size(zz1,1)
        %         zz1(kkk,:)=zz1(kkk,:)/sum(zz1(kkk,:));
        %     end
        %     Vert_BR{i+1}=zz1;


        Vert_BR{i+1}=Approx_Control(MDP,DoA_BRtotal,BR_Sample_num);
        DoA_BRtotal=[DoA_BRtotal; Vert_BR{i+1}];
        % waitbar(i/Nmax,figbar,'Domain of Acctraction')
        item=max(Vert_BR{i+1},[],1);
        idx=find(item>=0.99);
        Appro_DoA=[Appro_DoA;idx'];
        Appro_DoA=sort(unique(Appro_DoA));
        if(length(Appro_DoA)==length(True_DoA))
            flag=0;
        else
            i=i+1;
            %         Total_num=size(DoA_BRtotal,1);
            %         item=1:1:Total_num;
            %         sele_idx=datasample(item,BR_Sample_num-length(Appro_DoA),'Replace',false);
            %         Idata=eye(n);
            %         Select_BR=[Idata(Appro_DoA,:);DoA_BRtotal(sele_idx,:)];
            %         Select_BR=Select_BR';
        end
    end
    if flag==0
        Vert_DoA{nnn}=Vert_BR;
        Comtime_DoA(nnn)=toc;
        nnn
        nnn=nnn+1;
    end
end

%
% for nnn=1:Rand_num %Rand_num
%     %% reach avoid
%     Nmax=30;
%     BR_Sample_num=300;
%     epsilon=0.80;
%     %True_DoA=sort(find(maxPro_DoA>=epsilon));
%     True_RA=[1 2 3 4 6 7 8 12];
%     Appro_RA=Target;
%     RA_BRtotal=[];
%
%
%     %% construct inial optimization problem
%     yalmip('clear')
%     z1=sdpvar(n,1);
%     z2=sdpvar(n,1);
%     Z1=sdpvar(n,m);
%     Chosen_sample=sdpvar(n,1);
%     cns=[];
%     cns=[cns, ones(1,n)*Z1*ones(m,1)==1];
%     cns=[cns, Z1>=zeros(n,m)];
%     cns=[cns, Z1*ones(m,1)==z1];
%     cns=[cns, sum(z2(Target))>=epsilon];
%     cns=[cns, sum(z1(Obs))==0];
%     for i=1:n
%         cns=[cns, Z1(i,:)>=zeros(1,m)];
%         cns=[cns, ones(1,n)*(reshape(T(:,i,:),[n,m]).*Z1)*ones(m,1)==z2(i)];
%     end
%     obj=norm(Chosen_sample-z1); %norm(Sample(:,kkk)-z1,inf); %  (Sample(:,kkk)-z1)'*(Sample(:,kkk)-z1);
%     ops = sdpsettings('solver','mosek');
%     BRreachRA_ini = optimizer(cns,obj,ops,Chosen_sample,z1);
%
%     tic
%     % initialization
%     for i=1:BR_Sample_num-n
%         Sample(:,i)=3*rand(n,1)-1.5;
%         Sample(end,i)=1-sum(Sample(1:end-1,i));
%     end
%     Sample=[Sample eye(n)];
%
%
%     z11=zeros(n,BR_Sample_num);
%     parfor k=1:BR_Sample_num
%         z11(:,k)=BRreachRA_ini(Sample(:,k));
%         % zz1=[zz1;z1'];
%     end
%     zz1=z11';
%
%     zz1(find(zz1<= 1.0000e-8))=0;
%     for kkk=1:size(zz1,1)
%         zz1(kkk,:)=zz1(kkk,:)/sum(zz1(kkk,:));
%     end
%     Vert_BR{1}=zz1;
%     RA_BRtotal=Vert_BR{1};
%     item=max(Vert_BR{1},[],1);
%     idx=find(item>=0.99);
%     Appro_RA=[Appro_RA;idx'];
%     Appro_RA=sort(unique(Appro_RA));
%
%
%     % %figbar= waitbar(0,'Domain of Acctraction');
%     i=1;
%     flag=1;
%     Select_BR=RA_BRtotal;
%     Select_BR=Select_BR';
%     while(i<=Nmax && flag)
%         %     clear Sample
%         %     for k=1:BR_Sample_num-n
%         %         Sample(:,k)=3*rand(n,1)-1.5;
%         %         Sample(end,k)=1-sum(Sample(1:end-1,k));
%         %     end
%         %     Sample=[Sample eye(n)];
%         %
%         %     parfor kkk=1:BR_Sample_num
%         %         z1=BRreach({Sample(:,kkk),Select_BR});
%         %         zz1=[zz1;z1'];
%         %     end
%         %
%         %     zz1(find(zz1<= 1.0000e-8))=0;
%         %     for kkk=1:size(zz1,1)
%         %         zz1(kkk,:)=zz1(kkk,:)/sum(zz1(kkk,:));
%         %     end
%         %     Vert_BR{i+1}=zz1;
%
%
%         Vert_BR{i+1}=Approx_Reach_Avoid(MDP,RA_BRtotal,BR_Sample_num,Obs);
%         RA_BRtotal=[RA_BRtotal; Vert_BR{i+1}];
%         % waitbar(i/Nmax,figbar,'Domain of Acctraction')
%         item=max(Vert_BR{i+1},[],1);
%         idx=find(item>=0.99);
%         Appro_RA=[Appro_RA;idx'];
%         Appro_RA=sort(unique(Appro_RA));
%         if(length(Appro_RA)==length(True_RA))
%             flag=0;
%         else
%             i=i+1;
%             %         Total_num=size(RA_BRtotal,1);
%             %         item=1:1:Total_num;
%             %         sele_idx=datasample(item,BR_Sample_num-length(Appro_RA),'Replace',false);
%             %         Idata=eye(n);
%             %         Select_BR=[Idata(Appro_RA,:);RA_BRtotal(sele_idx,:)];
%             %         Select_BR=Select_BR';
%         end
%     end
%     Comtime_RA(nnn)=toc;
%     Vert_RA{nnn}=Vert_BR;
%     nnn
% end

