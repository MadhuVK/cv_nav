function groups = createGroups(im1, im2)

STRING_SIZE = 9; % 1 Pixel chosen per 13
PIX_SIDE = 20; % Group side-length of 20

[perWidth perLength misc] = size(im2); % Third value accounts for true color images

[perWidth perLength] = deal(perWidth/PIX_SIDE, perLength/PIX_SIDE);
[fx fy ft] = computeDerivatives(im1, im2);

groups = struct('uHat', zeros(4,1), 'A', zeros(floor((PIX_SIDE^2)/STRING_SIZE), 2), ... 
    'b', zeros(floor((PIX_SIDE^2)/STRING_SIZE), 1)); % Struct containing u, A, and B vectors
groups = repmat(groups, perWidth, perLength); % Creates an array of groups

for i = 1:perWidth
    for j = 1:perLength
        groups(i, j).A = findA(extractValues(fx, i, j), extractValues(fy, i, j)); %Stores the A matrix for the 20x20 region
        groups(i, j).b = findb(extractValues(ft, i, j));  %Stores the b matrix for the 20x20 region
        groups(i, j).uHat = finduHat(groups(i, j).A, groups(i, j).b);  %Calculates and stores u_hat matrix for the 20x20 region
    end
end 

end 

function extractedValues = extractValues(matrix, iIt, jIt)
STRING_SIZE = 9;
PIX_SIDE = 20;

extractedValues = matrix((PIX_SIDE*iIt)-(PIX_SIDE-1):(PIX_SIDE*iIt), ...
    (PIX_SIDE*jIt)-(PIX_SIDE-1):(PIX_SIDE*jIt)); % Takes a 20x20 square of values  

pixelsTraversed = 1; 
for i = 1:PIX_SIDE
    for j = 1:PIX_SIDE
        if (mod(pixelsTraversed,STRING_SIZE) ~= 0)  
            extractedValues(i,j) = NaN; 
        end 
        pixelsTraversed = pixelsTraversed + 1; 
    end 
end 

end 

function A = findA(xLocation, yLocation)
xLocation = xLocation';
yLocation = yLocation'; 
A(:,1) = xLocation(~isnan(xLocation)); % Stores all values not equal to 0 to the first column
A(:,2) = yLocation(~isnan(yLocation)); % Same thing for the second column
end 

function b = findb(tLocation)
tLocation = tLocation'; 
b(:,1) = -tLocation(~isnan(tLocation)); 
end 

function uHat = finduHat(A, b) 
% Returns a matrix which contains uHat, its magnitude, and variance
if ((det((A')*A) == 0)|| (mean(reshape(abs(A),[],1)) <= .01) || (mean(reshape(abs(b),[],1)) <= .01))
    uHat(1:4,1) = NaN; 

else 
    uHat = ((A')*A)\((A')*b);  
    uHat(3,1) = norm(uHat(1:2)); % Magnitude of the x and y vectors
    uHat(4,1) = calculateVariance(A, b, uHat(1:2,1)); % Variance of the first two vectors
	uHat = RHV(uHat);
end 
end 

function variance = calculateVariance(A, b, u)
STRING_SIZE = 9;
PIX_SIDE = 20;
e = (A*u)-b; 
lambda = abs(min(eig(A'*A))); 
variance = (e'*e)/(((PIX_SIDE^2)/STRING_SIZE)*lambda); % Returns a single value
end

function uHat = RHV(uHat)
MAX_VARIANCE = 2;
% Sets uHat vectors with high variability as NaNs
if uHat(4) > MAX_VARIANCE
	uHat(1:3) = NaN; 
end
end