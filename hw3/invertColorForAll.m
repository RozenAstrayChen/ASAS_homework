% function h= invertColorForAll(c) changes the background color 
% in all axes of all figures. 
% Usage: c must be either a character specifying the color, or an [r,g,b]
% vector.
% Last Updated: Nov. 17, 2016
function invertColorForAll()
h = get(0,'children');
numFigs = length(h);
for ff = 1:numFigs
    set(h(ff),'Color',1-get(h(ff),'Color'));
    g = get(h(ff),'children');
    numAxes = length(g);
    for aa = 1:numAxes
        if isfield(get(g(aa)),'Color'); % updated Nov. 13, 2016
            set(g(aa),'Color',[1 1 1]-get(g(aa),'Color'));
            set(g(aa),'XColor',[1 1 1]-get(g(aa),'XColor'));
            set(g(aa),'YColor',[1 1 1]-get(g(aa),'YColor'));
            set(g(aa),'ZColor',[1 1 1]-get(g(aa),'ZColor'));
            set(g(aa),'GridColor',[1 1 1]-get(g(aa),'GridColor'));
        end
    end
end
return