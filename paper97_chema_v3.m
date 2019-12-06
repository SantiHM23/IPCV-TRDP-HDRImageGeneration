% INITIALIZE
close all; clear all; clc;


% load data (implementation depends on dataset format)
bw_flag=0;

% [C, exposure_time] = load_data('./cs/chroma/data/Nikon_D700/INDEX/S0140_index.mat', bw_flag);
% %exposure_time=1./exposure_time; % not clear daatset def?

% input_name="memorial";
% [C, exposure_time] = load_data_memorial('', bw_flag);

 input_name="buildingb"; %% "chill" - "epshall" - "buildingb" - "desk"
 [C, exposure_time, image_names, lambda] = load_our_data(input_name);
 %groundtruth_image = ground_truth(input_name);
 groundtruth_image = hdrread("desk_gtgauss.hdr");

n_images=size(C,1);
n_channels=size(C,2);
[height,width]=size(C{1}); %all images same size

plot_g=1;
if(plot_g) figure; end

%Uncomment these two lines for evaluating different lambda values
% for lambda = 1:1:20 
%     monotonic = 0; 
%    %lambda = 8;
for c=1:n_channels % FOR EACH CHANNEL
    
% COMPUTE g 
    
    % PREPROCESS DATA (C->Z -sample C to n_points => Z)

    % Fill the matrix Z with n_points "samples" of each image. Each column in Z corresponds to one image
    % [Z, npoints_back]=createZ(C); % may be a function once alpha is
    % studied. Currently I prefer this here in order to change alpha directly
    n_points = 50; %128; % n_points > 255/(n_images-1) % ToDo (function = weigth*(255/(n_images-1)) ... from paper
    alpha=2; % alpha>1 (= works due to get_points implementation that genreates more than n_points) heuristic -> ToDo select real npointsback (depends just on hxw)
    %ToDo: to study the effect of alpha in the results (the higher the better? Some asynthotic limit?
    n_points = round(alpha*(255/(n_images-1)));
    
    for k = 1:n_images % jms20180313: select points (same for all images) and extract points - ToDo separate - improve get_points ("matlabize")
        %[Cell_coords{k}, Cell_intensity{k}, n_points_back] = get_points(C{k,c}, n_points);
        %Z(:,k) = (Cell_intensity{k});
        Z(:,k) = get_points(C{k,c}, n_points);
    end
    % END PREPROCESS DATA
    

  

%Weighting function as far as I understand is a function, not a parameter,
%so I don't understand why it is an input variable of the gsolve function,
%when the weighting function is used inside the gsolve function.
% jms20180313 - w() is used both in gsolve and in the creation of LE(hdr) ... 

[g,lE]=gsolve(Z,log(exposure_time),lambda);
% jms20180313 - as by-product a "thumbnail" lE is obtained: visualize thumbnail -ToDo-

if(plot_g) 
    subplot(3,2,2*c-1); plot(g); title(sprintf('g of channel %d',c)); %to monitor g
    %subplot(3,2,2*c); thumbnail=reshape(lE,h_th,w_th); imshow(thumbnail); title(sprintf('thumbnail of changel %d',i));
end

% END COMPUTE g

% COMPUTE HDR image (formula (6) - complete HDR image): exp(LE2) "irradiance vector", hdr "irradiance image"
% PARAMETERS: images F and B -and w()-
for k = 1:n_images
    F(:,k) = C{k,c}(:); % jms20190313  converts each C(k,c) image in a vector (concatenating cols) %reshape?
end

for p = 1:size(F,1) % pixels in the vector ... wxh
    numerator = 0.0;
    denominator = 0.0; %it is always an integer as w() returns range 0..255
    for k = 1:n_images % size(F,2) - P % to "matlabize"
        numerator = numerator + weighting_func(F(p,k))*(g(F(p,k)+1)-log(exposure_time(k))); % we were using B differently here and in gsolve 
        % denominator = weighting_fctn(F(i,k)); % jms20190313 denominator was missing in the rigth side
        denominator = denominator + weighting_func(F(p,k)); % jms20190313 denominator was missing in the rigth side - correct(?) but too "homogeneous"!!!!     
    end
    aux=(numerator/denominator); % jms 20180314 - we have been using ln E for visualizing!!!!!
    exp_aux = exp(aux);
    E2(p)=exp_aux; % to merge with above after testing ...
end


% Convert F vector (LE2) to HDR images
% % OLD VERSION (not "matlabized")
% % hdr = zeros(m,n);% counter = 1;
% % for i = 1:width
% %     for j = 1:height
% %         C{1}(x,y) = lE2(counter); % this overwrittes original image!!!!!
% %         hdr_aux(j,i) = lE2(counter); % jms20180313 - new variable to avoid problem above
% %         counter = counter + 1;
% %     end
% % end
hdr(:,:,c)=reshape(E2,[height,width]);

% END COMPUTE HDR image

%Uncomment for checking monotonicity
% value = monotonic_g(g);
% monotonic = monotonic + value; 
monotonic = monotonic_g(g)
end
 %END for each channel
%dataset_flag=0; 
%visualize(hdr,C, exposure_time, dataset_flag);

output_name=sprintf('%s(%d).HDR',input_name, lambda);

rgb = tonemap(hdr);
%whos
figure(2); 
title(output_name); 
imshow(rgb);
figure(3); 
imshow(hdr);

% STORE HDR image - in a fortmat compatible with HDR viewers (look for)
% ToDo - select format!!!
[noise_ratio, SNR] = NRratio(groundtruth_image, hdr);
ssimval = ssim(single(hdr),groundtruth_image);
%monotonic = monotonic_g(g);
%output_file = sprintf('../desk/%s/%s', input_name,output_name);
%hdrwrite(hdr, output_file);

%Uncomment these lines for checking monotonicity
% end

% END STORE HDR image
%%
