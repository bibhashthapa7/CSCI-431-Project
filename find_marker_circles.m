function [centers, radii, metrics] = find_marker_circles(binary_mask)
    % Get blob properties
    props = regionprops(binary_mask, 'Area', 'Centroid', 'EquivDiameter');
    
    if isempty(props)
        centers = [];
        radii = [];
        metrics = [];
        return;
    end
    
    fprintf('\nBlob analysis:\n');
    
    % Find large blobs that could be trail markers
    min_blob_area = 3000;
    large_blobs = [props.Area] >= min_blob_area;
    large_blob_indices = find(large_blobs);
    
    fprintf('Total blobs: %d\n', length(props));
    fprintf('Large blobs (>%d pixels): %d\n', min_blob_area, sum(large_blobs));
    
    % Sort large blobs by area (largest first)
    [~, sort_idx] = sort([props(large_blob_indices).Area], 'descend');
    large_blob_indices = large_blob_indices(sort_idx);
    
    % Print large blobs
    for i = large_blob_indices
        fprintf('  Blob %d: Area=%d pixels, Centroid=(%.1f, %.1f), EquivDiameter=%.1f\n', ...
            i, props(i).Area, props(i).Centroid(1), props(i).Centroid(2), props(i).EquivDiameter);
    end
    
    % Use LARGEST blob as primary marker
    % Only use circle detection for validation/refinement
    
    centers = [];
    radii = [];
    metrics = [];
    
    % Always include the LARGEST blob (most likely the trail marker)
    largest_blob_idx = large_blob_indices(1);
    centers = [centers; props(largest_blob_idx).Centroid];
    radii = [radii; props(largest_blob_idx).EquivDiameter / 2];
    metrics = [metrics; 0.8];  % High confidence for largest blob
    
    fprintf('\nUsing largest blob %d as primary marker: radius=%.1f pixels\n', ...
        largest_blob_idx, props(largest_blob_idx).EquivDiameter / 2);
    
    % Optionally: Try to find other markers in remaining large blobs
    % Only if they're significantly large (> 10000 pixels)
    for i = 2:length(large_blob_indices)
        blob_idx = large_blob_indices(i);
        if props(blob_idx).Area > 20000  % Significant size threshold
            centers = [centers; props(blob_idx).Centroid];
            radii = [radii; props(blob_idx).EquivDiameter / 2];
            metrics = [metrics; 0.6];
            
            fprintf('Including additional large blob %d: radius=%.1f pixels\n', ...
                blob_idx, props(blob_idx).EquivDiameter / 2);
        end
    end
    
    fprintf('\nFinal detections: %d circles\n', length(radii));
end