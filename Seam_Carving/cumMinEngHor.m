% File Name: cumMinEngHor.m
% Author:
% Date:

function [My, Tby] = cumMinEngHor(e)
% Input:
%   e is the energy map.

% Output:
%   My is the cumulative minimum energy map along horizontal direction.
%   Tby is the backtrack table along horizontal direction.

% Write Your Code Here
[row,col]=size(e);%determine size of energy map
My=zeros(row+2,col);%expand My by two rows for edge pixels
My(1,:)=Inf;%fill added row with Inf
My(row+2,:)=Inf;
My(2:row+1,:)=e;%preallocate rest of My with energy map
Tby=zeros(row,col);%preallocate trace table
for j=2:col
topneighbor=My(1:row,j-1); %top neighbors are col to the left shift down one unit
centerneighbor=My(2:row+1,j-1);%center neighbors are col to the left
lowerneighbor=My(3:row+2,j-1);%lower neighbors are col to the left shift up one unit
[minVal,index]=min([topneighbor';centerneighbor';lowerneighbor']);%find minimum of three neigbors and record their index
My(2:row+1,j)=My(2:row+1,j)+minVal';%fill in My table and trace table with the result
Tby(:,j)=index'-2;
end
My=My(2:row+1,:);%clip two rows filled with Inf
end