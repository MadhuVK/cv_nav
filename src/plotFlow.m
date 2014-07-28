function plotFlow(u, v, imgOriginal, rSize, scale)
% Creates a quiver plot that displays the optical flow vectors on the
% original first frame (if provided). See the MATLAB Function Reference for
% "quiver" for more info.
%
% Usage:
% plotFlow(u, v, imgOriginal, rSize, scale)
%
% u and v are the horizontal and vertical optical flow vectors,
% respectively. imgOriginal, if supplied, is the first frame on which the
% flow vectors would be plotted. use an empty matrix '[]' for no image.
% rSize is the size of the region in which one vector is visible. scale
% over-rules the auto scaling.
%
% Author: Mohd Kharbat at Cranfield Defence and Security
% mkharbat(at)ieee(dot)org , http://mohd.kharbat.com
% Published under a Creative Commons Attribution-Non-Commercial-Share Alike
% 3.0 Unported Licence http://creativecommons.org/licenses/by-nc-sa/3.0/
%
% October 2008
% Rev: Jan 2009

if nargin>2
    if sum(sum(imgOriginal))~=0
        imshow(imgOriginal,[0 255]);
        hold on;
    end
end
if nargin<4
    rSize=5;
end
if nargin<5
    scale=1;
end

for i=1:size(u,1)
    for j=1:size(u,2)
        if floor(i/rSize)~=i/rSize || floor(j/rSize)~=j/rSize
            u(i,j)=NaN;
           v(i,j)=NaN;
        end
    end
end


[x,y] = meshgrid(1:size(u,2), 1:size(u,1)); 

rem_index = isnan(u); 
u(rem_index) = []; 
v(rem_index) = []; 
y(rem_index) = []; 
x(rem_index) = []; 

quiver(x, y, u, v, scale, 'color', 'b', 'linewidth', 1);
set(gca,'YDir','reverse');