function imgOut = GLPF(img, D0)
    % Filtering image using Gaussian Low Pass Filter
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

        % GLPF mask
        u = 0:(P-1);
        v = 0:(Q-1);
        idx = find(u > P/2);
        u(idx) = u(idx) - P;
        idy = find(v > Q/2);
        v(idy) = v(idy) - Q;

        [V, U] = meshgrid(v, u);
        D = sqrt(U.^2 + V.^2);

        H = exp(-(D.^2)./(2*(D0^2)));
        H = fftshift(H);

        % Apply the filter mask
        G = F .* H;

        % Shift the frequency components back
        G = ifftshift(G);

        % Inverse Fourier Transform to obtain the filtered image
        img_filtered = real(ifft2(G));
        img_filtered = img_filtered(1:N, 1:M);

        imgOut(1:N, 1:M, ch) = img_filtered;
    end
end