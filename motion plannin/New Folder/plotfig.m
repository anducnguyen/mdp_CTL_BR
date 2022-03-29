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


for t=1:nnn-1
    figure 
    KK=length(R{t});
    for kk=1:KK
        R{t}{kk}(2)
        if(abs(R{t}{kk}(2)-1)<=10^-3)
             R{t}{kk}
            x=pp{R{t}{kk}(1)}(1);
            y=pp{R{t}{kk}(1)}(2);
            xx=[x-ds/2 x+ds/2];
            yy=[y-ds/2 y+ds/2];
           imagesc(xx,yy,v{t}(kk,1))
        hold on 
        end
    end
    colormap jet
    colorbar
    set(gca,'ydir','normal');
     xlabel('x(m)')
    ylabel('y(m)')
    
    plotshadow(pp{8}(1)-1,pp{8}(1)+1,pp{8}(2)-1,pp{8}(2)+1)
    hold on
    plotshadow(pp{10}(1)-1,pp{10}(1)+1,pp{10}(2)-1,pp{10}(2)+1)
    hold on
    plotshadow(pp{11}(1)-1,pp{11}(1)+1,pp{11}(2)-1,pp{11}(2)+1)
    hold on
    axis([0 8 0 8])
    hold on
    set(gca,'XTick',0:2:8, 'XMinorTick','on')
    hold on
    set(gca,'YTick',0:2:8, 'YMinorTick','on')
    hold on
    grid on
    figure 
    KK=length(R{t});
    for kk=1:KK
         R{t}{kk}(2)
        if(abs(R{t}{kk}(2)-2)<=10^-3)
            R{t}{kk}
            x=pp{R{t}{kk}(1)}(1);
            y=pp{R{t}{kk}(1)}(2);
        xx=[x-ds/2 x+ds/2];
        yy=[y-ds/2 y+ds/2];
         imagesc(xx,yy,v{t}(kk,1))
        hold on 
        end
    end
    colormap jet
    colorbar
    set(gca,'ydir','normal');
     xlabel('x(m)')
    ylabel('y(m)')
    plotshadow(pp{8}(1)-1,pp{8}(1)+1,pp{8}(2)-1,pp{8}(2)+1)
    hold on
    plotshadow(pp{10}(1)-1,pp{10}(1)+1,pp{10}(2)-1,pp{10}(2)+1)
    hold on
    plotshadow(pp{11}(1)-1,pp{11}(1)+1,pp{11}(2)-1,pp{11}(2)+1)
    hold on
     axis([0 8 0 8])
    hold on
    set(gca,'XTick',0:2:8, 'XMinorTick','on')
    hold on
    set(gca,'YTick',0:2:8, 'YMinorTick','on')
    hold on
    grid on
    figure 
    KK=length(R{t});
    for kk=1:KK
         R{t}{kk}(2)
        if(abs(R{t}{kk}(2)-3)<=10^-3)
            R{t}{kk}
            x=pp{R{t}{kk}(1)}(1)
            y=pp{R{t}{kk}(1)}(2)
            xx=[x-ds/2 x+ds/2];
           yy=[y-ds/2 y+ds/2];
         imagesc(xx,yy,v{t}(kk,1))
        hold on 
        end
    end
    colormap jet
    colorbar
    set(gca,'ydir','normal');
     xlabel('x(m)')
    ylabel('y(m)')
    plotshadow(pp{8}(1)-1,pp{8}(1)+1,pp{8}(2)-1,pp{8}(2)+1)
    hold on
    plotshadow(pp{10}(1)-1,pp{10}(1)+1,pp{10}(2)-1,pp{10}(2)+1)
    hold on
    plotshadow(pp{11}(1)-1,pp{11}(1)+1,pp{11}(2)-1,pp{11}(2)+1)
    hold on
    axis([0 8 0 8])
    hold on
    set(gca,'XTick',0:2:8, 'XMinorTick','on')
    hold on
    set(gca,'YTick',0:2:8, 'YMinorTick','on')
    hold on
    grid on
    
    figure 
    KK=length(R{t});
    for kk=1:KK
         R{t}{kk}(2)
        if(abs(R{t}{kk}(2)-4)<=10^-3)
             R{t}{kk}
            x=pp{R{t}{kk}(1)}(1)
            y=pp{R{t}{kk}(1)}(2)
        xx=[x-ds/2 x+ds/2];
        yy=[y-ds/2 y+ds/2];
         imagesc(xx,yy,v{t}(kk,1))
        hold on 
        end
    end
    colormap jet
    colorbar
    set(gca,'ydir','normal');
     xlabel('x(m)')
    ylabel('y(m)')
    plotshadow(pp{8}(1)-1,pp{8}(1)+1,pp{8}(2)-1,pp{8}(2)+1)
    hold on
    plotshadow(pp{10}(1)-1,pp{10}(1)+1,pp{10}(2)-1,pp{10}(2)+1)
    hold on
    plotshadow(pp{11}(1)-1,pp{11}(1)+1,pp{11}(2)-1,pp{11}(2)+1)
    hold on
    axis([0 8 0 8])
    hold on
    set(gca,'XTick',0:2:8, 'XMinorTick','on')
    set(gca,'YTick',0:2:8, 'YMinorTick','on')
    grid on
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
 xlabel('x(m)')
    ylabel('y(m)')
    plotshadow(pp{8}(1)-1,pp{8}(1)+1,pp{8}(2)-1,pp{8}(2)+1)
    hold on
    plotshadow(pp{10}(1)-1,pp{10}(1)+1,pp{10}(2)-1,pp{10}(2)+1)
    hold on
    plotshadow(pp{11}(1)-1,pp{11}(1)+1,pp{11}(2)-1,pp{11}(2)+1)
    hold on
 %   axis([0 8 0 8])
%     hold on
%     set(gca,'XTick',0:2:8, 'XMinorTick','on')
%     hold on
%     set(gca,'YTick',0:2:8, 'YMinorTick','on')
%     hold on
%     grid on
    
XX = Polyhedron('V', [0.7, 0.9; 0.7, 1.1; 1.3, 0.9; 1.3, 1.1]);
XX.plot('color', 'white')
 hold on
XX = Polyhedron('V', [0.7, 0.6; 0.7, 1.4; 0.55, 0.6; 0.55, 1.4]);
XX.plot('color', 'black')
hold on
XX = Polyhedron('V', [1.3, 0.6; 1.3, 1.4; 1.45, 0.6; 1.45, 1.4]);
XX.plot('color', 'black')
hold on
XX = Polyhedron('V', [1, 1.6; 0.7, 1.1; 1.3, 1.1]);
XX.plot('color', 'white')



