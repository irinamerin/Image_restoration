%EE 610 Image Processing
%Assignment-2: Image Restoration
%Author: Irina Merin Baby

function varargout = ImageRestoration(varargin)
% Initialization of code 
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageRestoration_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageRestoration_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code


% --- Executes just before ImageRestoration is made visible.
function ImageRestoration_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImageRestoration (see VARARGIN)
% Choose default command line output for ImageRestoration
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = ImageRestoration_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in LoadButton.
function LoadButton_Callback(hObject, eventdata, handles)
global img F M N s1
s1=1; %no. of channels of blurred image
[filename,user_cancel]=imgetfile(); %open file selector to input image
if user_cancel  %if user cancels loading operation
    msgbox(sprintf('Error'),'Error','Error'); %error message displayed
    return
end
img=imread(filename); % reading the selected image
img_org=img; %Seting img_org as the loaded image

if length(size(img))==3 %Color image is 3D matrix
   [M,N,s1]=size(img);%If color image
else
    [M,N]=size(img);
end   
axes(handles.axes1); %axes1 loaded blurred image always
imshow(img_org);     
axes(handles.axes2); %axes2 restored image
imshow(img_org);     %blurred image initially
img_org=double(img_org); %converting to double type for computations 
F=fft2(img_org); %FFT of blurred image

% --- Executes on button press in LoadKerButton.
function LoadKerButton_Callback(hObject, eventdata, handles)
global ker s2
s2=1;   %no. of channels of kernel
[filename,user_cancel]=imgetfile(); %open file selector to input kernel
if user_cancel  %if user cancels loading operation
    msgbox(sprintf('Error'),'Error','Error'); %error message displayed
    return
end
ker=imread(filename); % reading the selected kernel
if length(size(ker))==3 %Color image is 3D matrix
   s2=3;  %If color image, set s2 to 3 
end   
axes(handles.axes3); %axes3 kernel
imshow(ker);      
ker=double(ker);



% --- Executes on button press in InvButton.
function InvButton_Callback(hObject, eventdata, handles)
global img F M N s1 ker s2 gt
H=fft2(ker,M,N); %FFT of kernel with zero padding
if s1==3 && s2==1  %resizing the kernel according to blur image
    H=repmat(H,1,1,3);  
elseif s1==1 && s2==3
    H=H(:,:,1);
end
Y1=F./H;  %inverse filtering
img=real(ifft2(Y1));
img=uint8(mat2gray(img)*255); %scaling and displaying in uint8 format
axes(handles.axes2) %display restored image in axes2 
imshow(img);
[PSNR,SSIM]=metrics(gt,img); %to get PSNR and SSIM and displaying
set(handles.text7,'Visible','on');
set(handles.text8,'Visible','on');
set(handles.text7,'String',PSNR); 
set(handles.text8,'String',SSIM);


% --- Executes on button press in TruncButton.
function TruncButton_Callback(hObject, eventdata, handles)
global img F M N s1 ker s2 gt
H=fft2(ker,M,N); %FFT of kernel with zero padding
if s1==3 && s2==1   %resizing the kernel according to blur image
    H=repmat(H,1,1,3);
elseif s1==1 && s2==3
    H=H(:,:,1);
end
Y1=F./H; %inverse filtering
%Initialising prompt window values for input radius of truncation
prompt={'Enter the radius for Radially Truncated Filter:'};
name='Radius of Truncation'; % name of window opened
r=str2double(inputdlg(prompt,name,[1 60],{'100'})); %default value=100

HH=Butter_LPF(M,N,r,10); %getting LPF in freq domain
HH=fftshift(HH); %to decentalise the spectrum
if s1==3   % repeating for three channels
HH=repmat(HH,1,1,3);
end
Y2=Y1.*HH;  %truncated inverse filtering

img=real(ifft2(Y2));
img=uint8(mat2gray(img)*255);%scaling and displaying in uint8 format
axes(handles.axes2) %display restored image in axes1 
imshow(img);
[PSNR,SSIM]=metrics(gt,img); %to get PSNR and SSIM and displaying
set(handles.text7,'Visible','on');
set(handles.text8,'Visible','on');
set(handles.text7,'String',PSNR);
set(handles.text8,'String',SSIM);


% --- Executes on button press in WienerButton.
function WienerButton_Callback(hObject, eventdata, handles) 
global img F M N s1 ker s2 gt
H=fft2(ker,M,N);%FFT of kernel with zero padding
if s1==3 && s2==1   %resizing the kernel according to blur image
    H=repmat(H,1,1,3);
elseif s1==1 && s2==3
    H=H(:,:,1);
end

