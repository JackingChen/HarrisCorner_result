% Harris detector
% The code calculates
% the Harris Feature Points(FP) 
% 
% When u execute the code, the test image file opened
% and u have to select by the mouse the region where u
% want to find the Harris points, 
% then the code will print out and display the feature
% points in the selected region.
% You can select the number of FPs by changing the variables 
% max_N & min_N
% A. Ganoun

%%%
%corner : significant change in all direction for a sliding window
%What's the different between gca and gcf?????
%%%

%load 'Im.jpg'
frame = imread('Im.jpg');
I = double(frame);
%****************************
imshow(frame);
[xmax, ymax,ch] = size(I);
xmin = 1;
ymin = 1;

%***********************************
Aj=6; min_N=12; max_N=160;
%%%%%%%%%%%%%%Intrest Points %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sigma=2; Thrshold=20; r=6; disp=1;
dx = [-1 0 1; -1 0 1; -1 0 1]; % The Mask 
dy = dx';
%%%%%% 
Ix = conv2(I(xmin:xmax,ymin:ymax), dx, 'same');%same dimension as I(cmin:cmax,rmin:rmax).
Iy = conv2(I(xmin:xmax,ymin:ymax), dy, 'same');
g = fspecial('gaussian',max(1,fix(6*sigma)), sigma); %%%%%% Gaussien Filter
    
%%%%% 
Ix2 = conv2(Ix.^2, g, 'same');  
Iy2 = conv2(Iy.^2, g, 'same');
Ixy = conv2(Ix.*Iy, g,'same');
figure(2);
imshow(Ixy);

%%%%%%%%%%%%%%
% .*:scalar multiplication
k = 0.04;
R11 = (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Iy2).^2;   %det - k * trace^2
R11=(1000/max(max(R11)))*R11;%
R=R11;
ma=max(max(R));
sze = 2*r+1; 
MX = ordfilt2(R,sze^2,ones(sze));
R11 = (R==MX)&(R>Thrshold); 
count=sum(sum(R11(5:size(R11,1)-5,5:size(R11,2)-5)));   %How many interest points, avoid the image's edge
    
    
loop=0;
while (((count<min_N)|(count>max_N))&(loop<30))
    if count>max_N
        Thrshold=Thrshold*1.5;
    elseif count < min_N
        Thrshold=Thrshold*0.5;
    end
    
    R11 = (R==MX)&(R>Thrshold); 
    count=sum(sum(R11(5:size(R11,1)-5,5:size(R11,2)-5)));
    loop=loop+1;
end
  
    
R=R*0;
R(5:size(R11,1)-5,5:size(R11,2)-5)=R11(5:size(R11,1)-5,5:size(R11,2)-5);
[r1,c1] = find(R);
PIP=[r1,c1]%% IP , 2d location ie.(u,v)
  

%%%%%%%%%%%%%%%%%%%% Display
   
Size_PI=size(PIP,1);
for r=1: Size_PI
   I(PIP(r,1)-2:PIP(r,1)+2,PIP(r,2)-2)=255;
   I(PIP(r,1)-2:PIP(r,1)+2,PIP(r,2)+2)=255;
   I(PIP(r,1)-2,PIP(r,2)-2:PIP(r,2)+2)=255;
   I(PIP(r,1)+2,PIP(r,2)-2:PIP(r,2)+2)=255;
   
end
figure(3)
imshow(uint8(I))