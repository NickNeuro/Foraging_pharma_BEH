function [windowHandle] = BEH_FR_payment(finalAmount, windowHandle)
% Written by Nick Sidorenko, PhD student at Philippe Tobler group, Zurich Center for Neuroeconomics

%%%% PREPARATIONS %%%%
%% KEY BOARD
KbName('UnifyKeyNames');
study_end = KbName('e'); 

%% SCREEN
% Recognize the screen
if ~exist('windowHandle', 'var')
    [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [255 255 255]/2); % full screen
%     [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5], [0 0 700 900]); % debugging mode
end
if exist('windowHandle', 'var') && isempty(windowHandle)
    [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [255 255 255]/2); % full screen
%     [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5], [0 0 700 900]); % debugging mode
end
%HideCursor;

% Determine dimensions of the opened screen
[~, screenHeight] = Screen('WindowSize', windowHandle);
textSizeGain = round(screenHeight/36); % 30 when full screen mode
Screen('TextFont', windowHandle,'Arial');
Screen('TextSize', windowHandle, textSizeGain);
textColor = [255 255 255]; % contrasted grey


%% TASK %%

    % Display the gain
    finalAmountStr = ['The task about milk was randomly selected for you \n\n', ...
                      'Your gain for this task is ' num2str(round(finalAmount*0.008,1)) ' CHF \n', ...
                      'Your participation fee is ' num2str(30*5) ' CHF \n', ...
                      'Your total gain for participating in the study is ' num2str(round(finalAmount*0.008 + 30*5,1)) ' CHF \n\n', ...
                      'Please stay in your seat. Study investigator will come by to you'];
    DrawFormattedText(windowHandle, finalAmountStr, 'center', 'center', textColor, [], [], [], 1.6); % final amount
    Screen('Flip', windowHandle);
    check = 1;
    while check
        [key_is_down, ~, key_code] = KbCheck; % check whether a key is pressed and which one 
        if key_is_down && any(key_code(study_end))
            check = 0;
        end
    end
    WaitSecs(0.5);
%% CLOSE DISPLAY
%Screen('CloseAll');

end % end of function
