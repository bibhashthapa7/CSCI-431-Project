function rgb_img = load_and_orient_image(img_path)
    % Read the image
    rgb_img = imread(img_path);
    
    % Get metadata
    info = imfinfo(img_path);
    
    % Check if orientation field exists
    if isfield(info, 'Orientation')
        orientation = info.Orientation;
        
        % Apply rotation based on orientation
        switch orientation
            case 1
                % Normal
            case 3
                % 180 degrees
                rgb_img = rot90(rgb_img, 2);
            case 6
                % 90 degrees clockwise
                rgb_img = rot90(rgb_img, -1);
            case 8
                % 90 degrees counter-clockwise
                rgb_img = rot90(rgb_img, 1);
        end
    end
end