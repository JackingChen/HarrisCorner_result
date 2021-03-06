function [output2] = my_imfilter(image, filter)
% This function is intended to behave like the built in function imfilter()
% See 'help imfilter' or 'help conv2'. While terms like "filtering" and
% "convolution" might be used interchangeably, and they are indeed nearly
% the same thing, there is a difference:
% from 'help filter2'
%    2-D correlation is related to 2-D convolution by a 180 degree rotation
%    of the filter matrix.

% Your function should work for color images. Simply filter each color
% channel independently.

% Your function should work for filters of any width and height
% combination, as long as the width and height are odd (e.g. 1, 7, 9). This
% restriction makes it unambigious which pixel in the filter is the center
% pixel.

% Boundary handling can be tricky. The filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds. If
% you look at 'help conv2' and 'help imfilter' you see that they have
% several options to deal with boundaries. You should simply recreate the
% default behavior of imfilter -- pad the input image with zeros, and
% return a filtered image which matches the input resolution. A better
% approach is to mirror the image content over the boundaries for padding.

% % Uncomment if you want to simply call imfilter so you can see the desired
% % behavior. When you write your actual solution, you can't use imfilter,
% % filter2, conv2, etc. Simply loop over all the pixels and do the actual
% % computation. It might be slow.
% output = imfilter(image, filter);


%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%
test_image=image;
[filter_r filter_c]=size(filter);
dim=size(size(image));%check dimenasion 
%%%%%%%%%%%dimension%%%%%%%%%%%%%%%%
if dim(2)==3%input image only have either 1 or 3 dimensions
    disp('RGB img');
    dim=3;
elseif dim(2)==2
    disp('gray img');
    dim=1;
else
    disp('not valid input');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for color=1:dim %iterate every dimemsions

    %padding    
    img_g=test_image(:,:,color);
    [rows cols]=size(img_g);
    img_pad=zeros(rows+(filter_r-1)*2,cols+(filter_c-1)*2);%first pad with zero
    
    indexbase_r=filter_r;%filter row size
    indexbase_c=filter_c;%filter col size
    img_pad(indexbase_r:end-indexbase_r+1,indexbase_c:end-indexbase_c+1)=img_g(:,:);
    %padding corner _ mirror padding%%%%%%%%%%%%%%%%%%%%%
    %lefttop
    for i=indexbase_c:-1:1
        for j=indexbase_r:-1:1
            img_pad(j,i)=img_g(indexbase_r-j+1,indexbase_c-i+1);
            
        end
    end
    %righttop
    for i=cols:1:cols+indexbase_c
        for j=indexbase_r:-1:1
            img_pad(j,i+1)=img_g(indexbase_r-j+1,2*cols-i);
        end
    end
    %left bottom
    for i=indexbase_c:-1:1
        for j=rows:1:rows+indexbase_r
            img_pad(j+1,i)=img_g(2*rows-j,indexbase_c-i+1);
        end
    end
    %right bottom
    for i=cols:1:cols+indexbase_c
        for j=rows:1:rows+indexbase_r
            img_pad(j+1,i+1)=img_g(2*rows-j,2*cols-i);
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %padding side
    %left
    for i=indexbase_c:-1:1
        for j=indexbase_r:rows
            img_pad(j,i)=img_g(j-indexbase_r+1,indexbase_c-i+1);
        end
    end
    %right
    for i=cols:indexbase_c+cols
        for j=indexbase_r:rows
            img_pad(j,i+1)=img_g(j-indexbase_r+1,2*cols-i);
        end
    end
    %up
    for i=indexbase_c:cols
        for j=indexbase_r:-1:1
            img_pad(j,i)=img_g(indexbase_r-j+1,i-indexbase_c+1);
        end
    end
    %down
    for i=indexbase_c:cols
        for j=rows:indexbase_r+rows
            img_pad(j+1,i)=img_g(2*rows-j,i-indexbase_c+1);
        end
    end
    impad=img_pad;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %indicate the middle point of the filter
    %mid_r=floor(indexbase_r/2)+1;
    %mid_c=floor(indexbase_c/2)+1;
tic   
    for i=1:cols
        for j=1:rows
            %addition function
            %         value=0;
            %         for local_ind_i=-floor(indexbase_c/2):1:floor(indexbase_c/2)
            %             for local_ind_j=-floor(indexbase_r/2):1:floor(indexbase_r/2)
            %                 value=value+filter(local_ind_j+mid_r,local_ind_i+mid_c)*img_pad(j+indexbase_r+local_ind_j,i+indexbase_c+local_ind_i);
            %             end
            %         end
            %         output(j,i)=value;
            start_r=j+indexbase_r;%conv location on the image_row
            start_c=i+indexbase_c;%conv location on the image_col
            
            tmp_val=filter.*img_pad(start_r-floor(indexbase_r/2):start_r+floor(indexbase_r/2),start_c-floor(indexbase_c/2):start_c+floor(indexbase_c/2));%multiply selected area on the image and the filter
            value=sum(sum(tmp_val));
            output_tmp(j,i)=value;
        end
    end
    %output2=output2(indexbase_r:rows,indexbase_c:cols);
    output2(:,:,color)=output_tmp;
toc;
end
end




