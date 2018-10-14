function [ PSNR,SSIM ] = metrics( img,gt )
img1=double(img); gt1=double(gt);
if length(size(img))==3
    [M,N,c]= size(img);
    MSE = sum(sum(sum((gt1-img1).^2)))/(M*N*c);
else
    [M,N] =size(img);
    MSE = sum(sum((gt1-img1).^2))/(M*N);
end
PSNR = 10*log10(255*255/MSE);

%SSIM = ssim(img,gt);

%alpha=beta=gamma=1 and C3=C2/2
C1=(0.01*255).^2;    C2 = (0.03*255).^2;
mu1= mean(gt1(:));   mu2= mean(img1(:));
sig12=mean((gt1(:)-mu1).*(img1(:)-mu2));
var1=mean((gt1(:)-mu1).^2);    
var2=mean((img1(:)-mu2).^2);  

SSIM = (2*mu1*mu2+C1)*(2*sig12+C2);
SSIM = SSIM/(mu1*mu1+mu2*mu2+C1);
SSIM = SSIM/(var1+var2+C2);

% img1=double(rgb2gray(img));   gt1=double(rgb2gray(gt));
% %alpha=beta=gamma=1 and C3=C2/2
% C1=(0.01*255).^2;    C2 = (0.03*255).^2;
% mu1= mean(gt1(:));   mu2= mean(img1(:));
% covar=cov(gt1,img1);   sig12=covar(1,2);
% var1=covar(1,1);     var2=covar(2,2);
% SSIM = (2*mu1*mu2+C1)*(2*sig12+C2);
% SSIM = SSIM/(mu1*mu1+mu2*mu2+C1);
% SSIM = SSIM/(var1+var2+C2);
end

