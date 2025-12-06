function [centers, radii, metrics] = find_marker_circles(binary_mask)
    % Get blob properties
    props = regionprops(binary_mask, 'Area', 'Centroid', 'EquivDiameter');
    
    if isempty(props)
        centers = [];
        radii = [];
        metrics = [];
        return;
    end
    
    % Find large blobs that could be trail markers
    min_blob_area = 3000;
    large_blobs = [props.Area] >= min_blob_area;
    large_blob_indices = find(large_blobs);
    
    % Check if no large blobs found
    if isempty(large_blob_indices)
        centers = [];
        radii = [];
        metrics = [];
        return;
    end
    
    % Sort large blobs by area (largest first)
    [~, sort_idx] = sort([props(large_blob_indices).Area], 'descend');
    large_blob_indices = large_blob_indices(sort_idx);
    
    % Use largest blob as primary marker
    centers = [];
    radii = [];
    metrics = [];
    
    largest_blob_idx = large_blob_indices(1);
    centers = [centers; props(largest_blob_idx).Centroid];
    radii = [radii; props(largest_blob_idx).EquivDiameter / 2];
    metrics = [metrics; 0.8];
    
    % Include additional large blobs if significant
    max_markers = 2; 
    
    for i = 2:length(large_blob_indices)
        % Stop if we have reached the maximum
        if length(radii) >= max_markers
            break;
        end
        
        blob_idx = large_blob_indices(i);

        % Detect large blobs only
        if props(blob_idx).Area > 20000  
            centers = [centers; props(blob_idx).Centroid];
            radii = [radii; props(blob_idx).EquivDiameter / 2];
            metrics = [metrics; 0.6];
        end
    end
end