%Initialising prompt window values for K value
prompt={'Enter the K value for Wiener Filter:'};
name='K value'; % name of window opened
K=str2double(inputdlg(prompt,name,[1 60],{'0.8'})); %default value=0.8

Y1=F./H;
Habs=abs(H).^2;
Y3= (Y1.*Habs)./(Habs+K); %Wiener filtering

img=real(ifft2(Y3));
img=uint8(mat2gray(img)*255);%scaling and displaying in uint8 format
axes(handles.axes2) %display restored image in axes1 
imshow(img);
[PSNR,SSIM]=metrics(gt,img); %to get PSNR and SSIM and displaying
set(handles.text7,'Visible','on');
set(handles.text8,'Visible','on');
set(handles.text7,'String',PSNR);
set(handles.text8,'String',SSIM);


% --- Executes on button press in ClsButton.
function ClsButton_Callback(hObject, eventdata, handles)
global img F M N s1 ker s2 gt
H=fft2(ker,M,N); %FFT of kernel with zero padding
if s1==3 && s2==1 %resizing the kernel according to blur image
    H=repmat(H,1,1,3);
elseif s1==1 && s2==3
    H=H(:,:,1);
end
p=[0,-1,0;-1,4,-1;0,-1,0]; %Laplacian operator
P=fft2(p,M,N); %Its fft
if s1==3     % repeating for three channels
    P=repmat(P,1,1,3);
end

%Initialising prompt window values for gamma value
prompt={'Enter the gamma value for Constrained Least Squares Filter:'};
name='Gamma value'; % name of window opened
gamma=str2double(inputdlg(prompt,name,[1 60],{'0.8'})); %default value=0.8

Habs=abs(H).^2;
Pabs=abs(P).^2;
Y4=F.*conj(H);
Y4= Y4./(Habs+gamma*Pabs); %Constrained least squares filtering

img=real(ifft2(Y4));
img=uint8(mat2gray(img)*255); %scaling and displaying in uint8 format
axes(handles.axes2) %display restored image in axes1 
imshow(img);
[PSNR,SSIM]=metrics(gt,img); %to get PSNR and SSIM and displaying
set(handles.text7,'Visible','on');
set(handles.text8,'Visible','on');
set(handles.text7,'String',PSNR);
set(handles.text8,'String',SSIM);

% --- Executes on button press in EstButton.
function EstButton_Callback(hObject, eventdata, handles)
global img F M N s1 ker s2
set(handles.text7,'Visible','off'); %PSNR and SSIM can't be found for
set(handles.text8,'Visible','off'); %etimated blur cases 
cla(handles.axes4);  %Clearing ground truth display as it is notb available
s2=1;
[filename,user_cancel]=imgetfile(); %open file selector to input estimated kernel
if user_cancel  %if user cancels loading operation
    msgbox(sprintf('Error'),'Error','Error'); %error message displayed
    return
end
ker=imread(filename); % reading the selected kernel
if length(size(ker))==3 %Color image is 3D matrix
   s2=3;  %If color image, set s2=3 
end   
axes(handles.axes3); %axes3 estimated kernel image
imshow(ker);     
ker=double(ker); %for computations
H=fft2(ker,M,N);  %FFT of kernel with zero padding
if s1==3 && s2==1 %resizing the kernel according to blur image
    H=repmat(H,1,1,3);
elseif s1==1 && s2==3
    H=H(:,:,1);
end
Y1=F./H; %inverse filtering
%Initialising prompt window values for input radius of truncation
prompt={'Enter the radius for Radially Truncated Filter:'};
name='Radius of Truncation'; % name of window opened
r=str2double(inputdlg(prompt,name,[1 60],{'100'})); %default value=100

HH=Butter_LPF(M,N,r,10);%getting LPF in freq domain
HH=fftshift(HH); %to decentalise the spectrum
if s1==3   % repeating for three channels
HH=repmat(HH,1,1,3);
end
Y2=Y1.*HH; %truncated inverse filtering

img=real(ifft2(Y2));
img=uint8(mat2gray(img)*255); %scaling and displaying in uint8 format
axes(handles.axes2) %display restored image in axes2 
imshow(img);



% --- Executes on button press in GtButton.
function GtButton_Callback(hObject, eventdata, handles)
global gt
[filename,user_cancel]=imgetfile(); %open file selector to ground truth image
if user_cancel  %if user cancels loading operation
    msgbox(sprintf('Error'),'Error','Error'); %error message displayed
    return
end
gt=imread(filename); % reading the selected ground truth image
axes(handles.axes4); %axes4 ground truth image
imshow(gt);      



% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
global img %restored image, ie., image in axes2 is saved
[fn, ext, ucancel] = imputfile; %opens up file selector for user to specify path of saved image
imwrite(img,fn); %write image to the selected folder
