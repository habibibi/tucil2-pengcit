function imgOut = high_boost_filter(img, D0, alpha)
    % High Boost Filtering for image brightening in frequency domain
    H = GHPF(img, D0);
    imgOut = (alpha - 1) * img + im2uint8(H);
end