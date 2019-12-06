function visualize(hdr, C, B,dataset_flag) 

% TONE MAPPING
%tone mapping (linear mapping) 
hdrmax=max(max(max(hdr)));
hdrmin=min(min(min(hdr)));
%hdr_mapped=uint8(hdr*(255/(hdrmax-hdrmin)));
hdr_mapped=(hdr./double(hdrmax))*255; % to avoid precision problems
%hdr_mapped_out = double(im2uint8(hdr_mapped));
% VISUALIZE
figure; subplot(2,2,1); imshow(hdr); title('HDR');
subplot(2,2,2); imshow(hdr_mapped); title('HDR mapped linear');
subplot(2,2,3); imshow(im2uint8(hdr)); title('HDR (im2uint8)');
subplot(2,2,4); imshow(im2uint8(hdr_mapped)); title('HDR mapped linear (im2uint8)');

%tone mapping (easy by Edoardo - only for RGB ...)
if (size(hdr,3)==3) 
    % RGB |---> HSV
    hdr_hsv=rgb2hsv(hdr);
    % V(x) |---->   V(x)/(V(x)+mu)
    value=hdr_hsv(:,:,3);
    mu = mean(mean(value));
    %?? value_mapped=value./(value+mu);
    value_mapped=value/mu;
    hdr_hsv_mapped=hdr_hsv;
    hdr_hsv_mapped(:,:,3)=value_mapped;
    % mu aritmetic/geometric mean (darker/lighter)
    hdr_mapped2=uint8(hsv2rgb(hdr_hsv_mapped));

% VISUAL
figure; subplot(2,2,1); imshow(hdr); title('HDR');
subplot(2,2,2); imshow(hdr_mapped2); title('HDR mapped hsv');
subplot(2,2,3); imshow(im2uint8(hdr)); title('HDR (im2uint8)');
subplot(2,2,4); imshow(im2uint8(hdr_mapped2)); title('HDR mapped hsv (im2uint8)');

end
% END TONE MAPPING


% VISUALIZE DATASET
if (dataset_flag)
    n_images=size(C,1);
    c=size(C,2);
    h=size(C{1,1},2);
    w=size(C{1,1},3);
    for i=1:n_images
        figure; 
        %hdr(:,:,c)=hdr_aux;
        aux=C{i,1}; im_aux(:,:,1)=aux;
        aux=C{i,2}; im_aux(:,:,2)=aux;
        aux=C{i,3}; im_aux(:,:,3)=aux; % to "matlabize" ;)
    
        %     im_aux2=cell2mat(C(i,:));
        %     im_aux=reshape(im_aux2,[h,w,c]);
        imshow(uint8(im_aux)); title(sprintf('Image from original set #%d B(%d)=%1.6f',i+60,i,B(i)));
        subplot(2,n_images,n_images+i); imshow(uint8(C{i})); title(sprintf('Grayscale image from original set #%d B(%d)=%lf',i,i,B(i)));
        subplot(2,n_images,n_images+2); imshow(uint8(C{uint8(n_images/2)})); title('Grayscale image from original set #n_ images/2 ');
        subplot(2,n_images,n_images*2); imshow(uint8(C{n_images})); title('Grayscale image from original set #n_ images');
    end
end
end
% END VISUALIZE DATSET