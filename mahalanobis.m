function class_im = mahalanobis(INTERACTIVE, im_rgb)
    
    %check if interactive flag is true
    if  INTERACTIVE
        %create a new figure at the position specified
        figure('Position',[10 10 1024 768]);
        %show the image in the scientific way
        imagesc( im_rgb );
        %add axis to the image
        axis image;

        fprintf('SELECT FOREGROUND OBJECT ... ');
        fprintf('Click on points to capture positions:  Hit return to end...\n');
        %stores the x and y values of the foreground captures
        [x_fg, y_fg] = ginput();

        fprintf('SELECT BACKGROUND OBJECT ... ');
        fprintf('Click on points to capture positions:  Hit return to end...\n');
        %stores the x and y value of the background captures
        [x_bg, y_bg] = ginput();

        save my_temporary_data;
    else
        load my_temporary_data;
    end
    
    %transform the rgb image to lab
    im_lab = rgb2lab( im_rgb );
    
    %get the a channel
    a_channel = im_lab(:,:,2);
    %get the b channel
    b_channel = im_lab(:,:,3);

    %creates a matrix that stores the x and y positions of the foreground
    fg_indices  = sub2ind( size(im_lab), round(y_fg), round(x_fg) );
    %creates a matrix that stores the a values of the foreground positions
    fg_a = a_channel(fg_indices);
    %creates a matrix that stores the b values of the foreground positions
    fg_b = b_channel(fg_indices);
    
    %creates a matrix that stores the x and y positions of the background
    bg_indices  = sub2ind( size(im_lab), round(y_bg), round(x_bg) );
    %creates a matrix that stores the a values of the background positions
    bg_a = a_channel( bg_indices );
    %creates a matrix that stores the b values of the background positions
    bg_b = b_channel( bg_indices );

    %creates a matrix with the original a and b values
    ab_channels = [a_channel(:), b_channel(:)];
    %creates a matrix with the foreground's a and b values
    fg_ab = [fg_a(:), fg_b(:)];
    %creates a matrix with the background's a and b values
    bg_ab = [bg_a(:), bg_b(:)];

    %creates a matrix of the mahalanobis dist between og and fg values
    %we take the square root because mahal function returns dist squared
    mahal_fg    = ( mahal( ab_channels, fg_ab ) ) .^ (1/2);
    %creates a matrix of the mahalanobis dist between og and bg values
    mahal_bg    = ( mahal( ab_channels, bg_ab ) ) .^ (1/2);
    
    %Classify as Class 0 (foreground object) if distance to FG is < distance to BG.
    class_fg     = mahal_fg < (mahal_bg);
    
    %sets the foreground distances to a matrix
    fg_dists        = mahal_fg;
    %creates a matrix that stores distances classified as foreground
    fg_dists_cls0   = fg_dists( class_fg );  

    %gets the min distance from the foreground class
    dist_mean       = mean( fg_dists_cls0 );
    %gets the standard dev from the foreground class
    dist_std_01     = std(  fg_dists_cls0 );
    
    % Toss everything outside of one standard deviation, and re-adjust the mean value:
    b_inliers       = ( fg_dists_cls0 <= (dist_mean + dist_std_01) ) & ( fg_dists_cls0 >= (dist_mean - dist_std_01));
    the_inliers     = fg_dists_cls0( b_inliers );
    %computes the mean with only the inliers
    dist_mean       = mean( the_inliers );
    %change the threshold equal to the mean
    threshold       = dist_mean;
    %classify new pixels as foreground if the distance is less than mean
    guess_cls0      = fg_dists < threshold;

    %reshape the classification result back to original image size
    class_im        = reshape( guess_cls0, size(im_lab,1), size(im_lab,2));
end

