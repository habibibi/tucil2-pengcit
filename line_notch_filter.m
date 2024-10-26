function outImg = line_notch_filter(img, xs, ys, D0, n, isShow)
% LINE_NOTCH_FILTER mengaplikasikan line butterworth notch filter pada
% citra di axis x dan y tertentu
%   note : fungsi juga mengaplikasikan notch pada axis pasangan -x atau -y
    [N, M, C] = size(img);
    outImg = zeros(size(img));

    % {{Generate Filter}}
    % Generate meshgrid
    u = -floor(N/2):ceil(N/2)-1;
    v = -floor(M/2):ceil(M/2)-1;
    [U, V] = meshgrid(v, u);
    
    % Initialize the filter with all ones (pass all frequencies initially)
    H = ones(N, M);
    
    % Create the notch filter by zeroing out regions around each specified 
    % notch point
    for k = 1:size(xs,1)
        % Shift the notch points to match the centered frequency 
        % coordinates
        x = xs(k) - floor(M/2);
        x1 = -x;
        
        % Calculate the distance from the current notch point
        D_k0 = abs(U - x);
        D_k1 = abs(U - x1);

        % Apply the Butterworth formula
        H = H ./ (1 + (D0 ./ D_k0).^(2*n));
        H = H ./ (1 + (D0 ./ D_k1).^(2*n));
    end

    for k = 1:size(ys,1)
        % Shift the notch points to match the centered frequency 
        % coordinates
        y = ys(k) - floor(N/2);
        y1 = -y;
        
        % Calculate the distance from the current notch point
        D_k0 = abs(V - y);
        D_k1 = abs(V - y1);

        % Apply the Butterworth formula
        H = H ./ (1 + (D0 ./ D_k0).^(2*1));
        H = H ./ (1 + (D0 ./ D_k1).^(2*1));
    end

    for ch = 1:C
        % Convert the color channel to doubles and scale it to range [0,1]
        in = im2double(img(:,:,ch));
        
        % Convert to fft and shift it
        F = fftshift(fft2(in));

        % Apply filter
        F = H .* F;

        % Display spectrum result on one color channel
        if ch == 1 && isShow
            S2 = log(1+abs(F)); 
            figure, imshow(S2,[]);
        end

        % Inverse to original image
        F = ifftshift(F);
        out = real(ifft2(F));

        % Put result image to its channel
        outImg(1:N,1:M,ch) = out;
    end
end


