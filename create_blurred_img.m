clear all;close all;clc;

f = imread('GroundTruth\GroundTruth1_1_1.jpg'); %load ground truth image
[M,N,c]=size(f);
figure,imshow(f);
f=double(f);

h = imread('Kernals\Ker1_3d.png');  %load kernel
h=double(h);
[A,B]=size(h);

F=fft2(f);    %taking FFT
H=fft2(h,M,N);
Y=F.*H;        %Convoltion in time = Multiplication in frequency
y1=real(ifft2(Y));
y=mat2gray(y1);  %scaling to 0 to 1
fi= uint8(y*255);  %scaling to 0-255 and displayin uint8 format
figure,imshow(fi);
imwrite(fi,'img_blurry.jpg','jpg'); %saving the created blurred image


