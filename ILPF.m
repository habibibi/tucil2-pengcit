function imgOut = ILPF(img, D0)
    % Filtering image using Ideal Low Pass Filter
    [N, M, C] = size(img);
    img = im2double(img);
    P = 2*N;
    Q = 2*M;
    imgOut = zeros(N, M, C);

    for ch = 1:C
        % Apply Fourier Transform
        mat = zeros(P,Q);
        mat(1:N, 1:M) = img(:,:,ch);
        F = fft2(mat);
        F = fftshift(F);

        % ILPF mask
        u = 0:(P-1);
        v = 0:(Q-1);
        idx = find(u > P/2);
        u(idx) = u(idx) - P;
        idy = find(v > Q/2);
        v(idy) = v(idy) - Q;

        [V, U] = meshgrid(v, u);
        D = sqrt(U.^2 + V.^2);

        H = double(D <= D0);

        % Apply the filter mask
        G = F .* H;

        % Shift the frequency components back
        G = ifftshift(G);

        % Inverse Fourier Transform to obtain the filtered image
        img_filtered = real(ifft2(G));
        img_filtered = img_filtered(1:N, 1:M);

        imgOut(1:N, 1:M, ch) = im2uint8(img_filtered);
    end
end