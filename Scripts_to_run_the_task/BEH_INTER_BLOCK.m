function windowHandle = BEH_INTER_BLOCK(windowHandle)
% Written by Nick Sidorenko, PhD student at Philippe Tobler group, Zurich Center for Neuroeconomics

    %% ARGUMENTS
    if ~exist('windowHandle', 'var')
        [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [255 255 255]/2); % full screen
%         [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5], [0 0 700 800]); % debugging mode
    end
    if exist('windowHandle', 'var') && isempty(windowHandle)
        [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [255 255 255]/2); % full screen
%         [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5], [0 0 700 800]); % debugging mode
    end

    % KEY BOARD
    KbName('UnifyKeyNames');

    % Determine dimensions of the opened screen
    [~, screenHeight] = Screen('WindowSize', windowHandle);
    
    % Colors and text
    textColor = [255 255 255]; % off white
    textSize = round(screenHeight/36); % ~30 when full screen mode
    wrapat_length = 90;
    Screen('TextSize', windowHandle, textSize);
    Screen('TextFont', windowHandle, 'Arial');
    
    start_the_task = 'You can make a break of 1 minute';
    
    k = 60;
    for i = 1:60
        Screen('TextSize', windowHandle, textSize);
        Screen('TextFont', windowHandle, 'Arial');
        DrawFormattedText(windowHandle, start_the_task, 'center', screenHeight/2 - 50, textColor, wrapat_length, [], [], 3);
        Screen('TextSize', windowHandle, textSize*2);
        Screen('TextFont', windowHandle, 'Arial');
        DrawFormattedText(windowHandle, num2str(k), 'center', 'center', textColor, wrapat_length, [], [], 3);
        Screen('Flip', windowHandle);
        WaitSecs(1);
        k = k - 1;
    end
    Screen('TextSize', windowHandle, textSize);
    Screen('TextFont', windowHandle, 'Arial');
    DrawFormattedText(windowHandle, start_the_task, 'center', screenHeight/2 - 50, textColor, wrapat_length, [], [], 3);
    Screen('TextSize', windowHandle, textSize*2);
    Screen('TextFont', windowHandle, 'Arial');
    DrawFormattedText(windowHandle, num2str(0), 'center', 'center', textColor, wrapat_length, [], [], 3);
    Screen('Flip', windowHandle);

end