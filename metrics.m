function [ PSNR,SSIM ] = metrics( img,gt )
%converting to double for computations
img1=double(img); %restored image 
gt1=double(gt);  %ground truth image
if length(size(img))==3  %for color image
    [M,N,c]= size(img);
    MSE = sum(sum(sum((gt1-img1).^2)))/(M*N*c);  %mean square error
else  %for grayscale image
    [M,N] =size(img);
    MSE = sum(sum((gt1-img1).^2))/(M*N);  %mean square error
end
PSNR = 10*log10(255*255/MSE); %PSNR in dB

% taking standard values for the constants
%alpha=beta=gamma=1 and C3=C2/2
C1=(0.01*255).^2;    C2 = (0.03*255).^2; %Std. constant values
mu1= mean(gt1(:));   %mean of ground truth
mu2= mean(img1(:));  %mean of restored image
sig12=mean((gt1(:)-mu1).*(img1(:)-mu2)); %covariance 
var1=mean((gt1(:)-mu1).^2);  %variance of ground truth
var2=mean((img1(:)-mu2).^2);  %variance of restored image

%implementing simplified formula for SSIM
SSIM = (2*mu1*mu2+C1)*(2*sig12+C2);
SSIM = SSIM/(mu1*mu1+mu2*mu2+C1);
SSIM = SSIM/(var1+var2+C2);

end

