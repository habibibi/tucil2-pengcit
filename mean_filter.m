function img = mean_filter(img, n)
    % Filtering image using nxn mean filter
    mask = ones(n, n);
    img = image_convolution(img, mask);
end
