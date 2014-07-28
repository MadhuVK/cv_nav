function [u v] = reverseValues(groups)
PIX_SIDE = 20;

[perWidth perLength] = size(groups);


for i = 1:perWidth
    for j = 1:perLength
        u((PIX_SIDE*i)-(PIX_SIDE-1):(PIX_SIDE*i), (PIX_SIDE*j)-(PIX_SIDE-1):(PIX_SIDE*j)) = groups(i,j).u;
        v((PIX_SIDE*i)-(PIX_SIDE-1):(PIX_SIDE*i), (PIX_SIDE*j)-(PIX_SIDE-1):(PIX_SIDE*j)) = groups(i,j).v;
    end
end 

end 