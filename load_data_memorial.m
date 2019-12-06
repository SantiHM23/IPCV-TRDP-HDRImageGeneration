function [C, exposure_time]=load_data_memorial(set_of_images_data, bw_flag)
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

%Load the data of a set of images
% MENORIAL DATA
% # Number of Images
% 16
% # Filename  1/shutter_speed f/stop gain(db) ND_filters
% memorial0061.ppm 0.03125 8 0 0
% memorial0062.ppm 0.0625  8 0 0
% memorial0063.ppm 0.125   8 0 0
% memorial0064.ppm 0.25    8 0 0
% memorial0065.ppm 0.5     8 0 0
% memorial0066.ppm 1       8 0 0
% memorial0067.ppm 2       8 0 0
% memorial0068.ppm 4       8 0 0
% memorial0069.ppm 8       8 0 0
% memorial0070.ppm 16      8 0 0
% memorial0071.ppm 32      8 0 0
% memorial0072.ppm 64      8 0 0
% memorial0073.ppm 128     8 0 0
% memorial0074.ppm 256     8 0 0
% memorial0075.ppm 512     8 0 0
% memorial0076.ppm 1024    8 0 0


%Number of images in the image set
n_images = 16;
%Create a cell to store the actual images
C = {};
%Load the images and save them in the storing cell
for i = 1:n_images
    %memorial0061.ppm -> 76
    number=60+i;
    image_name = sprintf('../Memorial_SourceImages/memorial00%d.png',number);

% TODO remove blue frames ...     
%     The .png images were taken from PhotoCD scans of film pictures taken
% on Kodak Gold 100 ASA film.  The scans were decoded to 512x768 pixel
% resolution.  The pictures were manually registered using feature
% points and homographies using the Facade photogrammetric modeling
% system.  The pure blue color indicates shifted image border areas and
% should not be used in the HDR assembly process.
% 
% The .hdr_image_list.txt file indicates the shooting parameters for
% each picture.  Gain doubles the exposure amount when it goes up by 3
% decibels.  f/stop quadruples the exposure amount each time it goes
% DOWN by a factor of two.  No neutral density filters were used in this
% sequence.
    
    
    im = imread(image_name);
    h=size(im,1);
    w=size(im,2);
    channels=size(im,3);
    % The pure blue color indicates shifted image border areas and
    % should not be used in the HDR assembly process.
    frame_th=0; % HEURISTIC ;) 
  
    im = imread(image_name);
    %im = im2uint8(im);
    if (bw_flag)
        im = rgb2gray(im);
        C{i,1} = double(im(1+frame_th:h-frame_th,1+frame_th:w-frame_th,1));
    else
        for c=1:size(im,3) % channgels
            C{i,c} = double(im(1+frame_th:h-frame_th,1+frame_th:w-frame_th,c));
        end
    end
    
%     % im = rgb2gray(im); % transforms to RGB-bw image (all bands the same) for be testing
%     for j=1:channels
%         if (channels==size(im,3))
%             C{i,j} = double(im(frame_w:h-frame_w,frame_w:w-frame_w,j));
%         else % for bw testing
%              C{i,j} = double(im(frame_w:h-frame_w,frame_w:w-frame_w));
%         end
%     end
    
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
    % exposure_time = [0.03125 0.0625 0.125 0.25 0.5 1 2  4 8 16 32 64 128 256 512 1024];
    exposure_time = [1/32 1/16 1/8 1/4 1/2 1 2  4 8 16 32 64 128 256 512 1024]; % from dataset definition
    % the first is the "lighter" the last the "darker"
    exposure_time=1./exposure_time;
end

%END LOAD DATA: SET OF IMAGES (C) AND SHUTTER SPEED DATA (B)