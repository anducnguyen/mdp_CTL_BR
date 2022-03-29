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
c4=[0.84 1];
%% first row
t=1;
 subplot(2,4,1)
    KK=length(R{t});
    for kk=1:KK
        R{t}{kk}(2)
        if(abs(R{t}{kk}(2)-1)<=10^-3)
             R{t}{kk}
            x=pp{R{t}{kk}(1)}(1);
            y=pp{R{t}{kk}(1)}(2);
            xx=[x-ds/2 x+ds/2];
            yy=[y-ds/2 y+ds/2];
           imagesc(xx,yy,g{t}(kk))
        hold on 
        end
    end
    colorbar
    caxis(c4)
    set(gca,'ydir','normal');
   % xlabel('$x$','FontSize', 14,'interpreter','latex')
    xlabel(['$x$',newline,'{\bf (a)} $\mathcal{E}$ and $i=1$'],'interpreter','latex')
   ylabel('$y$','interpreter','latex')
    plotshadow(pp{8}(1)-1,pp{8}(1)+1,pp{8}(2)-1,pp{8}(2)+1)
    hold on
    plotshadow(pp{10}(1)-1,pp{10}(1)+1,pp{10}(2)-1,pp{10}(2)+1)
    hold on
    plotshadow(pp{11}(1)-1,pp{11}(1)+1,pp{11}(2)-1,pp{11}(2)+1)
    hold on
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

    subplot(2,4,2)
    KK=length(R{t});
    for kk=1:KK
         R{t}{kk}(2)
        if(abs(R{t}{kk}(2)-2)<=10^-3)
            R{t}{kk}
            x=pp{R{t}{kk}(1)}(1);
            y=pp{R{t}{kk}(1)}(2);
        xx=[x-ds/2 x+ds/2];
        yy=[y-ds/2 y+ds/2];
         imagesc(xx,yy,g{t}(kk))
        hold on 
        end
    end
    colorbar
    caxis(c4)
    set(gca,'ydir','normal');
  xlabel(['$x$',newline,'{\bf (b)} $\mathcal{W}$ and $i=1$'],'interpreter','latex')
   ylabel('$y$', 'interpreter','latex')
    plotshadow(pp{8}(1)-1,pp{8}(1)+1,pp{8}(2)-1,pp{8}(2)+1)
    hold on
    plotshadow(pp{10}(1)-1,pp{10}(1)+1,pp{10}(2)-1,pp{10}(2)+1)
    hold on
    plotshadow(pp{11}(1)-1,pp{11}(1)+1,pp{11}(2)-1,pp{11}(2)+1)
    hold on
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
    
   subplot(2,4,3)
    KK=length(R{t});
    for kk=1:KK
         R{t}{kk}(2)
        if(abs(R{t}{kk}(2)-3)<=10^-3)
            R{t}{kk}
            x=pp{R{t}{kk}(1)}(1)
            y=pp{R{t}{kk}(1)}(2)
            xx=[x-ds/2 x+ds/2];
           yy=[y-ds/2 y+ds/2];
         imagesc(xx,yy,g{t}(kk))
        hold on 
        end
    end
    colorbar
    caxis(c4)
    set(gca,'ydir','normal');
    xlabel(['$x$',newline,'{\bf (c)} $\mathcal{S}$ and $i=1$'],'interpreter','latex')
   ylabel('$y$', 'interpreter','latex')
    plotshadow(pp{8}(1)-1,pp{8}(1)+1,pp{8}(2)-1,pp{8}(2)+1)
    hold on
    plotshadow(pp{10}(1)-1,pp{10}(1)+1,pp{10}(2)-1,pp{10}(2)+1)
    hold on
    plotshadow(pp{11}(1)-1,pp{11}(1)+1,pp{11}(2)-1,pp{11}(2)+1)
    hold on
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
    
   ax4=subplot(2,4,4)
    KK=length(R{t});
    for kk=1:KK
         R{t}{kk}(2)
        if(abs(R{t}{kk}(2)-4)<=10^-3)
             R{t}{kk}
            x=pp{R{t}{kk}(1)}(1)
            y=pp{R{t}{kk}(1)}(2)
        xx=[x-ds/2 x+ds/2];
        yy=[y-ds/2 y+ds/2];
         imagesc(xx,yy,g{t}(kk))
        hold on 
        end
    end
    colorbar
    caxis(c4)
    set(gca,'ydir','normal');
    xlabel(['$x$',newline,'{\bf (d)} $\mathcal{N}$ and $i=1$'],'interpreter','latex')
   ylabel('$y$', 'interpreter','latex')
    plotshadow(pp{8}(1)-1,pp{8}(1)+1,pp{8}(2)-1,pp{8}(2)+1)
    hold on
    plotshadow(pp{10}(1)-1,pp{10}(1)+1,pp{10}(2)-1,pp{10}(2)+1)
    hold on
    plotshadow(pp{11}(1)-1,pp{11}(1)+1,pp{11}(2)-1,pp{11}(2)+1)
    hold on
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
    
