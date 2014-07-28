function IntegralImages = getIntegralImages(matrix)
% Make integral image for a given matrix
%
%
% Function is written by D.Kroon University of Twente (November 2010)
% Edited by Madhu Krishnan for use in Optical Flow


% Make the integral image for fast region sum look up
[rows columns] = size(matrix);
for i=1:rows
    for j=1:columns
        if isnan(matrix(i,j))
            matrix(i,j) = 0; 
        end
    end
end
sum=cumsum(cumsum(matrix,1),2);
IntegralImages.Sum = zeros(rows+1,columns+1);
IntegralImages.Sum(2:(rows+1),2:(columns+1)) = sum;

% Make integral image to calculate fast a local standard deviation of the
% pixel data
variance=cumsum(cumsum(matrix.^2,1),2);
IntegralImages.Variance = zeros(rows+1,columns+1);
IntegralImages.Variance(2:(rows+1),2:(columns+1)) = variance; 
