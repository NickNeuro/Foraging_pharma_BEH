function [windowHandle, et] = BEH_INTER_SESSIONS(windowHandle, eyeTracker)
% Written by Nick Sidorenko, PhD student at Philippe Tobler group, Zurich Center for Neuroeconomics

    %% ARGUMENTS
    screenRect = [];
    et = [];
    if eyeTracker
        et = EyeTracker();
        et.init(max(Screen('Screens')), screenRect);
%         et.calibrate();
    end
    
    if ~exist('windowHandle', 'var')
        [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5]); % full screen
%         [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5], screenRect); % debugging mode
    end
    if exist('windowHandle', 'var') && isempty(windowHandle)
        [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5]); % full screen
%         [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5], screenRect); % debugging mode
    end

    % KEY BOARD
    KbName('UnifyKeyNames');
    start_tasks = KbName('a'); 

    % Determine dimensions of the opened screen
    [~, screenHeight] = Screen('WindowSize', windowHandle);
    
    % Colors and text
    textColor = [255 255 255]; % off white
    textSize = round(screenHeight/36); % ~30 when full screen mode
    wrapat_length = 90;
    Screen('TextSize', windowHandle, textSize);
    Screen('TextFont', windowHandle, 'Arial');
    
    start_the_task = 'You are about to begin with the main tasks \n Please stay in your seat and wait for following instructions';
    
    DrawFormattedText(windowHandle, start_the_task, 'center', 'center', textColor, wrapat_length, [], [], 3);
    Screen('Flip', windowHandle);

    check = 1;
    while check
        [key_is_down, ~, key_code] = KbCheck; % check whether a key is pressed and which one 
        if key_is_down && any(key_code(start_tasks))
            check = 0;
        end
    end
    WaitSecs(0.5);
end