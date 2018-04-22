data1=imread('racoon.jpg');%change image file name to desired image 
data=data1;
[Ic, T] = carv(data, 30, 30);%fill in number of rows and columns to delete
imagesc(Ic);%plot result