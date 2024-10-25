function img = harmonic_mean_filter(img, n)
    % Filtering image using nxn harmonic mean filter
    img = im2double(img);
    [N, M, C] = size(img);
    pad_size = floor(n / 2);
    padded_img = padarray(img, [pad_size, pad_size], 'replicate');
    img = zeros(N, M, C);

    for c = 1:C
        for i = 1:N
            for j = 1:M
                region = padded_img(i:i+n-1, j:j+n-1, c);
                img(i, j, c) = numel(region) / sum(1 ./ (region(:) + eps));
            end
        end
    end

    img = im2uint8(img);
end
