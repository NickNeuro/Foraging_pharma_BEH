function  windowHandle = BEH_SUPP_TASKS(windowHandle, which_task, subject_id, write_folder, eyeTracker, screeningORmain)
% Written by Nick Sidorenko, PhD student at Philippe Tobler group, Zurich Center for Neuroeconomics

    %% ARGUMENTS    
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
    start_tasks = KbName('RightArrow'); 

    % Determine dimensions of the opened screen
    [~, screenHeight] = Screen('WindowSize', windowHandle);
    
    % Colors and text
    textColor = [255 255 255]; % off white
    textSize = round(screenHeight/36); % ~30 when full screen mode
    wrapat_length = 90;
    Screen('TextSize', windowHandle, textSize);
    Screen('TextFont', windowHandle, 'Arial');
    
    switch which_task
        case 1
            switch screeningORmain
                case 'screening'
                    start_the_task = 'You will now do two supplementary short tasks.';
                case 'main'
                    start_the_task = 'You will now do two supplementary short tasks. \nPlease raise your hand';
            end
        case 2
            start_the_task = 'You will now do the second supplementary short task. \nPlease raise your hand';
    end
    audio_message = [];
    save([write_folder filesep 'raise_hand_eye_' subject_id '.mat'], 'audio_message');
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