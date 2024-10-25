function show_fourier(img)
% SHOW_FOURIER menampilkan spektrum fourier citra
    img = im2gray(img);
    
    F = fftshift(fft2(img));
    S2 = log(1+abs(F));
    figure, subplot(1,2,1), imshow(img), subplot(1,2,2), imshow(S2,[]);
    datacursormode on;

end
