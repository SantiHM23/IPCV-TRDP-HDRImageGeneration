function [noise_ratio, SNR] = NRratio(GT,our_result)

    [r1,c1,~]=size(GT);
    [r2,c2,~]=size(our_result);

    if r1*c1 > r2*c2
       GT = imresize(GT,[r2,c2]);
    else
       our_result = imresize(our_result,[r1,c1]);
    end

    noise_ratio_mat= (GT-our_result).^2;
    noise_ratio_mat = sqrt(noise_ratio_mat);
    %imshow(noise_ratio_mat);
    noise = sum(sum(noise_ratio_mat(:)));
    signal = sum(sum(GT(:)));
    noise_ratio = noise/signal;
    SNR = 1/noise_ratio;


%figure(4)
%imshow(GT);
%figure(5)
%imshow(our_result);

end

