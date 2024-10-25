function img = gaussian_noise(img, mean, sigma)
    % Adding gaussian noise to image
    img = im2double(img);
    [N, M, C] = size(img);
    gaussian_noise = mean + sigma * randn(N, M);

    for ch = 1:C
        img_ch = img(:,:,ch);
        img_ch = img_ch + gaussian_noise;
        img_ch = clip(img_ch, 0, 1);
        img(:,:,ch) = img_ch;
    end

    img = im2uint8(img);
end
