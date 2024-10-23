function [matrix, isValid] = parse_mask_input(text)
    % Parse a string input and checks if it forms a valid nxn matrix.
    % Returns the matrix and a condition (isValid) if the matrix is valid.

    n = length(text);
    matrix = zeros(n, n);
    for i = 1:length(text)
        % Split row by spaces/tabs
        rowElements = strsplit(strtrim(text{i}), {' ', '\t'});

        % Convert row elements to numeric
        numericRow = str2double(rowElements);

        % Check if all elements are valid numbers
        if any(isnan(numericRow))
            isValid = false;
            matrix = [];
            return;
        end

        % Check column size
        if length(numericRow) ~= n
            isValid = false;
            matrix = [];
            return;
        end

        matrix(i, :) = numericRow;
    end

    % Matrix is valid
    isValid = true;
end
