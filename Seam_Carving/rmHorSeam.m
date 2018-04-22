% File Name: rmHorSeam.m
% Author:
% Date:

function [Iy, E] = rmHorSeam(I, My, Tby)
% Input:
%   I is the image. Note that I could be color or grayscale image.
%   My is the cumulative minimum energy map along horizontal direction.
%   Tby is the backtrack table along horizontal direction.

% Output:
%   Iy is the image removed one row.
%   E is the cost of seam removal

% Write Your Code Here
row=size(I,1);%find dimension of input image
col=size(I,2);
dim=size(I,3);
Iy=zeros(row-1,col,dim);%preallocate output image
[minVal,minInd]=min(My(:,col));%find which index to start at the last column
E=minVal;
for i=1:dim
    for j=col:-1:1%going through each column and delete index that is part of the seam
        colVal=I(:,j,i);
        Iy(:,j,i)=[colVal(1:minInd-1);colVal(minInd+1:end)];
        minInd=minInd+Tby(minInd,j);
    end  
end
Iy=uint8(Iy);%cast return type to uint8
end