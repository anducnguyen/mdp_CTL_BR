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
    z = sdpvar(2,1);
ZZ=[[pp{8}(1)-1;pp{8}(2)-1]<= z <= [pp{8}(1)+1;pp{8}(2)+1]];
 XX=polyhedron(ZZ);
    XX.plot('color', 'red')
    hold on
    plotshadow(pp{10}(1)-1,pp{10}(1)+1,pp{10}(2)-1,pp{10}(2)+1)
    hold on
    plotshadow(pp{11}(1)-1,pp{11}(1)+1,pp{11}(2)-1,pp{11}(2)+1)
    hold on
    plot([1 1 5 5],[3 7 7 5],'-b','LineWidth',1.5) 
    hold on
    
      
    
    axis([0 8 0 8])
     xlabel('$x$','FontSize',16,'interpreter','latex')
ylabel('$y$','FontSize',16,'interpreter','latex')
        xticks([1 3 5 7])
    xticklabels({'1','2','3','4'})
     yticks([1 3 5 7])
    yticklabels({'1','2','3','4'})
    hold on
    grid off
    

    
 %   axis([0 8 0 8])
%     hold on
%     set(gca,'XTick',0:2:8, 'XMinorTick','on')
%     hold on
%     set(gca,'YTick',0:2:8, 'YMinorTick','on')
%     hold on
%     grid on




