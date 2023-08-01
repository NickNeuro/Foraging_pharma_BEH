function windowHandle = BEH_GUM_INSTRUCTIONS(windowHandle, write_folder, subject_id, session)
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
    g_key = KbName('g');
    c_key = KbName('c');

    % Determine dimensions of the opened screen
    [screenWidth, screenHeight] = Screen('WindowSize', windowHandle);
    centerX = floor(0.5 * screenWidth);
    centerY = floor(0.5 * screenHeight);
    crossSize = screenHeight/216;
    
    % Colors and text
    textColor = [255 255 255]; % off white
    textSize = round(screenHeight/36); % ~30 when full screen mode
    wrapat_length = 90;
    Screen('TextSize', windowHandle, textSize);
    Screen('TextFont', windowHandle, 'Arial');
        
    % Get prepared for the sound
    [soundData, freq] = audioread(['Preparing_sound.wav']);
    pahandle = PsychPortAudio('Open', [], [], 0, freq, [], [], 0.015);
    PsychPortAudio('FillBuffer', pahandle, soundData');
    PsychPortAudio('Start', pahandle, 0, 0); 

    audio_message = [];
    save([write_folder filesep 'raise_hand_gum_start_' subject_id '.mat'], 'audio_message');
    DrawFormattedText(windowHandle, 'Please raise your hand', 'center', 'center', textColor, wrapat_length, [], [], 3);
    Screen('Flip', windowHandle);
    check = 1;
    while check
        [key_is_down, ~, key_code] = KbCheck; % check whether a key is pressed and which one 
        if key_is_down && any(key_code(g_key))
            check = 0;
        end
    end    
    
    %% Get prepared
    gumInstrStart = clock();
    save([write_folder filesep 'SNS_BEH_gumInstrStart_S', subject_id, '_', session, '.mat'], 'gumInstrStart');
    k = 5;
    for i = 1:5
        Screen('TextSize', windowHandle, textSize);
        Screen('TextFont', windowHandle, 'Arial');
        DrawFormattedText(windowHandle, ['You will hear the instructions in ' num2str(k) ' seconds'], 'center', screenHeight/2 - 50, textColor, wrapat_length, [], [], 3);
        Screen('Flip', windowHandle);
        WaitSecs(1);
        k = k - 1;
    end
    Screen('TextSize', windowHandle, textSize);
    Screen('TextFont', windowHandle, 'Arial');
    DrawFormattedText(windowHandle, ['You will hear the instructions in ' num2str(0) ' seconds'], 'center', screenHeight/2 - 50, textColor, wrapat_length, [], [], 3);
    Screen('Flip', windowHandle);

    DrawFormattedText(windowHandle, 'Please follow the instruction to chew the gum every 3 seconds. \n\nIf the taste becomes too strong, you can place the gum in the cheek. \n\nTry not to swallow excessively', 'center', 'center', textColor, wrapat_length, [], [], 3);
    Screen('Flip', windowHandle);

    %% Play audio file
    % Arguments
    temp = table2array(readtable('Gum_instructions.xlsx'));
    timing_temp = temp(:,1); 
    timing = [];
    for x = 2:length(timing_temp)
        timing(x) = str2double(timing_temp{x}(2:3))*60 + str2double(timing_temp{x}(5:6)) - ...
                    (str2double(timing_temp{x-1}(2:3))*60 + str2double(timing_temp{x-1}(5:6)));
    end
    phrases = temp(:,2);

    for i = 1:length(phrases)
        WaitSecs(timing(i));
        start = tic();
        repetitions = 1;
        [soundData, freq] = audioread([phrases{i} '.wav']);
        pahandle = PsychPortAudio('Open', [], [], 0, freq, [], [], 0.015);
        PsychPortAudio('FillBuffer', pahandle, soundData');
        PsychPortAudio('Start', pahandle, repetitions, 0); 
    %     PsychPortAudio('Close', pahandle);
        stop = toc(start);
        if i ~= length(phrases)
            timing(i+1) = timing(i+1) - stop;
        end
    end
    
    gumInstrEnd = clock();
    save([write_folder filesep 'SNS_BEH_gumInstrEnd_S', subject_id, '_', session, '.mat'], 'gumInstrEnd');

    audio_message = [];
    save([write_folder filesep 'raise_hand_gum_end_' subject_id '.mat'], 'audio_message');
    DrawFormattedText(windowHandle, 'Please raise your hand', 'center', 'center', textColor, wrapat_length, [], [], 3);
    Screen('Flip', windowHandle);
    check = 1;
    while check
        [key_is_down, ~, key_code] = KbCheck; % check whether a key is pressed and which one 
        if key_is_down && any(key_code(c_key))
            check = 0;
        end
    end    
    
end