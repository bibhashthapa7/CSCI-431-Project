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

    mahalanobis(is_interactive, directory);
    
end