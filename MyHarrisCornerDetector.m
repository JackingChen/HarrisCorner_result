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

%tunable parameter: 1. gradient filter. 2. r 3. threshold

%%
% parameters
% corner response related
sigma=2;
n_x_sigma = 6;
alpha = 0.04;
% maximum suppression related
Thrshold=150;  % should be between 0 and 1000
r=2; 


%%
% filter kernels
% dx = [-1 0 0 0 0 0 1; -1 0 0 0 0 0 1; -1 0 0 0 0 0 1];
% dx = [-1 0 0 0 1; -1 0 0 0 1; -1 0 0 0 1];
dx = [-1 0 1; -1 0 1; -1 0 1]; % horizontal gradient filter 
dy = dx'; % vertical gradient filter


g = fspecial('gaussian',max(1,fix(2*n_x_sigma*sigma)), sigma); % Gaussien Filter: filter size 2*n_x_sigma*sigma


%% load 'Im.jpg'
frame = imread('data/Im.jpg');
I = double(frame);
%figure(1);
%imagesc(frame);
[xmax, ymax,ch] = size(I);
xmin = 1;
ymin = 1;


%%%%%%%%%%%%%%Intrest Points %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

img_grey = rgb2gray(frame);
%%%%%%
% get image gradient
% [Your Code here] 
% calculate Ix
Ix=my_imfilter(img_grey,dx);
% calcualte Iy
Iy=my_imfilter(img_grey,dy);
%%%%%
% get all components of second moment matrix M = [[Ix2 Ixy];[Iyx Iy2]]; note Ix2 Ixy Iy2 are all Gaussian smoothed
% [Your Code here] 
% calculate Ix2  
Ix2=my_imfilter(Ix,dx);
% calculate Iy2
Iy2=my_imfilter(Iy,dy);
% calculate Ixy
Ixy=my_imfilter(Ix,dy);
Iyx=Ixy;
%%%%%

%% visualize Ixy
figure(2);
imagesc(Ixy);

%%%%%%% Demo Check Point -------------------


%%%%%
% get corner response function R = det(M)-alpha*trace(M)^2 
% [Your Code here] 
% calculate R

for j=1:length(Ix(:,1,1))
    for i=1:length(Ix(1,:,1))
        M=[Ix2(j,i) Ixy(j,i);Iyx(j,i) Iy2(j,i)];
        R(j,i)=det(M)-alpha*trace(M)^2 ;
    end
end
%%%%%

%% make R value range from 0 to 1000
R=(1000/max(max(R)))*R;%
%filter R
for i=1:length(R(:,1))
    for j=1:length(R(1,:))
        if R(i,j)<Thrshold
            R(i,j)=0;
        end
    end
end

%%%%%
%% using B = ordfilt2(A,order,domain) to complment a maxfilter
sze = 2*r+1; % domain width 
% [Your Code here] 
% calculate MX
mask=true(sze);
mask(floor(sze^2/2)+1)=0;
%**********
% make the mask look like 
% 111
% 101
% 111
% 
% All true except false in the middle
%reference: http://stackoverflow.com/questions/22218037/how-to-find-local-maxima-in-image
%**********

MX=ordfilt2(R,sze^2-1,mask);
%%%%%
% figure(3)
% imshow(R)
% figure(4)
% imshow(MX)
%%%%%
% find local maximum.
% [Your Code here] 
% calculate RBinary
RBinary = MX>R;
%%%%%


%% get location of corner points not along image's edges
offe = r-1;
count=sum(sum(RBinary(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe))); % How many interest points, avoid the image's edge   
R=R*0;
R(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe)=RBinary(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe);
[r1,c1] = find(R);
PIP=[r1,c1]; % IP , 2d location ie.(u,v)
  

%% Display
figure(5)
imagesc(uint8(I));
hold on;
plot(c1,r1,'or');
return;
