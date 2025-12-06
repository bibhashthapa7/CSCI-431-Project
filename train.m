function train(training_enhanced_marker_dir,training_enhanced_no_dir)
    fg_samples = [];

    marker_imgs = dir(fullfile(training_enhanced_marker_dir, '*.jpg'));

    for k = 1:min(10, length(marker_imgs))

        im = imread(fullfile(training_enhanced_marker_dir, marker_imgs(k).name));
        im_lab = rgb2lab(im);
        a_channel = im_lab(:,:,2);
        b_channel = im_lab(:,:,3);

        figure; imshow(im); axis image;
        fprintf('Select FOREGROUND points \n' );
        [x_fg, y_fg] = ginput();
        close;

        fg_indices = sub2ind(size(a_channel), round(y_fg), round(x_fg));
        fg_samples = [fg_samples; [a_channel(fg_indices), b_channel(fg_indices)]];
    end

    bg1_samples = [];
    bg2_samples = [];
    bg3_samples = [];
    bg4_samples_random = [];

    no_marker_imgs = dir(fullfile(training_enhanced_no_dir, '*.jpg'));
    total_images = min(length(no_marker_imgs), 5);
    
    for class = 1:3
        random_indices = randperm(length(no_marker_imgs), total_images);

        for k = 1:total_images
            im = imread(fullfile(training_enhanced_no_dir, no_marker_imgs(random_indices(k)).name));
            im_lab = rgb2lab(im);
            a_channel = im_lab(:,:,2);
            b_channel = im_lab(:,:,3);
            
            figure; imshow(im); axis image;
            if class == 1
                fprintf('SELECT BACKGROUND CLASS 1 (leaves)\n');
            elseif class == 2
                fprintf('SELECT BACKGROUND CLASS 2 (branches/tree trunks)\n');
            else
                fprintf('SELECT BACKGROUND CLASS 3 (ground/soil/rocks)\n');
            end

            [x_bg, y_bg] = ginput();
            close;
            
            bg_indices = sub2ind(size(a_channel), round(y_bg), round(x_bg));

            if class == 1
                bg1_samples = [bg1_samples; [a_channel(bg_indices), b_channel(bg_indices)]];
            elseif class == 2
                bg2_samples = [bg2_samples; [a_channel(bg_indices), b_channel(bg_indices)]];
            else
                bg3_samples = [bg3_samples; [a_channel(bg_indices), b_channel(bg_indices)]];
            end
        end
    end

    random_indices = randperm(length(no_marker_imgs), total_images);
    for k = 1:total_images
            im = imread(fullfile(training_enhanced_no_dir, no_marker_imgs(random_indices(k)).name));
            im_lab = rgb2lab(im);
            a_channel = im_lab(:,:,2);
            b_channel = im_lab(:,:,3);
            
            x_rand_indices = randperm(size(a_channel,1), 200);
            y_rand_indices = randperm(size(a_channel,2), 200);

            [X, Y] = meshgrid(y_rand_indices, x_rand_indices);
            bg_indices = sub2ind(size(a_channel), Y(:), X(:));

            bg4_samples_random = [bg4_samples_random; [a_channel(bg_indices), b_channel(bg_indices)]];
    end
    save("training_samples", 'fg_samples', 'bg1_samples', 'bg2_samples', 'bg3_samples', 'bg4_samples_random');
end