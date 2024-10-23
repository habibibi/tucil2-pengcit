function outImg = GHPF(img, D0)
% GHPF Melakukan gaussian high pass filter melalui ranah frekuensi
%   D0 : frekuensi cutoff
    [N, M, C] = size(img);
    P = 2*N;
    Q = 2*M;
    outImg = zeros(N,M,C);
    for ch = 1:C
        % Mengonversi citra channel ke tipe double dan mengskalakan ke range [0,1]
        in = im2double(img(:,:,ch));
        
        % melakukan padding pada matriks kanal
        inPadded = zeros(P,Q);
        inPadded(1:N, 1:M) = in;
        
        % konversi ke bentuk FFT dan melakukan fftshift
        F = fftshift(fft2(inPadded));

        % Bangkit matriks yang menunjukkan jarak koordinat ke pust
        u = 0:(P-1);
        v = 0:(Q-1);
        idx = find(u > P/2); 
        u(idx) = u(idx) - P; 
        idy = find(v > Q/2); 
        v(idy) = v(idy) - Q; 
        [V, U] = meshgrid(v, u);
        D = sqrt(U.^2 + V.^2);

        % Membuat mask GHPF dengan cutoff frekuensi D0
        H = exp(-(D.^2)./(2*(D0^2))); 
        H = fftshift(1-H);

        G = H.*F; % aplikasikan filter kepada frekuensi citra

        % lakukan inverse shift,inverse fft, mengambil bagian real frekuensi
        % untuk mendapatkan citra hasil di ranah spatial
        G = ifftshift(G);
        outPadded = real(ifft2(G));
        
        % mendapatkan citra kanal hasil dengan membuang bagian padding
        out = outPadded(1:N,1:M);

        % masukkan hasil citra kanal ke variabel output
        outImg(1:N,1:M,ch) = out;
    end
end

