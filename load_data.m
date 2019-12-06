function [C, exposure_time]=load_data(set_of_images_data, bw_flag)
% LOAD DATA: loads the set of images (C) and exposure time (B)
% INPUT
% set_of_images_data: path to the file with the data
% OUPUT
% C: cell structure (n_imagesxchannels) each with (hxw) images
% exposure_time: vector (1xn_images)  exposure times (1/shutter_speed) data
%

% NOTE (jms 20180312): this dataset is confusing ... images vary in both
% aperture and exposure time (shutter speed?). They seem to be read as 16
% bits images ... Try to look for other datsets with more "clear" data

%COMMENTS
%We assume that images have the same size, and the same name which only
%differs in the final number that goes from 1 till the number of images
%contained in the folder, which is also previously known

%Load the data of a set of images
set = load(set_of_images_data); %jms 20190312 - changed to .. (to test original) ... same in line24
%Number of images in the image set
n_images = size(set.index.cc, 2);
%Create a cell to store the actual images
C = {};
%Load the images and save them in the storing cell
for i = 1:n_images
    %The ifs are for the aperture data
    if abs(set.index.cc{1,i}.aperture) < 10.0
        ap_value = sprintf('apt0%.1f', set.index.cc{1,i}.aperture);
    else
        ap_value = sprintf('apt%.1f', set.index.cc{1,i}.aperture);
    end
    %Adress in which the image is located
    image_name = sprintf('../PNG_%s/cs/chroma/data/Nikon_D700/PNG_ALIGN_EV/%s_%s_sht%.6f_%s_iso%.0f_%04d%02d%02d%02d%02d%02d.png',set.index.set_name(1:end-2),set.index.set_name,set.index.cc{1,i}.name,set.index.cc{1,i}.shutter,ap_value,set.index.cc{1,i}.iso,set.index.cc{1,i}.time);
    
    im = imread(image_name);
   
    if (bw_flag)
        im = im2uint8(im); % images in this set are read 16bits????
        im = rgb2gray(im);
        C{i,1} = double(im(:,:,1));
    else
        im = im2uint8(im); % images in this set are read 16bits????
        for c=1:size(im,3) % channgels
            C{i,c} = double(im(:,:,c));
        end
    end
    %F(:,i) = C{i}(:); % jms20190313  converts each C(i) image in a vector (concatenating cols) - better to move to another place ..
end

%As we said, all images have the same size, so knowing the size of one
%image is like knowing the size of all of them
%[heigth, width, channels] = size(C{n_images});
%F = zeros(m*n, n_images);

%Cell in which each array stored corresponds to a different channel of the images
%L = {};

%B is a vector in which the shutter speed of each image is stored. Each
%member of the matrix is the shutter speed of one image
exposure_time = zeros(1,n_images);

%Fill the B vector with the provided data by the images
for q = 1:n_images
    exposure_time(q) = set.index.cc{1,q}.shutter; % !!!!!!! sutter speed or exposure time?
    exposure_time = 1./exposure_time;
end

%END LOAD DATA: SET OF IMAGES (C) AND SHUTTER SPEED DATA (B)