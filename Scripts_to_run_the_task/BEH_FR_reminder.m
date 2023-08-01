function windowHandle = BEH_FR_reminder(windowHandle)
% Written by Nick Sidorenko, PhD student at Philippe Tobler group, Zurich Center for Neuroeconomics

    %% ARGUMENTS
    if ~exist('windowHandle', 'var')
        [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [255 255 255]/2); % full screen
%         [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5], [0 0 1280 1024]); % debugging mode
    end
    if exist('windowHandle', 'var') && isempty(windowHandle)
        [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [255 255 255]/2); % full screen
%         [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5], [0 0 1280 1024]); % debugging mode
    end

    % KEY BOARD
    KbName('UnifyKeyNames');
    to_right = KbName('RightArrow'); 

    % Determine dimensions of the opened screen
    [screenWidth, screenHeight] = Screen('WindowSize', windowHandle);
    centerX = round(screenWidth*0.5);
    
    % Colors and text
    textColor = [255 255 255]; % off white
    textSize = round(screenHeight/36); % ~30 when full screen mode
    wrapat_length = 90;
    Screen('TextSize', windowHandle, textSize);
    Screen('TextFont', windowHandle, 'Arial');

    reminder = ['REMINDER:\n\nIn this task, your goal is to decide the BEST TIME TO LEAVE each field, so that you get as much milk as you can. ' ...
                'You need to take into account: \n', ...
                '   - It takes 6 seconds to walk between fields without collecting any milk \n', ...
                '   - What the milk return is in the current field \n', ...
                '   - Whether you’re on a gold or green farm – i.e. what are the chances the next field will be good/average/poor \n\n', ...
                'You will PRESS and HOLD the SPACE BAR to enter in a field. When you want to leave the field, just RELEASE the space bar. \n\n ', ...
                'Now you will have 3 PRACTICE rounds and THEN you will be able to start the real task. \n\n', ...
                'Please try to keep your FIXATION AT THE MIDDLE (the cross mark) during the whole experiment.\n' ...
                'Please press the RIGHT ARROW on the KEYBOARD to start PRACTICING'];    
    
    DrawFormattedText(windowHandle, reminder, centerX/2, 'center', textColor, wrapat_length, [], [], 2);
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