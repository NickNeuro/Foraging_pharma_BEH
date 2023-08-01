function [windowHandle, timeLeft] = BEH_REPEAT_TRAINING(s, taskOrder, timeLeft, subject_id, session, general_folder, windowHandle, eyeTracker)
% Written by Nick Sidorenko, PhD student at Philippe Tobler group, Zurich Center for Neuroeconomics

    %% ARGUMENTS
    if ~exist('windowHandle', 'var')
        [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5]); % full screen
%         [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5], [0 0 700 800]); % debugging mode
    end
    if exist('windowHandle', 'var') && isempty(windowHandle)
        [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5]); % full screen
%         [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5], [0 0 700 800]); % debugging mode
    end

    % KEY BOARD
    KbName('UnifyKeyNames');
    a_key = KbName('a'); 
    b_key = KbName('b'); 
    c_key = KbName('c'); 
    d_key = KbName('d'); 
    right_arrow = KbName('RightArrow'); 
    space_bar = KbName('space'); 

    % Determine dimensions of the opened screen
    [~, screenHeight] = Screen('WindowSize', windowHandle);
    
    % Colors and text
    textColor = [255 255 255]; % off white
    textSize = round(screenHeight/36); % ~30 when full screen mode
    wrapat_length = 90;
    Screen('TextSize', windowHandle, textSize);
    Screen('TextFont', windowHandle, 'Arial');
    
    if timeLeft
        start_the_task = ['Training session is over. \n Before you start with the main tasks, would you like to repeat any task? \n\n', ...
                          'If YES, press the key (A, B, C or D), which corresponds to your choice. \n\n' ...
                          'If NOT, press the SPACE BAR'];
        DrawFormattedText(windowHandle, start_the_task, 'center', 'center', textColor, wrapat_length, [], [], 3);
        Screen('Flip', windowHandle);
        check = 1;
        taskSelected = 0;
        while check
            [key_is_down, ~, key_code] = KbCheck; % check whether a key is pressed and which one 
            if key_is_down && any(key_code(a_key))
                taskSelected = taskOrder(s,1);
                check = 0;
            end
            if key_is_down && any(key_code(b_key))
                taskSelected = taskOrder(s,2);
                check = 0;
            end
            if key_is_down && any(key_code(c_key))
                taskSelected = taskOrder(s,3);
                check = 0;
            end
            if key_is_down && any(key_code(d_key))
                taskSelected = taskOrder(s,4);
                check = 0;
            end
            if key_is_down && any(key_code(space_bar))
                check = 0;
            end
        end
        
        doTraining = 0;
        switch taskSelected
            case 0
                timeLeft = 0;
            case 1
                BEH_wrapper_RISKGARP_training(subject_id, session, general_folder, windowHandle, eyeTracker, doTraining);
            case 2
                BEH_wrapper_WTP_training(subject_id, session, general_folder, windowHandle, eyeTracker, doTraining);
            case 3
                BEH_wrapper_FR_training(subject_id, session, general_folder, windowHandle, eyeTracker, doTraining);
            case 4
                BEH_wrapper_FAB_training(subject_id, session, general_folder, windowHandle, eyeTracker, doTraining);
        end
    else
    	start_the_task = 'Training session is over. \n Please stay in your seat. Study investigator will come by to you in a few minutes';
        DrawFormattedText(windowHandle, start_the_task, 'center', 'center', textColor, wrapat_length, [], [], 3);
        Screen('Flip', windowHandle);
    end
    WaitSecs(0.5);
end