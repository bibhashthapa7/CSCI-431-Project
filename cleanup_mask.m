function clean_mask = cleanup_mask(binary_mask)
    % Close small gaps in the marker region
    se_close   = strel('disk', 5);
    clean_mask = imclose(binary_mask, se_close);

    % Fill holes so the marker is solid
    clean_mask = imfill(clean_mask, 'holes');

    % Remove tiny components
    clean_mask = bwareaopen(clean_mask, 120);

    % Remove blobs touching the image border 
    clean_mask = imclearborder(clean_mask);

    % Apply erosion
    se_erode   = strel('disk', 1);
    clean_mask = imerode(clean_mask, se_erode);
end
