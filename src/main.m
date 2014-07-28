function [minTTC column] = main(video)
startTime = tic; 
%% Read Video and extract images
%Assumes vid has been started and set beforehand
vid = video.vid;
x = vid.FramesAcquired; 
im1 = getsnapshot(vid);
while(1)
    if vid.FramesAcquired-x>=2 % Stop after 2 aquired images
      im2 = getsnapshot(vid);
      break;
    end
end
%% Initialization 
% Compare every 5 Frames 
im1 = imTrimmer(rgb2gray(im1)); 
im2 = imTrimmer(rgb2gray(im2));

[vidHeight vidWidth] = size(im1);
 
[uOrig vOrig] = HS(im1, im2, 1, 5);

%% Find and thicken a Sobel binary image 

sobelImage = edge(im1, 'sobel'); 
thickSobel = zeros(vidHeight, vidWidth);
for i=3:(vidHeight-3)
    for j=3:(vidWidth-3)
        if sobelImage(i,j) == 1
            if (i > 2 && j > 2)
                thickSobel(i-2:i+2, j-2:j+2) = 1;
            elseif (i > 2 && j <= 2)
                thickSobel(i-2:i+2, j+2) = 1;
            elseif (i <= 2 && j <= 2)
                thickSobel(i:i+2, j+j+2) = 1; 
            elseif (i <= 2 && j > 2)
                thickSobel(i:i+2, j-3:j+2) = 1;
            end
        end
    end
end
thickSobel = logical(thickSobel);
clearvars sobelImage 
%% Draw bounding boxes around objects 

stats = regionprops(thickSobel, 'BoundingBox');
objects = struct('BoundingDim', zeros(1,5), 'CoveredPixels', zeros(vidHeight, vidWidth), ...
                        'BoundedBox', zeros(vidHeight, vidWidth), 'TTC', zeros(1,1));

objects = repmat(objects, size(stats, 1), 1);
for i=1:size(objects, 1)
    objects(i).BoundingDim = stats(i).BoundingBox;
    objects(i).BoundingDim(1,5) = stats(i).BoundingBox(1,4)*stats(i).BoundingBox(1,3);

end
clearvars stats 

objects = drawareabox(objects);

%% Remove small objects
largestArea = 0;
for i=1:size(objects, 1)
    if objects(i).BoundingDim(1,5) > largestArea
        largestArea = objects(i).BoundingDim(1,5);
    end
end

AREA_THRESHOLD = .2;

n = size(objects,1);
for i=n:-1:1
    if (objects(i).BoundingDim(1,5)/largestArea) < AREA_THRESHOLD
        objects(i) = [];
    end
end
clearvars AREA_THRESHOLD largestArea 
%% Combine overlapping objects
THRESHOLD = .95;
n = size(objects,1);
for i=n:-1:1
    if objects(i).BoundingDim(5) == 0
        continue; 
    end
    originalArrayArea = reshape(objects(i).CoveredPixels, vidWidth*vidHeight, 1);
    originalArrayArea = size(originalArrayArea(originalArrayArea ~= 0), 1);
    for j=1:size(objects,1)
        if j~=i
            combinedArray = objects(i).CoveredPixels .* objects(j).CoveredPixels;
            combinedArrayArea = reshape(combinedArray, vidHeight * vidWidth, 1);
            combinedArrayArea = size(combinedArrayArea(combinedArrayArea ~= 0), 1); 

            if combinedArrayArea/originalArrayArea > THRESHOLD
               objects(i) = [];
            end
        end
    end
end

clearvars THRESHOLD originalArrayArea combinedArrayArea combinedArray
objects = drawboundingbox(objects);

%% Calculate Time to Collision 
maxIndex = 1; 
for i=1:size(objects, 1)
    if objects(i).BoundingDim(5) == 0 
        continue;
    end
    xVars = uOrig .* objects(i).CoveredPixels; 
    yVars = vOrig .* objects(i).CoveredPixels; 
    magnitude = sqrt(xVars.*yVars); 
    averageMagnitudes = mean(magnitude(magnitude~=0)); 
    if averageMagnitudes > averageMagnitudes(maxIndex)
        maxIndex = i; 
    end
end

FOEx = vidWidth/2;
FOEy = vidHeight/2;
clearvars maxIndex magnitude averageMagnitudes 
for i=1:size(objects,1)
    if objects(i).BoundingDim(5) == 0 
        continue;
    end
    TTC = zeros(vidHeight, vidWidth);
    xVars = uOrig .* objects(i).CoveredPixels; 
    yVars = vOrig .* objects(i).CoveredPixels; 

    for j=1:vidHeight
        for k=1:vidWidth
            if objects(i).CoveredPixels(j,k) ~= 0
                x = FOEx - j; 
                y = FOEy - k; 
                dist = sqrt(x^2 + y^2); 
                squareGradient  = sqrt(xVars(j,k)^2 + yVars(j,k)^2); 
                TTC(j,k) = dist/squareGradient;
            end
        end
    end
    TTC = mean(TTC(TTC~=0));
    objects(i).TTC = TTC; 
end

%% Return Outputs
minIndex = 1;
TTC = zeros(size(objects,1),1);
for i=1:size(objects, 1) 
    TTC(i) = objects(i).TTC; 
    if TTC(minIndex) > TTC(i)
        minIndex = i; 
    end
end

NUM_COLUMNS = 72; 
minTTC = min(TTC);
column = floor((objects(minIndex).BoundingDim(2) + objects(minIndex).BoundingDim(4))/NUM_COLUMNS); 
%% End
toc(startTime);
clearvars startTime i j k n xVars yVars c u0 v0 gmags VARIANCE_MAX mov z m n l stats FOEv CLUSTER_VALUE IDNEW kValues endTime x y dist squareGradient; 
end