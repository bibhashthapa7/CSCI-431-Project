function main()
    is_training_dir = true;
    to_train = true; %true to train interactive, false to load stored vals
    is_enhanced = true;

    directory = "training";
    if ~is_training_dir
        directory = "testing";
    end
    
    if ~is_enhanced
        contrast_enhancement(directory);
    end

    im_path_enhanced_marker = fullfile(directory, "contrast_enhanced", "markers");
    im_path_enhanced_no_marker = fullfile(directory, "contrast_enhanced", "background");

    if to_train
        train(img_path_enhanced_marker, im_path_enhanced_no_marker);
    else

    if ~is_training_dir
        path_imgs = fullfile(directory, "contrast_enhanced");
        classify_dir();
    end
end