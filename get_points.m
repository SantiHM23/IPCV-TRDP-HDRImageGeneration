%function [coords, intensity, n_points_back] = get_points(image, n_points)
function [intensity, n_points_back] = get_points(image, n_points)

% w - a - i
% h - b - j
    
    [h, w] = size(image);

% %     rel =w/h; % jms20180313 rel=a/b 
% %     a = sqrt(n_points*rel); % jms20190318 sqr(a)= Npoints * rel
% %     b = a/rel; % jms20190318 b=a/rel 
    coords=zeros(n_points,2);
    step=floor(sqrt((w*h)/n_points)); %jms 20190315 same step in both dimensions

%     counter = 1;
%     for j = 1:step:h
%         for i = 1:step:w
%             intensity(counter,:) = image(j,i); 
%             coords(counter,:) = [j,i]; 
%             counter = counter + 1;
%         end
%     end
    
    % matlabizing
    aux_int=image(1:step:h,1:step:w);
    intensity=reshape(aux_int', [size(aux_int,1)*size(aux_int,2),1]);
    
    n_points_back=size(intensity); % the number of points at the end

end