%% second row
t=2;
 subplot(2,4,5)
    KK=length(R{t});
    for kk=1:KK
        R{t}{kk}(2)
        if(abs(R{t}{kk}(2)-1)<=10^-3)
             R{t}{kk}
            x=pp{R{t}{kk}(1)}(1);
            y=pp{R{t}{kk}(1)}(2);
            xx=[x-ds/2 x+ds/2];
            yy=[y-ds/2 y+ds/2];
           imagesc(xx,yy,g{t}(kk))
        hold on 
        end
    end
    colormap jet
    colorbar
    caxis(c4)
    set(gca,'ydir','normal');
    xlabel(['$x$',newline,'{\bf (e)} $\mathcal{E}$ and $i=2$'],'interpreter','latex')
   ylabel('$y$', 'interpreter','latex')
   
   
    plotshadow(pp{8}(1)-1,pp{8}(1)+1,pp{8}(2)-1,pp{8}(2)+1)
    hold on
    plotshadow(pp{10}(1)-1,pp{10}(1)+1,pp{10}(2)-1,pp{10}(2)+1)
    hold on
    plotshadow(pp{11}(1)-1,pp{11}(1)+1,pp{11}(2)-1,pp{11}(2)+1)
    hold on
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

    subplot(2,4,6)
    KK=length(R{t});
    for kk=1:KK
         R{t}{kk}(2)
        if(abs(R{t}{kk}(2)-2)<=10^-3)
            R{t}{kk}
            x=pp{R{t}{kk}(1)}(1);
            y=pp{R{t}{kk}(1)}(2);
        xx=[x-ds/2 x+ds/2];
        yy=[y-ds/2 y+ds/2];
         imagesc(xx,yy,g{t}(kk))
        hold on 
        end
    end
    colorbar
    caxis(c4)
    set(gca,'ydir','normal');
   xlabel(['$x$',newline,'{\bf (f)} $\mathcal{W}$ and $i=2$'],'interpreter','latex')
   ylabel('$y$', 'interpreter','latex')
    plotshadow(pp{8}(1)-1,pp{8}(1)+1,pp{8}(2)-1,pp{8}(2)+1)
    hold on
    plotshadow(pp{10}(1)-1,pp{10}(1)+1,pp{10}(2)-1,pp{10}(2)+1)
    hold on
    plotshadow(pp{11}(1)-1,pp{11}(1)+1,pp{11}(2)-1,pp{11}(2)+1)
    hold on
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
    
   subplot(2,4,7)
    KK=length(R{t});
    for kk=1:KK
         R{t}{kk}(2)
        if(abs(R{t}{kk}(2)-3)<=10^-3)
            R{t}{kk}
            x=pp{R{t}{kk}(1)}(1)
            y=pp{R{t}{kk}(1)}(2)
            xx=[x-ds/2 x+ds/2];
           yy=[y-ds/2 y+ds/2];
         imagesc(xx,yy,g{t}(kk))
        hold on 
        end
    end
    colorbar
    caxis(c4)
    set(gca,'ydir','normal');
    xlabel(['$x$',newline,'{\bf (g)} $\mathcal{S}$ and $i=2$'],'interpreter','latex')
   ylabel('$y$', 'interpreter','latex')
    plotshadow(pp{8}(1)-1,pp{8}(1)+1,pp{8}(2)-1,pp{8}(2)+1)
    hold on
    plotshadow(pp{10}(1)-1,pp{10}(1)+1,pp{10}(2)-1,pp{10}(2)+1)
    hold on
    plotshadow(pp{11}(1)-1,pp{11}(1)+1,pp{11}(2)-1,pp{11}(2)+1)
    hold on
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
    
   ax8=subplot(2,4,8)
    KK=length(R{t});
    for kk=1:KK
         R{t}{kk}(2)
        if(abs(R{t}{kk}(2)-4)<=10^-3)
             R{t}{kk}
            x=pp{R{t}{kk}(1)}(1)
            y=pp{R{t}{kk}(1)}(2)
        xx=[x-ds/2 x+ds/2];
        yy=[y-ds/2 y+ds/2];
         imagesc(xx,yy,g{t}(kk))
        hold on 
        end
    end
    set(gca,'ydir','normal');
    xlabel(['$x$',newline,'{\bf (h)} $\mathcal{N}$ and $i=2$'],'interpreter','latex')
   ylabel('$y$', 'interpreter','latex')
    plotshadow(pp{8}(1)-1,pp{8}(1)+1,pp{8}(2)-1,pp{8}(2)+1)
    hold on
    plotshadow(pp{10}(1)-1,pp{10}(1)+1,pp{10}(2)-1,pp{10}(2)+1)
    hold on
    plotshadow(pp{11}(1)-1,pp{11}(1)+1,pp{11}(2)-1,pp{11}(2)+1)
    hold on
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
     grid off
    
    
    pos4=get(ax4, 'Position');
    pos8=get(ax8, 'Position');
colormap jet
h=colorbar;
set(h, 'Position', [pos8(1)+pos8(3)+0.01 pos8(2)+0.04 pos8(3)*0.1 pos4(4)+pos8(4)+0.08])
 ylabel(h,'infinite-horizon invariance probability')
caxis(c4)

 
subplot(2,4,1)
colorbar off
subplot(2,4,2)
colorbar off
subplot(2,4,3)
colorbar off
subplot(2,4,4)
colorbar off
subplot(2,4,5)
colorbar off
subplot(2,4,6)
colorbar off
subplot(2,4,7)
colorbar off
