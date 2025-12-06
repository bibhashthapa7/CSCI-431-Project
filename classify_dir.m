function classify_dir(in_dir,out_dir)
    if ~exist(out_dir, 'dir')
        mkdir(out_dir);
    end

    images = dir(fullfile(in_dir, '*jpg'));

    for index = 1:length(images)
        img = imread(fullfile(in_dir, images(index).name));

        yellow_mask_mahal = mahalanobis(img);
        clean_mask = cleanup_mask(yellow_mask_mahal);
        % Circle detection
        [centers, radii, metrics] = find_marker_circles(clean_mask);
    
        % Visualize steps
        figure('Position', [100, 100, 1400, 500]);
    
        subplot(1,4,1); 
        imshow(rgb_img); 
        title('Original Image');
    
        subplot(1,4,2); 
        imshow(yellow_mask_mahal); 
        title('Mahalanobis Color Detection');

        subplot(1,4,3); 
        imshow(clean_mask); 
        title('After Morphological Cleanup');

         subplot(1,4,4); 
        imshow(rgb_img); 
        hold on;
        if ~isempty(centers)
            viscircles(centers, radii*2, 'Color', [1 0.5 0], 'LineWidth', 3);
        end
        hold off;

        pause();
    end
end