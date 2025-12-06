function main()
    is_training_dir = false;
    to_train = false;
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
        train(im_path_enhanced_marker, im_path_enhanced_no_marker);
    else
        if ~is_training_dir
            path_imgs = fullfile(directory, "contrast_enhanced");
            
            out_dir = fullfile("output", directory);
            
            classify_dir(path_imgs, out_dir);
        end
    end
end