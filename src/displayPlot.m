function displayPlot(groups, im)
PIX_SIDE = 20;
[y,z,misc] = size(im);
u = zeros(PIX_SIDE,PIX_SIDE); 
u = repmat(u, y/PIX_SIDE, z/PIX_SIDE); 
v = zeros(PIX_SIDE,PIX_SIDE); 
v = repmat(v, y/PIX_SIDE, z/PIX_SIDE); 

for i=1:(y/PIX_SIDE)
    for j=1:(z/PIX_SIDE) 
        u(1+(PIX_SIDE*(i-1)):(PIX_SIDE+(PIX_SIDE*(i-1))), 1+(PIX_SIDE*(j-1)):(PIX_SIDE+(PIX_SIDE*(j-1)))) = groups(i,j).uHat(1,1); 
        v(1+(PIX_SIDE*(i-1)):(PIX_SIDE+(PIX_SIDE*(i-1))), 1+(PIX_SIDE*(j-1)):(PIX_SIDE+(PIX_SIDE*(j-1)))) = groups(i,j).uHat(2,1); 
    end
end
plotFlow(u,v,im,5,5); 

end

