function [windowHandle, et] = BEH_WELCOME(windowHandle, eyeTracker)
% Written by Nick Sidorenko, PhD student at Philippe Tobler group, Zurich Center for Neuroeconomics

    %% ARGUMENTS
    screenRect = [0 0 700 700];
    et = [];
    if eyeTracker
        et = EyeTracker();
        et.init(max(Screen('Screens')), screenRect);
        et.calibrate();
    end
    
    if ~exist('windowHandle', 'var')
        [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5]); % full screen
%         [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5], screenRect); % debugging mode
    end
    if exist('windowHandle', 'var') && isempty(windowHandle)
        [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5]); % full screen
%         [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5], screenRect); % debugging mode
    end

    HideCursor;
    
    % KEY BOARD
    KbName('UnifyKeyNames');
    to_right = KbName('RightArrow'); 
    t_key = KbName('t');

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
        if key_is_down && any(key_code(t_key))
            check = 0;
        end
    end
    WaitSecs(0.2);
    
    %% GENERAL INSTRUCTIONS
    general_instructions = ['Today you will do 4 decision-making tasks. The experiment will start with instructions. ', ...
                            'Please read these instructions carefully and let the experimenter know if you have questions at any point. ', ...
                            'You will also have chances to practice for each task. \n\n', ...
                            'Once you fully understood the goal of each task (you will have to pass the comprehension questions), you will start the main tasks. \n', ...
                            'Decisions that you will make during each task will constitute your CASH BONUS for today’s experiment. ', ...
                            'At the very end, ONE of the tasks will be RANDOMLY selected and you will get the cash bonus from that task. \n', ...
                            'Please note that the TASKS ARE INDEPENDENT of each other, which means that your actions during one task will not affect another one. \n', ...
                            'The expected earning of each task is similar. So you should do your best in every task. ', ...
                            'You will see more details in the following pages. \n\n', ...
                            'Finally, please try to keep fixating the middle of the screen, i.e., look at the cross mark during the whole experiment. \n\n', ...
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