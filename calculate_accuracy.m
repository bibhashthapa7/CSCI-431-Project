% Calculate and display accuracy metrics
function calculate_accuracy(detection_results, out_dir)
    % Load ground truth labels
    labels = test_labels();
    
    % Initialize confusion matrix counters
    true_positives = 0;
    false_positives = 0;
    true_negatives = 0;
    false_negatives = 0;
    
    fprintf('\n========================================\n');
    fprintf('Calculating accuracy:\n');

    
    % Process each detection result
    for i = 1:length(detection_results)
        img_name = detection_results(i).filename;
        num_detected = detection_results(i).num_detected;
        
        if ~isKey(labels, img_name)
            continue;
        end
        
        has_marker = labels(img_name);
        predicted_has_marker = (num_detected > 0);
        
        % Update confusion matrix
        if has_marker == 1 && predicted_has_marker == true
            true_positives = true_positives + 1;
        elseif has_marker == 0 && predicted_has_marker == true
            false_positives = false_positives + 1;
        elseif has_marker == 1 && predicted_has_marker == false
            false_negatives = false_negatives + 1;
        else
            true_negatives = true_negatives + 1;
        end
    end
    
    % Calculate metrics
    total = true_positives + false_positives + true_negatives + false_negatives;
    
    fprintf('True Positives (TP): %d\n', true_positives);
    fprintf('False Positives (FP): %d\n', false_positives);
    fprintf('True Negatives (TN): %d\n', true_negatives);
    fprintf('False Negatives (FN): %d\n', false_negatives);
    fprintf('Total Images: %d\n\n', total);
    
    accuracy = (true_positives + true_negatives) / total * 100;
    
    if (true_positives + false_positives) > 0
        precision = true_positives / (true_positives + false_positives) * 100;
    else
        precision = 0;
    end
    
    if (true_positives + false_negatives) > 0
        recall = true_positives / (true_positives + false_negatives) * 100;
    else
        recall = 0;
    end
    
    % Display overall metrics
    fprintf('Overall Metrics:\n');
    fprintf('Accuracy: %.2f%%\n', accuracy);
    fprintf('Precision: %.2f%%\n', precision);
    fprintf('Recall: %.2f%%\n', recall);
    
    % Create confusion matrix visualization
    figure('Position', [100, 100, 600, 500]);
    conf_matrix = [true_positives, false_positives; false_negatives, true_negatives];
    h = heatmap({'Actual: Has Marker', 'Actual: No Marker'}, ...
            {'Predicted: Has Marker', 'Predicted: No Marker'}, ...
            conf_matrix, ...
            'ColorbarVisible', 'off');
    h.Title = sprintf('Confusion Matrix - Accuracy: %.1f%%', accuracy);
    h.FontSize = 14;
    
    saveas(gcf, fullfile(out_dir, 'confusion_matrix.png'));
    fprintf('Confusion matrix saved to: %s\n\n', fullfile(out_dir, 'confusion_matrix.png'));
    close;
end