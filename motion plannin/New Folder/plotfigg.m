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


%%% construct MDP
XX=R{nnn};
UU=Uu{nnn-1};
for i=1:size(XX,2)
    TT(XX{i}(1),XX{i}(2),1:16,1:4)=T{UU(i)}(XX{i}(1),XX{i}(2),1:16,1:4);
end

clear xxx
xxx(1,:)=[15 4];

runtime=30;
for kk=1:runtime
    temp=rand;
    i=1;
    temp1=TT(xxx(kk,1),xxx(kk,2),XX{i}(1),XX{i}(2));
    while(temp>=temp1)
        i=i+1;
        temp1=temp1+TT(xxx(kk,1),xxx(kk,2),XX{i}(1),XX{i}(2));
    end
    xxx(kk+1,:)=[XX{i}(1),XX{i}(2)];
end

 
figure
for i=1:16
    z = sdpvar(2,1);
    ZZ=[[pp{i}(1)-1;pp{i}(2)-1]<= z <= [pp{i}(1)+1;pp{i}(2)+1]];
    XX=polyhedron(ZZ);
    XX.plot('color', 'white')
    hold on
end
 z = sdpvar(2,1);
ZZ=[[pp{7}(1)-1;pp{7}(2)-1]<= z <= [pp{7}(1)+1;pp{7}(2)+1]];
 XX=polyhedron(ZZ);
    XX.plot('color', 'red')
    hold on
 xlabel('$x$', 'FontSize', 14,'interpreter','latex')
   ylabel('$y$', 'FontSize', 14,'interpreter','latex')
   
    plotshadow(pp{8}(1)-1,pp{8}(1)+1,pp{8}(2)-1,pp{8}(2)+1)
    hold on
    plotshadow(pp{10}(1)-1,pp{10}(1)+1,pp{10}(2)-1,pp{10}(2)+1)
    hold on
    plotshadow(pp{11}(1)-1,pp{11}(1)+1,pp{11}(2)-1,pp{11}(2)+1)
    hold on

    rad=0.2;
    for kk=1:runtime
        switch xxx(kk,2)
            case 1
              XX = Polyhedron('V', [pp{xxx(kk,1)}(1)-rad,pp{xxx(kk,1)}(2)-rad; pp{xxx(kk,1)}(1)+rad,...
                  pp{xxx(kk,1)}(2)-rad; pp{xxx(kk,1)}(1)+rad, pp{xxx(kk,1)}(2)+rad; pp{xxx(kk,1)}(1)-rad, pp{xxx(kk,1)}(2)+rad]);
              XX.plot('color', 'white')
              hold on
             XX = Polyhedron('V', [pp{xxx(kk,1)}(1)+rad,...
                  pp{xxx(kk,1)}(2)-rad; pp{xxx(kk,1)}(1)+rad, pp{xxx(kk,1)}(2)+rad; pp{xxx(kk,1)}(1)+rad*2,pp{xxx(kk,1)}(2)]);
              XX.plot('color', 'black')
              hold on
            case 2
            XX = Polyhedron('V', [pp{xxx(kk,1)}(1)-rad,pp{xxx(kk,1)}(2)-rad; pp{xxx(kk,1)}(1)+rad,...
                  pp{xxx(kk,1)}(2)-rad; pp{xxx(kk,1)}(1)+rad, pp{xxx(kk,1)}(2)+rad; pp{xxx(kk,1)}(1)-rad, pp{xxx(kk,1)}(2)+rad]);
              XX.plot('color', 'white')
              hold on
             XX = Polyhedron('V', [pp{xxx(kk,1)}(1)-rad,pp{xxx(kk,1)}(2)-rad; pp{xxx(kk,1)}(1)-rad, pp{xxx(kk,1)}(2)+rad; pp{xxx(kk,1)}(1)-rad*2,pp{xxx(kk,1)}(2)]);
              XX.plot('color', 'black')
              hold on
            case 3
                 XX = Polyhedron('V', [pp{xxx(kk,1)}(1)-rad,pp{xxx(kk,1)}(2)-rad; pp{xxx(kk,1)}(1)+rad,...
                  pp{xxx(kk,1)}(2)-rad; pp{xxx(kk,1)}(1)+rad, pp{xxx(kk,1)}(2)+rad; pp{xxx(kk,1)}(1)-rad, pp{xxx(kk,1)}(2)+rad]);
              XX.plot('color', 'white')
              hold on
             XX = Polyhedron('V', [pp{xxx(kk,1)}(1)-rad,pp{xxx(kk,1)}(2)-rad; pp{xxx(kk,1)}(1)+rad,...
                  pp{xxx(kk,1)}(2)-rad; pp{xxx(kk,1)}(1),pp{xxx(kk,1)}(2)-rad*2]);
              XX.plot('color', 'black')
              hold on
            case 4
                   XX = Polyhedron('V', [pp{xxx(kk,1)}(1)-rad,pp{xxx(kk,1)}(2)-rad; pp{xxx(kk,1)}(1)+rad,...
                  pp{xxx(kk,1)}(2)-rad; pp{xxx(kk,1)}(1)+rad, pp{xxx(kk,1)}(2)+rad; pp{xxx(kk,1)}(1)-rad, pp{xxx(kk,1)}(2)+rad]);
              XX.plot('color', 'white')
              hold on
             XX = Polyhedron('V', [ pp{xxx(kk,1)}(1)+rad, pp{xxx(kk,1)}(2)+rad; pp{xxx(kk,1)}(1)-rad, pp{xxx(kk,1)}(2)+rad; pp{xxx(kk,1)}(1),pp{xxx(kk,1)}(2)+rad*2]);
              XX.plot('color', 'black')
              hold on
        end
    end
    
    
    
    for kk=1:runtime-1
        plot([pp{xxx(kk,1)}(1);pp{xxx(kk+1,1)}(1)],[pp{xxx(kk,1)}(2);pp{xxx(kk+1,1)}(2)],'k-','LineWidth',2)
        hold on 
    end

   axis([0 8 0 8])
    hold on
    plot([2 2],[0 8],'k-')  
    hold on
    plot([4 4],[0 8],'k-')  
     hold on
    plot([6 6],[0 8],'k-')
    hold on
    plot([0 8],[2 2],'k-')
     hold on
    plot([0 8],[4 4],'k-')
     hold on
    plot([0 8],[6 6],'k-')
    hold on
    xticks([1 3 5 7])
    xticklabels({'1','2','3','4'})
     yticks([1 3 5 7])
    yticklabels({'1','2','3','4'})
    hold on
    grid off
 
