function [C, exposure_time, image_names, lambda]=load_our_data(set_of_images_data)
% LOAD DATA: loads the set of images (C) and exposure time (B)
% INPUT
% set_of_images_data: path to the file with the data
% OUPUT
% C: cell structure (n_imagesxchannels) each with (hxw) images
% exposure_time: vector (1xn_images)  exposure times (1/shutter_speed) data
%

%COMMENTS
%We assume that images have the same size, and the same name which only
%differs in the final number that goes from 1 till the number of images
%contained in the folder, which is also previously known

%Create a cell to store the actual images
C = {};
%Select between all the possible cases, which will define the amount of
%images to use and the exposure time vector, which we annotated manually
%when taking the photographs
if (set_of_images_data == "chill")
    n_images = 7;
    exposure_time = [1/250 1/400 1/500 1/640 1/800 1/1000 1/1600];
    lambda = 86;
elseif (set_of_images_data == "epshall")
    n_images = 11;
    exposure_time = [2 1 0.5 0.3 1/5 1/8 1/15 1/20 1/30 1/40 1/50];
    lambda = 12; %Value checked to be the first monotonic
elseif (set_of_images_data == "buildingb")
    n_images = 15;
    exposure_time = [1/30 1/50 1/60 1/80 1/100 1/125 1/160 1/200 1/250 1/320 1/400 1/500 1/640 1/800 1/1000];
    lambda = 13; %Value checked to be the first monotonic
elseif (set_of_images_data == "desk")
    n_images = 13;
    exposure_time = [8 4 2 1 1/2 1/3 1/4 1/5 1/6 1/8 1/10 1/15 1/30];
    lambda = 6; %Value checked to be the first monotonic
else
    printf("Error when selecting dataset");
    n_images = 0;
end
       %Import the images of the selected dataset 
       image_names={};
        for i = 1:n_images
            %Adress in which the image is located
            file_name=sprintf('../%s/%s%04d.JPG',string(set_of_images_data),string(set_of_images_data),i);
            image_names(:,i) = cellstr(file_name);
            im = imread(file_name);
            im = imresize(im, [floor(size(im,1)/4) floor(size(im,2)/4)]);
            for c=1:size(im,3) % channels
                C{i,c} = double(im(:,:,c));
            end
            %F(:,i) = C{i}(:); % jms20190313  converts each C(i) image in a vector (concatenating cols) - better to move to another place ..
        end

       % exposure_time = 1./exposure_time; %Not sure about this
end
%END LOAD DATA: SET OF IMAGES (C) AND SHUTTER SPEED DATA (B)