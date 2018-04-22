% File Name: rmVerSeam.m
% Author:
% Date:

function [Ix, E] = rmVerSeam(I, Mx, Tbx)
% Input:
%   I is the image. Note that I could be color or grayscale image.
%   Mx is the cumulative minimum energy map along vertical direction.
%   Tbx is the backtrack table along vertical direction.

% Output:
%   Ix is the image removed one column.
%   E is the cost of seam removal

% Write Your Code Here
row=size(I,1);%find dimension of input image
col=size(I,2);
dim=size(I,3);
Ix=zeros(row,col-1,dim);%preallocate return image 
[minVal,minInd]=min(Mx(row,:));
E=minVal;%find which index to start with on the last row
for i=1:dim
    for j=row:-1:1%going through each row and deleting out index that is part of the seam
        rowVal=I(j,:,i);
        Ix(j,:,i)=[rowVal(1:minInd-1),rowVal(minInd+1:end)];
        minInd=minInd+Tbx(j,minInd);
    end
end
Ix=uint8(Ix);%cast return type to uint8
end