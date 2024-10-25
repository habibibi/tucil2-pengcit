function img = salt_and_pepper_noise(img, d)
    % Adding salt and pepper noise to image
    [N, M, C] = size(img);
    prob_mat = rand(N, M);

    for ch = 1:C
        img_ch = img(:,:,ch);

        img_ch(prob_mat < d / 2) = 255; % salt noise
        img_ch(prob_mat > (1 - d / 2)) = 0; % pepper noise

        img(:,:,ch) = img_ch;
    end
end
