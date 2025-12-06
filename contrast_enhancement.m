% Function that applies contrast enhancement to all the images
function contrast_enhancement(dir_name)
    % Build output directory
    out_dir = fullfile(dir_name, "contrast_enhanced");
    
    % Create output directory if it doesnt exist
    if ~isfolder(out_dir)
        mkdir(out_dir);
    end

    % Get list of all images in the input directory
    images = dir(fullfile(dir_name, "*.jpg"));

    % Loop through each image
    for img_index = 1: length(images)
        % Path to current image
        path = fullfile(dir_name, images(img_index).name);

        % Read image and fix orientation if needed
        rgb_img = load_and_orient_image(path);

        % Convert to double precision
        rgb_img = im2double(rgb_img);

        % Convert from rgb to cie lab color space
        lab_img = rgb2lab(rgb_img);

        % Extract L channel and normalize
        L = lab_img(:,:,1) / 100;

        % Apply adaptive histrogram equalization for contrast enhancement
        L_enhanced = adapthisteq(L);

        % Put enhanced L channel back
        lab_img(:,:,1) = L_enhanced * 100;

        % Convert back to RGB
        rgb_enhanced = lab2rgb(lab_img);

        % Save enhanced image
        out_name = fullfile(out_dir, images(img_index).name);
        imwrite(rgb_enhanced, out_name);
    end
end