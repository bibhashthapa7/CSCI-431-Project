function change_name()
    directories = {'A', 'B', 'C', 'D'};

    for dir_index = 1: length(directories)
        curr_dir = directories{dir_index};

        images = dir(fullfile(curr_dir, '*.jpg'));

        for  img_index = 1: length(images)
            old_name = fullfile(curr_dir, images(img_index).name);
            new_name = fullfile(curr_dir, curr_dir + string(img_index) + ".jpg");

            movefile(old_name, new_name);
        end
    end
end