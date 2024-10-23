function img = image_convolution(img, mask)
    % Perform convolution of an image with a given mask.
    img = im2double(img);
    [M, N, C] = size(img);
    [n, ~] = size(mask);
    pad_size = floor(n / 2);
    padded_img = padarray(img, [pad_size, pad_size], 'replicate');
    mask_sum = sum(mask(:));
    img = zeros(M, N, C);

    for c = 1:C
        for i = 1:M
            for j = 1:N
                region = padded_img(i:i+n-1, j:j+n-1, c);
                conv_value = sum(sum(double(region) .* double(mask)));

                if mask_sum ~= 0
                    conv_value = conv_value / mask_sum;
                end

                img(i, j, c) = conv_value;
            end
        end
    end

    img = im2uint8(img);
end
