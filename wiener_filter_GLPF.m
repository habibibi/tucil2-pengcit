function out = wiener_filter_GLPF(img, D0, k)
% WIENER_FILTER_GLPF dekonvolusi citra GLPF blur dengan menggunakan 
% filter wiener
%   img : citra input
%   D0 : cutoff frequency
%   k : konstan

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

% Create Gaussian Low Pass Filter
u = 0:(N-1);
v = 0:(M-1);
idx = find(u > N/2); 
u(idx) = u(idx) - N; 
idy = find(v > M/2); 
v(idy) = v(idy) - M;
[V, U] = meshgrid(v, u); 
D = sqrt(U.^2 + V.^2); 
H = exp(-(D.^2)./(2*(D0^2)));
H = fftshift(H);

% Create wiener filter
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

