function stats = drawboundingbox(stats)
M = size(stats, 1);
[rows columns] = size(stats(1).BoundedBox); 
for k = 1:M
    stats(k).BoundedBox = zeros(rows, columns); 
    x1 = floor(stats(k).BoundingDim(1));
    y1 = floor(stats(k).BoundingDim(2));
    if y1 == 0
        y1 = 1;
    end
    if x1 == 0
        x1 = 1;
    end
    stats(k).BoundedBox(y1:y1+stats(k).BoundingDim(4),x1) = 1;
    stats(k).BoundedBox(y1:y1+stats(k).BoundingDim(4),x1+stats(k).BoundingDim(3)) = 1;
    stats(k).BoundedBox(y1,x1:x1+stats(k).BoundingDim(3)) = 1;
    stats(k).BoundedBox(y1+stats(k).BoundingDim(4),x1:x1+stats(k).BoundingDim(3)) = 1;
end