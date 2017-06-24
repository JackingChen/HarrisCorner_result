# JackChen <span style="color:red">(104061563)</span>

# Project 2 / Panorama Stitching

## Overview
The project is related to 
> Harris corner detection

interesting lab haha :)
## Implementation
1. Get intrest points
	* After some mathmatical derivation, we have our Distance matrix E(u,v) approximate to [u v] M [u v]' where M = [Ix^2 IxIy ; IyIx Iy^2]. So we first calculate M
	```
	dx = [-1 0 1; -1 0 1; -1 0 1];
	dy = dx';
	Ix=my_imfilter(img_grey,dx);
	Iy=my_imfilter(img_grey,dy);
	Ix2=my_imfilter(Ix,dx);
	Iy2=my_imfilter(Iy,dy);
	Ixy=my_imfilter(Ix,dy);
	Iyx=Ixy;
	```
	To calculate the derivitives, we can use a gradient filter to do convolution with the original matrix
	* Once we have M, we can then derive response function R = det(M)-alpha*trace(M)^2 
```
	for j=1:length(Ix(:,1,1))
    for i=1:length(Ix(1,:,1))
        M=[Ix2(j,i) Ixy(j,i);Iyx(j,i) Iy2(j,i)];
        R(j,i)=det(M)-alpha*trace(M)^2 ;
    end
end
    ```
   * Map R value to range from 0 to 1000, and then remain the filter out the R value that are smaller than threshold
    ```
	for i=1:length(R(:,1))
    for j=1:length(R(1,:))
        if R(i,j)<Thrshold
            R(i,j)=0;
        end
    end
end
    ```
   * Our interested points(the corners) are the pixels with the largest R value within its patch, so we apply a max filter on it. To implement a max filter, use ordfilt2 function.
Reader can refer to this website as reference:
http://stackoverflow.com/questions/22218037/how-to-find-local-maxima-in-image  
   ```
   sze = 2*r+1;
   mask=true(sze);
	mask(floor(sze^2/2)+1)=0;	
	MX=ordfilt2(R,sze^2-1,mask);
	RBinary = MX>R;
   ``` 
    
2. After you have the location of the corners (RBinary) you may plot the result by
	```
	offe = r-1;
count=sum(sum(RBinary(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe))); % How many interest points, avoid the image's edge   
R=R*0;
R(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe)=RBinary(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe);
[r1,c1] = find(R);
PIP=[r1,c1];
figure(5)
imagesc(uint8(I));
hold on;
plot(c1,r1,'or');
	```

## Installation
* None

## Experiment
1. change the gradient filter size
```
dx = [-1 0 0 0 0 0 1; -1 0 0 0 0 0 1; -1 0 0 0 0 0 1];
dx = [-1 0 0 0 1; -1 0 0 0 1; -1 0 0 0 1];
dx = [-1 0 1; -1 0 1; -1 0 1];
```
result:
<img src="./results/birdane.jpg" width="24%"/>
<img src="./results/tune\ gradient\ filter/little.jpg" width="24%"/>
<img src="./results/tune\ gradient\ filter/medium.jpg" width="24%"/>
<img src="./results/tune\ gradient\ filter/large.jpg" width="24%"/>
disussion: seems that the smallest gradient filter has the best result

2. changing the order filter (for complementing maxium filter) size
result:
<img src="./results/tune r/little.jpg" width="24%"/>
<img src="./results/tune r/r=4.jpg" width="24%"/>
<img src="./results/tune r/r=6.jpg" width="24%"/>
discussion: seems tuning r did not have effect on interest point (corner dection)
3. tuning the threshold
<img src="./results/tune threshold/100.jpg" width="24%"/>
<img src="./results/tune threshold/150.jpg" width="24%"/>
<img src="./results/tune threshold/200.jpg" width="24%"/>
<img src="./results/tune threshold/300.jpg" width="24%"/>
discussion: I think setting the threshold to 150 should be the best result


