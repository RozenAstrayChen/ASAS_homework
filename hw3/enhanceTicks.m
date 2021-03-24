% function enhanceTicks(handle,R) makes the tick marks R times longer than
% curently.
% May-20-2009
function enhanceTicks(handle,R)
set(handle,'ticklength',get(handle,'ticklength')*R);
return