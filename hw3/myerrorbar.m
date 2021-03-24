% function myerrorbar(x,y,ebar,BW,LW)
% I got frustrated that MATLAB's errorbar() sets the length of the horizontal bar
% automatically.  So here comes my own version.
% x,y: data.
% ebar: "standard deviation", so to speak.
% BW: bar width: setting the length of the horizontal bar, in unit of x.
% LW: line width.
function myerrorbar(x,y,ebar,BW,LW)
CLR = 'b';
MSZ = 4;
h = plot(x,y,'.','markersize',MSZ,'linewidth',LW,'color',CLR); hold on;
for kk = 1:length(x)
    line([x(kk)-BW/2 x(kk)+BW/2],[y(kk)-ebar(kk) y(kk)-ebar(kk)],'linewidth',LW,'color',CLR); hold on;
    line([x(kk)-BW/2 x(kk)+BW/2],[y(kk)+ebar(kk) y(kk)+ebar(kk)],'linewidth',LW,'color',CLR);
    line([x(kk) x(kk)],[y(kk)-ebar(kk) y(kk)+ebar(kk)],'linewidth',LW,'color',CLR);
end
set(h,'markerfacecolor','w');
return