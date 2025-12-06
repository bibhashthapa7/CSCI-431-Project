function class_im = mahalanobis(im_rgb)
    load("training_samples.mat");
    
    %transform the rgb image to lab
    im_lab = rgb2lab( im_rgb );
    
    %get the a channel
    a_channel = im_lab(:,:,2);
    %get the b channel
    b_channel = im_lab(:,:,3);

    ab_channels = [a_channel(:), b_channel(:)];

    mahal_fg  = ( mahal( ab_channels, fg_samples ) ) .^ (1/2);
    %creates a matrix of the mahalanobis dist between og and bg values
    mahal_bg1 = ( mahal( ab_channels, bg1_samples ) ) .^ (1/2);
    mahal_bg2 = ( mahal( ab_channels, bg2_samples ) ) .^ (1/2);
    mahal_bg3 = ( mahal( ab_channels, bg3_samples ) ) .^ (1/2);
    mahal_bg4 = ( mahal( ab_channels, bg4_samples_random) ) .^ (1/2);

    distances = [mahal_fg, mahal_bg1, mahal_bg2, mahal_bg3];
    [min_values, classified_mask] = min(distances, [], 2);
    
    fg_classified_dist = mahal_fg(classified_mask == 1);

    fg_dist_mean = mean(fg_classified_dist);
    fg_dist_stdev = std(fg_classified_dist);
    
    guess_cls0 = (classified_mask == 1) & (abs(mahal_fg - fg_dist_mean) < 1.5*fg_dist_stdev);


    %reshape the classification result back to original image size
    class_im = reshape( guess_cls0, size(im_lab,1), size(im_lab,2));
end

