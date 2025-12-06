function labels = test_labels()
    % List images with markers from the testing dataset
    images_with_markers = {
        'A3.jpg', 'A7.jpg', 'A10.jpg', 'A23.jpg', ...
        'B18.jpg', 'B20.jpg', 'B23.jpg', 'B24.jpg', 'B33.jpg', 'B40.jpg', ...
        'C2.jpg', 'C3.jpg', 'C13.jpg', 'C23.jpg', 'C28.jpg', ...
        'D38.jpg', 'D39.jpg', 'D42.jpg', 'D45.jpg', 'D49.jpg', 'D50.jpg'
    };

    % Get all test images
    test_dir = "testing";
    all_images = dir(fullfile(test_dir, "*.jpg"));

    % Create a map and assign everything to 0
    labels = containers.Map();
    for i = 1:length(all_images)
        labels(all_images(i).name) = 0; 
    end

    % Set images with markers to 1
    for i = 1:length(images_with_markers)
        if isKey(labels, images_with_markers{i})
            labels(images_with_markers{i}) = 1;
        end
    end
end