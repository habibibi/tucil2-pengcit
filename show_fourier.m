function show_fourier(img)
% SHOW_FOURIER menampilkan spektrum fourier citra
    img = im2gray(img);
    
    F = fftshift(fft2(img));
    S2 = log(1+abs(F));
    % S2 = S2 > (mean(S2(:)) + 2 * std(S2(:)));
    f = figure; subplot(1,2,1), imshow(img), subplot(1,2,2), imshow(S2,[]);
    d = datacursormode(f);
    set(d, 'Enable', 'on', 'UpdateFcn', @(~,~) deal([])); % Prevents the data tip from showing

    uicontrol('Style', 'pushbutton', 'String', 'Show Cursor Info', ...
          'Position', [20 20 120 30], ...
          'Callback', @(src, event) showCursorInfo(d));
    datacursormode(f);
end

function showCursorInfo(dcm)
    % Retrieve and display cursor info
    cursorInfo = getCursorInfo(dcm);
    
    % Display the cursor info in a message box
    if isempty(cursorInfo)
        msgbox('No data point selected.');
    else
        % Convert cursor information to string format for display
        for k = 1:length(cursorInfo)
            fprintf('%d %d\n',cursorInfo(k).Position(1), cursorInfo(k).Position(2));
        end
    end
end