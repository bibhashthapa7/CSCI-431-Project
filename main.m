function main()
    is_training = true;
    is_enhanced = true;
    is_interactive = true;
    
    directory = "training";
    if ~is_training
        directory = "testing";
    end
    
    if ~is_enhanced
        contrast_enhancement(directory);
    end
    
    if is_enhanced
        img_path = fullfile(directory, "contrast_enhanced", "A5.jpg");
    else
        img_path = fullfile(directory, "A5.jpg");
    end
    
    % Read the image
    rgb_img = load_and_orient_image(img_path);
    
    % Color detection using Mahalanobis 
    yellow_mask_mahal = mahalanobis(is_interactive, rgb_img);

    % Morphological cleanup
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
end