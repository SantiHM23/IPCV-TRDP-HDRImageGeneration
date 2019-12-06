function [hdr_image] = ground_truth(inputname)

% load data (implementation depends on dataset format)
bw_flag=1;

% [C, exposure_time] = load_data('./cs/chroma/data/Nikon_D700/INDEX/S0140_index.mat', bw_flag);
% %exposure_time=1./exposure_time; % not clear daatset def?

% [C, exposure_time] = load_data_memorial('', bw_flag);

% our GT
%short_names = {"chill", "epshall", "buildingb"};
%for i=1:size(short_names,2)
    [C, exposure_time, image_names] = load_our_data(inputname); 

    files=image_names;
    %files = {'office_1.jpg', 'office_2.jpg', 'office_3.jpg', ...       
    expTimes=exposure_time;

    hdr_image = makehdr(files,'ExposureValues',expTimes);

    % hdr_image = hdrread('office.hdr');
    % rgb = tonemap(hdr_image);
    % whos
    rgb = tonemap(hdr_image);
    whos
%    figure; title(string(short_names(1,i))); imshow(rgb);

    % hdrwrite(hdr,'newHDRfile.hdr');
    hdrwrite(hdr_image,sprintf('../desk/%s/%s_gt.HDR',inputname,inputname));
%end

%%
% Memorial GT

%     bw_flag=0;
%     [C, exposure_time, image_names] = load_data_memorial('',bw_flag); 
% 
%     files=image_names;
%     %files = {'office_1.jpg', 'office_2.jpg', 'office_3.jpg', ...       
%     expTimes=exposure_time;
% 
%     hdr_image = makehdr(files,'ExposureValues',expTimes);
% 
%     % hdr_image = hdrread('office.hdr');
%     % rgb = tonemap(hdr_image);
%     % whos
%     rgb = tonemap(hdr_image);
%     whos
%     figure; title('MemorialChurch'); imshow(rgb);
% 
%     % hdrwrite(hdr,'newHDRfile.hdr');
%     hdrwrite(hdr_image,sprintf('./MemorialChurch.HDR'));

