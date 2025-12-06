function classify_dir(in_dir, out_dir)
    if ~exist(out_dir, 'dir')
        mkdir(out_dir);
    end
    
    images = dir(fullfile(in_dir, '*.jpg'));
    
    if isempty(images)
        warning('No images found in %s', in_dir);
        return;
    end
    
    fprintf('\nProcessing %d images from: %s\n\n', length(images), in_dir);

    % Store detection results for accuracy calculation
    detection_results = struct('filename', {}, 'num_detected', {});
    
    for index = 1:length(images)
        fprintf('[%d/%d]Processing %s...\n', index, length(images), images(index).name);
        
        try
            img = load_and_orient_image(fullfile(in_dir, images(index).name));
            
            % Detection pipeline
            yellow_mask_mahal = mahalanobis(img);
            clean_mask = cleanup_mask(yellow_mask_mahal);
            [centers, radii, ~] = find_marker_circles(clean_mask);

            num_detected = length(radii);
            fprintf('Detected %d marker(s)\n\n', num_detected);

            % Store result for accuracy calculation
            detection_results(index).filename = images(index).name;
            detection_results(index).num_detected = num_detected;
            
            % Visualize steps
            figure('Position', [100, 100, 1400, 500]);
            
            subplot(1,4,1);
            imshow(img);
            title(sprintf('%s - Original', images(index).name), 'Interpreter', 'none');
            
            subplot(1,4,2);
            imshow(yellow_mask_mahal);
            title('Mahalanobis Detection');
            
            subplot(1,4,3);
            imshow(clean_mask);
            title('After Cleanup');
            
            subplot(1,4,4);
            imshow(img);
            hold on;
            if ~isempty(centers)
                viscircles(centers, radii*2, 'Color', [1 0.5 0], 'LineWidth', 3);
            end
            title(sprintf('Detected: %d marker(s)', length(radii)));
            hold off;
            
            % Save result
            saveas(gcf, fullfile(out_dir, images(index).name));
            close;
            
        catch ME
            fprintf('  ERROR: %s\n\n', ME.message);
            continue;
        end
    end
    
    fprintf('Done! Results saved to: %s\n', out_dir);

    if contains(out_dir, 'testing')
        % Call accuracy calculation for testing dataset
        calculate_accuracy(detection_results, out_dir);
    end
end