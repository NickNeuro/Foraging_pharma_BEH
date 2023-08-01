function [windowHandle, et] = BEH_WAIT(windowHandle, eyeTracker)
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
    welcome_message = 'Well done! \n Please raise your hand';
    
    DrawFormattedText(windowHandle, welcome_message, 'center', 'center', textColor, wrapat_length, [], [], 3);
    Screen('Flip', windowHandle);

    

end