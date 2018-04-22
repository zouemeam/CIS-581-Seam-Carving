% File Name: cumMinEngVer.m
% Author:
% Date:

function [Mx, Tbx] = cumMinEngVer(e)
% Input:
%   e is the energy map

% Output:
%   Mx is the cumulative minimum energy map along vertical direction.
%   Tbx is the backtrack table along vertical direction.

% Write Your Code Here
[row,col]=size(e);%determine size of energy map
Mx=zeros(row,col+2);%expand Mx by two columns for edge pixels 
Tbx=zeros(row,col);%preallocate trace table
Mx(:,2:col+1)=e;%preallocate most of Mx table with energy map
Mx(:,1)=Inf;%fill in left most and right most columns with Inf
Mx(:,col+2)=Inf;%
for i=2:row
leftneighbor=Mx(i-1,1:col);%left neighbors are row above shifted to the right  
centerneighbor=Mx(i-1,2:col+1);%center neighbors are row above 
rightneighbor=Mx(i-1,3:col+2);%right neighbors are row above shifted to the left
[minVal,index]=min([leftneighbor;centerneighbor;rightneighbor]);%find mininum of three neighbors and corresponding index
Mx(i,2:col+1)=Mx(i,2:col+1)+minVal;%fill in Mx table and trace table with the result
Tbx(i,:)=index-2;
end
Mx=Mx(:,2:col+1);%clip two columns filled with Inf
end