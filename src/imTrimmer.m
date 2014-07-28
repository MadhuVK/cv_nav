function image = imTrimmer(image)
%% Trim to have dimensions that are divisible by PIX_SIDE
% Change 20 value to set image dimension factor 
PIX_SIDE = 20;
imageDimensions = size(image); 
image(1+end-mod(imageDimensions(1), PIX_SIDE):end, :) = []; 
image(:, 1+end-mod(imageDimensions(2), PIX_SIDE):end) = []; 
end
