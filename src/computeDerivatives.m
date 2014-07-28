function [fx, fy, ft] = computeDerivatives(im1, im2)

if size(im2,1)==0
    im2=zeros(size(im1));
end

%% Convert images to grayscale
if size(size(im1),2)==3
    im1 = rgb2gray(im1);
end 
if size(size(im2),2)==3
    im2 = rgb2gray(im2);
end
im1 = imTrimmer(im1);
im2 = imTrimmer(im2);
im1 = smoothImg(double(im1), 1);
im2 = smoothImg(double(im2), 1);

%% Horn-Schunck original method
fx = conv2(im1, 0.25*[-1 1; -1 1], 'same') + conv2(im2, 0.25*[-1 1; -1 1], 'same');
fy = conv2(im1, 0.25*[-1 -1; 1 1], 'same') + conv2(im2, 0.25*[-1 -1; 1 1], 'same');
ft = conv2(im1, 0.25*ones(2),'same') + conv2(im2, -0.25*ones(2),'same');
end 
