% File Name: carv.m
% Author:
% Date:

function [Ic, T] = carv(I, nr, nc)
% Input:
%   I is the image being resized
%   [nr, nc] is the numbers of rows and columns to remove.
% 
% Output: 
% Ic is the resized image
% T is the transport map

% Write Your Code Here
row=size(I,1);%find size of input image
col=size(I,2);
dim=size(I,3);
Ic=zeros(row-nr, col-nc, dim);%preallocate return image
T=zeros(nr+1,nc+1);%create a value table to store cost of seam removal 
TI=T;%create a trace table to track whether horizontal or vertical seam should be removed next 
images=cell(nr+1,nc+1);%create a image table to store intermediate seam removal images
images{1,1}=I;%preallocate the starting start image as the input image
current=I;
for i=2:nr+1%fill the first row of tables by deleting horizontal seams until desired number of row is achieved
    e=genEngMap(current);
    [My,Tby]=cumMinEngHor(e);
    [Iy,E]=rmHorSeam(current,My,Tby);
    current=Iy;
    T(i,1)=T(i-1,1)+E;
    TI(i,1)=0;
    images{i,1}=Iy;
end

current=I;%fill the first column of tables by deleteing vertical seams until desired number of columns is achieved
for i=2:nc+1
    e=genEngMap(current);
    [Mx,Tbx]=cumMinEngVer(e);
    [Ix,E]=rmVerSeam(current,Mx,Tbx);
    current=Ix;
    T(1,i)=T(1,i-1)+E;
    TI(1,i)=1;
    images{1,i}=Ix;
end

Img=I;%To fill in rest of tables we start with the input image with one column and one row removed
e=genEngMap(Img);
[My,Tby]=cumMinEngHor(e);
[Img,~]=rmHorSeam(Img,My,Tby);
e=genEngMap(Img);
[Mx,Tbx]=cumMinEngVer(e);
[Img,~]=rmVerSeam(Img,Mx,Tbx);


for i=2:nr+1
    state=Img;
    for j=2:nc+1%going left to right calculate and compare costs of vertical and horizontal seam removal
        e=genEngMap(state);
        [My,Tby]=cumMinEngHor(e);
        [rowdel,erow]=rmHorSeam(state,My,Tby);
        [Mx,Tbx]=cumMinEngVer(e);
        [coldel,ecol]=rmVerSeam(state,Mx,Tbx);
        [cost,ind]=min([T(i-1,j)+erow,T(i,j-1)+ecol]);
        T(i,j)=cost;
        TI(i,j)=ind-1;
        if ind-1==1%1 means vertical seam removal 
            images{i,j}=coldel;
        else%0 means horizontal seam removal 
            images{i,j}=rowdel;
        end
        state=coldel;
    end
    e=genEngMap(Img);%reduce the number of row by one when all image size with that row number has been explored
    [My,Tby]=cumMinEngHor(e);
    [Img,~]=rmHorSeam(Img,My,Tby);
end
k=nr+nc;%find the number of seam removal operations between start and finish 
currentx=nc+1;%define current position on trace and images table
currenty=nr+1;
resized=cell(k,1);%preallocate cell to contain intermediate images from start to finish
for m=k:-1:1%backtrack from last column and last row position on trace table to find intermediate images
    operation=TI(currenty, currentx);
    padcurrentImg=[];
    if operation==1
        currentx=currentx-1;
        currentImg=images{currenty,currentx};
        rowc=size(currentImg,1);
        colc=size(currentImg,2);
        padcurrentImg(:,:,1)=padarray(currentImg(:,:,1),[row-rowc,col-colc],0,'post');
        padcurrentImg(:,:,2)=padarray(currentImg(:,:,2),[row-rowc,col-colc],0,'post');
        padcurrentImg(:,:,3)=padarray(currentImg(:,:,3),[row-rowc,col-colc],0,'post');
        resized{m,1}=padcurrentImg;
    else 
        currenty=currenty-1;
        currentImg=images{currenty,currentx};
        rowc=size(currentImg,1);
        colc=size(currentImg,2);
        padcurrentImg(:,:,1)=padarray(currentImg(:,:,1),[row-rowc,col-colc],0,'post');
        padcurrentImg(:,:,2)=padarray(currentImg(:,:,2),[row-rowc,col-colc],0,'post');
        padcurrentImg(:,:,3)=padarray(currentImg(:,:,3),[row-rowc,col-colc],0,'post');
        resized{m,1}=padcurrentImg;
    end
end
Ic=uint8(images{nr+1,nc+1});%type cast return varible to uint8
videoCreation(resized);%create a video using intermediate images
end



