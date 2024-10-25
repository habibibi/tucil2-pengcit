function outImg = ideal_notch_filter(img, notch_points, D0)
% IDEAL_NOTCH_FILTER mengaplikasikan ideal notch filter pada
% citra di titik tertentu
%   note : fungsi juga mengaplikasikan notch pada titik pasangan (-x,-y)
    [N, M, C] = size(img);
    outImg = zeros(size(img));

    % {{Generate Filter}}
    % Generate meshgrid
    u = -floor(N/2):floor(N/2)-1;
    v = -floor(M/2):floor(M/2)-1;
    [U, V] = meshgrid(v, u);
    
    % Initialize the filter with all ones (pass all frequencies initially)
    H = ones(N, M);
    
    % Create the notch filter by zeroing out regions around each specified 
    % notch point with its pair
    for k = 1:size(notch_points, 1)
        % Shift the notch points to match the centered frequency 
        % coordinates
        u0 = notch_points(k, 1) - floor(N/2);
        v0 = notch_points(k, 2) - floor(M/2);
        u1 = -u0;
        v1 = -v0;
        
        % Calculate the distance from the current notch point
        D_k0 = sqrt((U - v0).^2 + (V - u0).^2);
        D_k1 = sqrt((U - v1).^2 + (V - u1).^2);
        
        % Set frequencies within radius D0 around the notch point to zero (block)
        H(D_k0 <= D0) = 0;
        H(D_k1 <= D0) = 0;
    end

    for ch = 1:C
        % Convert the color channel to doubles and scale it to range [0,1]
        in = im2double(img(:,:,ch));
        
        % Convert to fft and shift it
        F = fftshift(fft2(in));

        % Apply filter
        F = H .* F;

        % Display spectrum result on one color channel
        if ch == 1
            S2 = log(1+abs(F)); % use abs to compute the magnitude (handling imaginary) and use log to brighten display 
            figure, imshow(S2,[]);
        end

        % Inverse to original image
        F = ifftshift(F);
        out = real(ifft2(F));

        % Put result image to its channel
        outImg(1:N,1:M,ch) = out;
    end
end


