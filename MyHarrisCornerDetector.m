% My Harris detector
% The code calculates
% the Harris Feature/Interest Points (FP or IP) 
% 
% When u execute the code, the test image file opened
% and u have to select by the mouse the region where u
% want to find the Harris points, 
% then the code will print out and display the feature
% points in the selected region.
% You can select the number of FPs by changing the variables 
% max_N & min_N

%%%
%corner : significant change in all direction for a sliding window
%%%

%%
% parameters
% corner response related
sigma=2;
n_x_sigma = 6;
alpha = 0.04;
% maximum suppression related
Thrshold=20;  % should be between 0 and 1000
r=6; 


%%
% filter kernels
dx = [-1 0 1; -1 0 1; -1 0 1]; % horizontal gradient filter 
dy = dx'; % vertical gradient filter
g = fspecial('gaussian',max(1,fix(2*n_x_sigma*sigma)), sigma); % Gaussien Filter: filter size 2*n_x_sigma*sigma


%% load 'Im.jpg'
frame = imread('data/Im.jpg');
I = double(frame);
figure(1);
imshow(frame);
[xmax, ymax,ch] = size(I);
xmin = 1;
ymin = 1;


%%%%%%%%%%%%%%Intrest Points %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%
% get image gradient
% [Your Code here] 
Ix = conv2(I(xmin:xmax,ymin:ymax), dx, 'same'); % calculate Ix
Iy = conv2(I(xmin:xmax,ymin:ymax), dy, 'same'); % calcualte Iy
%%%%%
% get all components of second moment matrix M = [[Ix2 Ixy];[Iyx Iy2]]; note Ix2 Ixy Iy2 are all Gaussian smoothed
% [Your Code here] 
Ix2 = conv2(Ix.^2, g, 'same'); % calculate Ix2  
Iy2 = conv2(Iy.^2, g, 'same'); % calculate Iy2
Ixy = conv2(Ix.*Iy, g,'same'); % calculate Ixy
%%%%%

%% visualize Ixy
figure(2);
imshow(Ixy);

%%%%%
% get corner response function R = det(M)-alpha*trace(M)^2 
% [Your Code here] 
R = (Ix2.*Iy2 - Ixy.^2) - alpha*(Ix2 + Iy2).^2;   % calculate R
%%%%%

%% make R value range from 0 to 1000
R=(1000/max(max(R)))*R;%

%% using B = ordfilt2(A,order,domain) to complment a maxfilter
sze = 2*r+1; 
MX = ordfilt2(R,sze^2,ones(sze));

%%%%%
% find local maximum.
% [Your Code here] 
R11 = (R==MX)&(R>Thrshold); 
%%%%%


%% get location of corner points not along image's edges
count=sum(sum(R11(5:size(R11,1)-5,5:size(R11,2)-5)));   %How many interest points, avoid the image's edge   
R=R*0;
R(5:size(R11,1)-5,5:size(R11,2)-5)=R11(5:size(R11,1)-5,5:size(R11,2)-5);
[r1,c1] = find(R);
PIP=[r1,c1]%% IP , 2d location ie.(u,v)
  

%% Display
Size_PI=size(PIP,1);
for r=1: Size_PI
   I(PIP(r,1)-2:PIP(r,1)+2,PIP(r,2)-2)=255;
   I(PIP(r,1)-2:PIP(r,1)+2,PIP(r,2)+2)=255;
   I(PIP(r,1)-2,PIP(r,2)-2:PIP(r,2)+2)=255;
   I(PIP(r,1)+2,PIP(r,2)-2:PIP(r,2)+2)=255;
end
figure(3)
imshow(uint8(I))