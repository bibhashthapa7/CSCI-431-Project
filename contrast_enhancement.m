function contrast_enhancement(dir_name)
    out_dir = fullfile(dir_name, "contrast_enhanced");
    
    if ~isfolder(out_dir)
        mkdir(out_dir);
    end

    images = dir(fullfile(dir_name, "*.jpg"));

    for img_index = 1: length(images)
        path = fullfile(dir_name, images(img_index).name);

        rgb_img = load_and_orient_image(path);

        rgb_img = im2double(rgb_img);

        lab_img = rgb2lab(rgb_img);

        L = lab_img(:,:,1) / 100;

        L_enhanced = adapthisteq(L);

        lab_img(:,:,1) = L_enhanced * 100;

        rgb_enhanced = lab2rgb(lab_img);

        out_name = fullfile(out_dir, images(img_index).name);
        imwrite(rgb_enhanced, out_name);
    end
end