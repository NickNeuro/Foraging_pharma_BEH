function windowHandle = BEH_INTER_TASKS(o, training_or_task, write_folder, subject_id, windowHandle)
% Written by Nick Sidorenko, PhD student at Philippe Tobler group, Zurich Center for Neuroeconomics

    %% ARGUMENTS
    if ~exist('windowHandle', 'var')
        [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5]); % full screen
%         [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5], [0 0 1280 1024]); % debugging mode
    end
    if exist('windowHandle', 'var') && isempty(windowHandle)
        [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5]); % full screen
%         [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5], [0 0 1280 1024]); % debugging mode
    end
%     HideCursor;
    
    % KEY BOARD
    KbName('UnifyKeyNames');
    to_right = KbName('RightArrow'); 

    % Determine dimensions of the opened screen
    [~, screenHeight] = Screen('WindowSize', windowHandle);
    
    % Colors and text
    textColor = [255 255 255]; % off white
    textSize1 = round(screenHeight/21); % ~54 when full screen mode
    textSize2 = round(screenHeight/36); % ~30 when full screen mode
    Screen('TextFont', windowHandle, 'Arial');

    switch o
        case 1
            Screen('TextSize', windowHandle, textSize1);
            DrawFormattedText(windowHandle, 'TASK A', 'center', 'center', textColor);
        case 2
            Screen('TextSize', windowHandle, textSize1);
            DrawFormattedText(windowHandle, 'TASK B', 'center', 'center', textColor);
            Screen('TextSize', windowHandle, textSize2);        
        case 3
            Screen('TextSize', windowHandle, textSize1);
            DrawFormattedText(windowHandle, 'TASK C', 'center', 'center', textColor);
        case 4
            Screen('TextSize', windowHandle, textSize1);
            DrawFormattedText(windowHandle, 'TASK D', 'center', 'center', textColor);
    end   
    if training_or_task
        audio_message = [];
        save([write_folder filesep 'raise_hand_eye_' subject_id '.mat'], 'audio_message');
        Screen('TextSize', windowHandle, textSize2);
        DrawFormattedText(windowHandle, 'Please raise your hand', 'center', screenHeight*3/4, textColor);
        Screen('Flip', windowHandle);
    else
        Screen('TextSize', windowHandle, textSize2);
        DrawFormattedText(windowHandle, 'Please press the RIGHT ARROW, when you are ready to continue', 'center', screenHeight*3/4, textColor);
        Screen('Flip', windowHandle);
    end

    check = 1;
    while check
        [key_is_down, ~, key_code] = KbCheck; % check whether a key is pressed and which one 
        if key_is_down && any(key_code(to_right))
            check = 0;
        end
    end
    WaitSecs(0.5);
end