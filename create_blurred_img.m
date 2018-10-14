clear all;close all;clc;

f = imread('GroundTruth\GroundTruth1_1_1.jpg');
[M,N,c]=size(f);
figure,imshow(f);
f=double(f);

h = imread('Kernals\Ker1_3d.png');
h=double(h);
[A,B]=size(h);

F=fft2(f);
H=fft2(h,M,N);
Y=F.*H;
y1=real(ifft2(Y));
y=mat2gray(y1);
fi= uint8(y*255);
figure,imshow(fi);
imwrite(fi,'img_blurry.jpg','jpg');


