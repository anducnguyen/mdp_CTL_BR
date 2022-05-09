
function plotshadow(x1,x2,y1,y2)
t=-2:0.2:4;
for i=1:length(t)
    x{i}=0:0.02:8;
    y{i}=x{i}-t(i);
    indexx1{i}=find(x{i}>=x1);
    indexx2{i}=find(x{i}<=x2);
    indexy1{i}=find(y{i}>=y1);
    indexy2{i}=find(y{i}<=y2);
    ix=max(indexx1{i}(1),indexy1{i}(1));
    iy=min(indexx2{i}(end),indexy2{i}(end));
    if(ix<iy)
    plot(x{i}(ix:iy),y{i}(ix:iy),'k-')
    hold on
    end
end
end