figure
clear px py pz
kk=1;
flag=1;
for kk=1:runtime
   % xxx(kk+1,:)=[XX{i}(1),XX{i}(2)];
 %  if abs(xxx(kk,1)-7)<=10^-2 | abs(kk-runtime)<=10^-2
   %    flag=0;
 %  else
    px(kk)=pp{xxx(kk,1)}(1);
    py(kk)=pp{xxx(kk,1)}(2);
    pz(kk)=kk-1;
  %  flag=1;
 %  end
end
plot3(pz,px,py,'k-*','LineWidth',1.5)
xlabel('time','FontSize', 14,'interpreter','latex')
ylabel('x','FontSize', 14,'interpreter','latex')
zlabel('y','FontSize', 14,'interpreter','latex')
axis([0 runtime-1 0 8 0 8])
 yticks([1 3 5 7])
    yticklabels({'1','2','3','4'})
     zticks([1 3 5 7])
    zticklabels({'1','2','3','4'})
grid on

%view(2)
%     
% XX = Polyhedron('V', [0.7, 0.9; 0.7, 1.1; 1.3, 0.9; 1.3, 1.1]);
% XX.plot('color', 'white')
%  hold on
% XX = Polyhedron('V', [0.7, 0.6; 0.7, 1.4; 0.55, 0.6; 0.55, 1.4]);
% XX.plot('color', 'black')
% hold on
% XX = Polyhedron('V', [1.3, 0.6; 1.3, 1.4; 1.45, 0.6; 1.45, 1.4]);
% XX.plot('color', 'black')
% hold on
% XX = Polyhedron('V', [1, 1.6; 0.7, 1.1; 1.3, 1.1]);
% XX.plot('color', 'white')



