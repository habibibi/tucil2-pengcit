function out = wiener_filter(img, PSF, k)
%wiener_FILTER_MOTION dekonvolusi citra motion blur menggunakan wiener
%filter
%   img : citra input
%   PSF : Point Spread Function (PSF) dalam bentuk filter konvolusi
%   k : Konstan

% Check if the input image is grayscale or color
if ndims(img) == 2
    % Grayscale image
    channels = 1;
else
    % Color image (assumed to be RGB)
    channels = size(img, 3);
end

% Initialize the output image
out = zeros(size(img));

N = size(img,1);
M = size(img,2);

% Pad the PSF and reposition origin to (0,0)
padSize = [N - size(PSF, 1), M - size(PSF, 2)];
PSF = padarray(PSF, ceil(padSize / 2), 0, 'pre');   % Pad top and left
PSF = padarray(PSF, floor(padSize / 2), 0, 'post'); % Pad bottom and right
PSF = ifftshift(PSF);

% Create wiener filter
H = fftshift(fft2(PSF, N, M));
H2 = abs(H).^2;
Hw = (1 ./ H) .* (H2 ./ (H2 + k));

% Loop through each channel
for c = 1:channels
    % Select the current channel
    if channels > 1
        current_channel = img(:, :, c);
    else
        current_channel = img;
    end
    
    % Apply the Fourier Transform to the image (with padding)

    F = fftshift(fft2(current_channel));

    % Apply the wiener filter in the frequency domain
    G = Hw .* F;
    
    % Shift the result back and apply inverse Fourier transform
    G = ifftshift(G);
    out_channel = real(ifft2(G));
    
    % Store the processed channel back into the output image
    if channels > 1
        out(:, :, c) = out_channel;
    else
        out = out_channel; % For grayscale
    end
end

out = mat2gray(out);  % Normalize the entire output image

