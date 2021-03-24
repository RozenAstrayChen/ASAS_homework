% function h=setBackGroundColorForAll(c) changes the background color 
% in all axes of all figures. 
% Usage: c must be either a character specifying the color, or an [r,g,b]
% vector.
% Last Updated: Nov. 17, 2016
function setBackGroundColorForAll(c)
h = get(0,'children');
numFigs = length(h);
for ff = 1:numFigs
    set(h(ff),'Color',c);
    g = get(h(ff),'children');
    numAxes = length(g);
    for aa = 1:numAxes
        if isfield(get(g(aa)),'Color'); % updated Nov. 13, 2016
            set(g(aa),'Color',c);
        end
    end
end
return