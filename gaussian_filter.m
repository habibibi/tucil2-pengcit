function img = gaussian_filter(img, n, sigma)
    % Filtering image using nxn gaussian filter
    [x, y] = meshgrid(-(n-1)/2:(n-1)/2, -(n-1)/2:(n-1)/2);
    mask = exp(-(x.^2 + y.^2) / (2 * sigma^2));

    img = image_convolution(img, mask);
end
