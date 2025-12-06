function class_im = mahalanobis(im_rgb)
    load("training_samples.mat");
    
    % Transform RGB to LAB
    im_lab = rgb2lab(im_rgb);
    a_channel = im_lab(:,:,2);
    b_channel = im_lab(:,:,3);
    
    ab_channels = [a_channel(:), b_channel(:)];
    
    % Calculate Mahalanobis distances
    mahal_fg  = sqrt(mahal(ab_channels, fg_samples));
    mahal_bg1 = sqrt(mahal(ab_channels, bg1_samples));
    mahal_bg2 = sqrt(mahal(ab_channels, bg2_samples));
    mahal_bg3 = sqrt(mahal(ab_channels, bg3_samples));
    mahal_bg4 = sqrt(mahal(ab_channels, bg4_samples_random));
    
    % Classify to nearest class
    distances = [mahal_fg, mahal_bg1, mahal_bg2, mahal_bg3, mahal_bg4];
    [~, classified_mask] = min(distances, [], 2);
    
    % Refine foreground classification
    fg_classified_dist = mahal_fg(classified_mask == 1);
    
    % FIX: Handle case where no pixels classified as foreground
    if isempty(fg_classified_dist)
        class_im = false(size(a_channel));
        return;
    end
    
    fg_dist_mean = mean(fg_classified_dist);
    fg_dist_stdev = std(fg_classified_dist);
    
    % Keep only confident foreground pixels
    guess_cls0 = (classified_mask == 1) & (abs(mahal_fg - fg_dist_mean) < 1.5*fg_dist_stdev);
    
    % Reshape to image dimensions
    class_im = reshape(guess_cls0, size(im_lab,1), size(im_lab,2));
end