function img = alpha_trimmed_mean_filter(img, n, alpha)
    % Filtering image using nxn alpha trimmed mean filter
    img = im2double(img);
    [N, M, C] = size(img);
    pad_size = floor(n / 2);
    padded_img = padarray(img, [pad_size, pad_size], 'replicate');
    img = zeros(N, M, C);
    d = round((alpha / 100) * n * n / 2); % Number of min and max values to trim

    for c = 1:C
        for i = 1:N
            for j = 1:M
                region = padded_img(i:i+n-1, j:j+n-1, c);
                sorted_region = sort(region(:));
                trimmed_region = sorted_region(d+1 : n*n-d); % Trim d elements from each side
                img(i, j, c) = mean(trimmed_region);
            end
        end
    end

    img = im2uint8(img);
end
