function [windowHandle, et] = BEH_ANNOUNCE_TIME_TASK(windowHandle, eyeTracker)
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
%         [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5]); % full screen
        [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5], screenRect); % debugging mode
    end
    if exist('windowHandle', 'var') && isempty(windowHandle)
%         [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5]); % full screen
        [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5], screenRect); % debugging mode
    end

    HideCursor;
    
    % KEY BOARD
    KbName('UnifyKeyNames');
    to_right = KbName('RightArrow'); 
    f_key = KbName('f');

    % Determine dimensions of the opened screen
    [screenWidth, screenHeight] = Screen('WindowSize', windowHandle);
    centerX = floor(0.5 * screenWidth); 
    
    % Colors and text
    textColor = [255 255 255]; % off white
    textSize = round(screenHeight/36); % ~30 when full screen mode
    wrapat_length = 80;
    Screen('TextSize', windowHandle, textSize);
    Screen('TextFont', windowHandle, 'Arial');
    
    %% WELCOME MESSAGE
    welcome_message = 'WELCOME TO OUR STUDY ABOUT DECISION MAKING! \n Please wait for instructions';
    
    DrawFormattedText(windowHandle, welcome_message, 'center', 'center', textColor, wrapat_length, [], [], 3);
    Screen('Flip', windowHandle);

    check = 1;
    while check
        [key_is_down, ~, key_code] = KbCheck; % check whether a key is pressed and which one 
        if key_is_down && any(key_code(f_key))
            check = 0;
        end
    end
    WaitSecs(0.2);
    
    %% GENERAL INSTRUCTIONS
    general_instructions = ['Thank you for supporting our study. We also ask that you do not use your phone, mp3 player or any external devices while you perform the task. Thanks! \n\n' ...
                            'Today, you will perform two basic tasks. \n\n ', ...
                            'To continue, please press the RIGHT ARROW on the KEYBOARD.'];
    
    DrawFormattedText(windowHandle, general_instructions, centerX/2, 'center', textColor, wrapat_length, [], [], 1.4);
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