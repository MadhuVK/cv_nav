function stats = drawareabox(stats)

M = size(stats, 1);
[rows columns] = size(stats(1).CoveredPixels); 
for k = 1:M
    stats(k).CoveredPixels = zeros(rows, columns); 
    x1 = floor(stats(k).BoundingDim(1));
    y1 = floor(stats(k).BoundingDim(2));
    if y1 == 0
        y1 = 1;
    end
    if x1 == 0
        x1 = 1;
    end
    if stats(k).BoundingDim(5) ~= 0
        stats(k).CoveredPixels(y1:y1+stats(k).BoundingDim(4),x1:x1+stats(k).BoundingDim(3)) = 1;
    end
end