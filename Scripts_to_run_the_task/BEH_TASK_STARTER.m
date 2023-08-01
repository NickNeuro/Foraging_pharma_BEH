function windowHandle = BEH_TASK_STARTER(windowHandle)
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
    to_right = KbName('RightArrow'); 

    % Determine dimensions of the opened screen
    [~, screenHeight] = Screen('WindowSize', windowHandle);
    
    % Colors and text
    textColor = [255 255 255]; % off white
    textSize = round(screenHeight/36); % ~30 when full screen mode
    wrapat_length = 90;
    Screen('TextSize', windowHandle, textSize);
    Screen('TextFont', windowHandle, 'Arial');
    
    start_the_task = 'Training session is over. \n Please press the RIGHT ARROW on the KEYBOARD when you are ready to START THE TASK';
    
    DrawFormattedText(windowHandle, start_the_task, 'center', 'center', textColor, wrapat_length, [], [], 3);
    Screen('Flip', windowHandle);

    check = 1;
    while check
        [key_is_down, ~, key_code] = KbCheck; % check whether a key is pressed and which one 
        if key_is_down && any(key_code(to_right))
            check = 0;
        end
    end
    WaitSecs(0.5);
end