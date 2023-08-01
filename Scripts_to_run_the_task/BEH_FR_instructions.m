function windowHandle = BEH_FR_instructions(folders, subject_id, windowHandle, doTraining)
% Written by Nick Sidorenko, PhD student at Philippe Tobler group, Zurich Center for Neuroeconomics

%%%% This function displays both instructions and control questions
% If one of the control questions is answered wrong, the participant will be asked to 
% raise his/her hand. The study investigator will come and answer the eventual questions.
% To continue the task afterwards, just press 'm' on the keyboard
%% KEYBOARD
KbName('UnifyKeyNames');
to_right = KbName('RightArrow');
to_left = KbName('LeftArrow'); 
answer_a = KbName('a');
answer_b = KbName('b');
answer_c = KbName('c');
answer_d = KbName('d');
move_on = KbName('m'); % m for move on (nothing to do with the Alfred Hitchcock's movie). 
                       % moreover, that's unlikely for the participant to press 'm' by chance and
                       % thus continue the task without calling the study investigator
wrong_question = KbName('q');

%% SCREEN
% Recognize the screen
if ~exist('windowHandle', 'var')
    %[windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [255 255 255]/2); % full screen
    [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5], [0 0 1280 1024]); % debugging mode
end
if exist('windowHandle', 'var') && isempty(windowHandle)
    %[windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [255 255 255]/2); % full screen
    [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5], [0 0 1280 1024]); % debugging mode
end
%HideCursor;

% Determine dimensions of the opened screen
[screenWidth, screenHeight] = Screen('WindowSize', windowHandle);
centerX = floor(0.5 * screenWidth);
centerY = floor(0.5 * screenHeight);

% Colors and text
colors = struct;
colors.textColor = [255 255 255]; % off white
colors.scaleColor = [255 255 255];
colors.arrowColor = [255 255 255];
colors.choiceColor = [255 255 255];
textSize = round(screenHeight/36); % 30 when full screen mode
wrapat_length = 80;
Screen('TextFont', windowHandle,'Arial');
Screen('TextSize', windowHandle, textSize);
lineWidth = screenHeight/216;

%% GO THROUGH INSTRUCTION PAGES
page = 1;
while page < 6
    go_through_instructions(page);
    WaitSecs(0.2);
    check = 1;
    while check
        [key_is_down, ~, key_code] = KbCheck; % check whether a key is pressed and which one 
        if key_is_down && any(key_code(to_right))
            check = 0;
            page = page + 1;
        end
        if key_is_down && any(key_code(to_left)) && page ~= 1
            check = 0;
            page = page - 1;
        elseif key_is_down && any(key_code(to_left)) && page == 1
            check = 1;
        end
    end
end

    function go_through_instructions(page)
        switch page
            case 1
                %% INSTRUCTIONS - PART I
                instructions{1} = ['In this task, you are going to be collecting milk from “virtual cows”. You will collect milk just by being in a field (with the cows). ' ...
                                   'Here you can see the field, with a bucket/milking pail. The white bar is how much milk you have collected so far in the field.'];

                instructions{2} = ['The LONGER you spend in the field, the HIGHER the bar will go. ' ...
                                   'However, the longer you spend in the field, the SLOWER the bar will go up – this means the rate of milk collection decreases the longer you stay in the field. ' ...
                                   'Therefore, at some point you will want to leave this field to travel to a new one. ' ... 
                                   'When you arrive at the next field, the milk rate goes back to the HIGHEST level (for that field). ' ...
                                   'However, it takes time to travel between fields (6 seconds). During this time, you will see how much milk you have collected so far (a bar below the clock) but will not be able to collect any milk at all. ' ...
                                   'Thus, it is also important not to leave the field too early. \n\n' ...
                                   'To continue, please press the RIGHT ARROW on the KEYBOARD.'];

                imageMatrix = double(imread([folders.instructions_folder filesep 'Example_1.bmp' ])); 
                [imageHeight, imageWidth, ~] = size(imageMatrix); 
                imageTexture = Screen('MakeTexture', windowHandle, imageMatrix);

                [~, ~, textBounds, ~] = DrawFormattedText(windowHandle, instructions{1}, centerX/2, screenHeight/10, colors.textColor, wrapat_length, [], [], 1.6);
                imageRect = [centerX - imageWidth/4, textBounds(4), centerX + imageWidth/4, textBounds(4) + imageHeight*0.5]; % Lottery image
                Screen('DrawTexture', windowHandle, imageTexture, [], imageRect);
                DrawFormattedText(windowHandle, instructions{2}, centerX/2, round(imageRect(4) + 40), colors.textColor, wrapat_length, [], [], 1.6);
                Screen('Flip', windowHandle);
                Screen('Close', imageTexture);
            case 2
                %% INSTRUCTIONS - PART II
                instructions{1} = ['Note that you have an infinite number of fields available to you – but a limited amount of time. ' ...
                                   'Your goal is to decide the BEST TIME TO LEAVE each field, so that you get as much milk as you can across the whole experiment. ' ...
                                   'If you leave each field too early, then you will spend a lot of time walking between fields, not getting any milk. ' ...
                                   'But if you leave each field too late, you will spend too much time collecting milk at a low rate, and again you won’t earn as much over the whole experiment. \n\n', ...
                                   'To continue, please press the RIGHT ARROW on the KEYBOARD.'];

                DrawFormattedText(windowHandle, instructions{1}, centerX/2, 'center', colors.textColor, wrapat_length, [], [], 1.6);
                Screen('Flip', windowHandle);
            case 3
                %% INSTRUCTIONS - PART III
                instructions{1} = ['There are 3 types of fields: \n' ...
                                   '1) "POOR" fields do not have many cows. This means the milk INCREASES SLOWER and you get less of it compared to the other fields \n' ... 
                                   '2) "MEDIUM" fields have an average number of cows \n' ...
                                   '3) "GOOD" fields have a lot of cows. In these fields the milk INCREASES QUICKLY, so you can earn more in a set amount of time. \n' ...
                                   'You will get a chance to see these different field types in a practice run in a moment: \n\n'];
                instructions{2} = 'To continue, please press the RIGHT ARROW on the KEYBOARD.';

                imageMatrix = double(imread([folders.instructions_folder filesep 'Example_2.bmp' ])); 
                [imageHeight, imageWidth, ~] = size(imageMatrix); 
                imageTexture = Screen('MakeTexture', windowHandle, imageMatrix);

                [~, ~, textBounds, ~] = DrawFormattedText(windowHandle, instructions{1}, centerX/2, screenHeight/10, colors.textColor, wrapat_length, [], [], 1.6);
                imageRect = [centerX - imageWidth/6, textBounds(4), centerX + imageWidth/6, textBounds(4) + imageHeight*0.33]; % Lottery image
                Screen('DrawTexture', windowHandle, imageTexture, [], imageRect);
                DrawFormattedText(windowHandle, instructions{2}, centerX/2, round(imageRect(4) + 40), colors.textColor, wrapat_length, [], [], 1.6);
                Screen('Flip', windowHandle);
                Screen('Close', imageTexture);
            case 4
                %% INSTRUCTIONS - PART IV
                instructions{1} = 'The fields will be arranged in 2 different farms:';

                instructions{2} = ['You will spend about 5 minutes on each farm. \n', ...
                                   'In the GOLD farm, there are lots of “good” fields, and not many “poor” fields. ', ...
                                   'In the GREEN farm, there are lots of “poor” fields, and not many “good” fields. ', ...
                                   'This means that when you are in a GOLD farm and choose to leave a field, the chance that the next field is a good one is 50%, an average one 30% and a poor one 20%. ', ...
                                   'You can still get poor fields on gold farms but they are much less likely. \n', ...
                                   'On a GREEN farm, things are reversed. ', ...
                                   'When you choose to leave a field on a green farm, the chance that the next one is a poor one is 50%, average 30% and good only 20%. \n\n', ...
                                   'To continue, please press the RIGHT ARROW on the KEYBOARD.'];

                imageMatrix = double(imread([folders.instructions_folder filesep 'Example_3.bmp' ])); 
                [imageHeight, imageWidth, ~] = size(imageMatrix); 
                imageTexture = Screen('MakeTexture', windowHandle, imageMatrix);

                [~, ~, textBounds, ~] = DrawFormattedText(windowHandle, instructions{1}, centerX/2, screenHeight/10, colors.textColor, wrapat_length, [], [], 1.6);
                imageRect = [centerX - imageWidth/6, textBounds(4) + 40, centerX + imageWidth/6, textBounds(4) + 40 + imageHeight*0.33]; % Lottery image
                Screen('DrawTexture', windowHandle, imageTexture, [], imageRect);
                DrawFormattedText(windowHandle, instructions{2}, centerX/2, round(imageRect(4) + 60), colors.textColor, wrapat_length, [], [], 1.6);
                Screen('Flip', windowHandle);
                Screen('Close', imageTexture);
            case 5
                %% INSTRUCTIONS - PART V
                instructions{1} = ['You will PRESS and HOLD the SPACE BAR to enter in a field. When you want to leave the field and walk to the next field, just RELEASE the space bar. \n', ...
                                   'As mentioned, at the end of the experiment, ONE task will be randomly selected. \n', ...
                                   'If THIS task is selected, the total amount of milk collected in this task will be converted into Swiss Francs at a given rate. ', ...
                                   'Therefore, every decision determines your earnings and you should take every decision seriously! \n' ...
                                   'So, overall, you need to decide the best time to leave each field, so that you collect as much milk as possible across the whole experiment. ', ...
                                   'You need to take into account: \n', ...
                                   '   - How long it takes to walk between fields \n', ...
                                   '   - What the milk return is in the current field \n', ...
                                   '   - Whether you’re on a gold or green farm – i.e. what are the chances the next field will be good/average/poor \n\n', ...                                   
                                   'To continue, please press the RIGHT ARROW on the KEYBOARD'];

                DrawFormattedText(windowHandle, instructions{1}, centerX/2, 'center', colors.textColor, wrapat_length, [], [], 1.6);
                Screen('Flip', windowHandle);
        end
    end

%% INSTRUCTIONS - CONTROL QUESTIONS
%%%%% First question
questions = {};
instructions{1} = ['CONTROL QUESTION 1 \n\n' ...
                   'To collect milk, I have to: \n' ...
                   'a) Just press the SPACE BAR \n' ...
                   'b) Press the SPACE BAR and hold it until I decide to move to the next field. Only then release it \n' ...
                   'c) Press the SPACE BAR and hold it for exactly 2 minutes \n' ...
                   'd) Press the SPACE BAR, then release it straightforward and press once again when I decide to move to the next field \n\n' ...
                   'Please press the letter that corresponds to your answer on the keyboard'];

DrawFormattedText(windowHandle, instructions{1}, centerX/2, 'center', colors.textColor, wrapat_length, [], [], 1.6);
Screen('Flip', windowHandle);

raise_hand = false;
check = 1;
while check
    [key_is_down, ~, key_code] = KbCheck; % check whether a key is pressed and which one 
    if key_is_down && (any(key_code(answer_a)) || any(key_code(answer_b)) || any(key_code(answer_c)) || any(key_code(answer_d)))
        check = 0;
        if ~any(key_code(answer_b))
            raise_hand = true;
            questions{1} = instructions{1};
        end
    end
end
Screen('DrawLine', windowHandle, colors.scaleColor, centerX - lineWidth*3, centerY, centerX + lineWidth*3, centerY, lineWidth);     
Screen('DrawLine', windowHandle, colors.scaleColor, centerX, centerY - lineWidth*3, centerX, centerY + lineWidth*3, lineWidth); 
Screen('Flip', windowHandle);
WaitSecs(1);

%%%%% Second question
instructions{1} = ['CONTROL QUESTION 2 \n\n' ...
                   'The current field has a gold border. That means that when you leave it, you have: \n' ...
                   'a) 50% chance to arrive to a POOR FIELD with the HIGHEST rate of milk filling \n' ...
                   'b) 50% chance to arrive to a POOR FIELD with the SLOWEST rate of milk filling \n' ...
                   'c) 50% chance to arrive to a GOOD FIELD with the HIGHEST rate of milk filling \n' ...
                   'd) 100% chance to arrive to a GOOD FIELD with the HIGHEST rate of milk filling \n\n' ...
                   'Please press the letter that corresponds to your answer on the keyboard'];

DrawFormattedText(windowHandle, instructions{1}, centerX/2, 'center', colors.textColor, wrapat_length, [], [], 1.6);
Screen('Flip', windowHandle);

check = 1;
while check
    [key_is_down, ~, key_code] = KbCheck; % check whether a key is pressed and which one 
    if key_is_down && (any(key_code(answer_a)) || any(key_code(answer_b)) || any(key_code(answer_c)) || any(key_code(answer_d)))
        check = 0;
        if ~any(key_code(answer_c))
            raise_hand = true;
            questions{2} = instructions{1};
        end
    end
end
Screen('DrawLine', windowHandle, colors.scaleColor, centerX - lineWidth*3, centerY, centerX + lineWidth*3, centerY, lineWidth);     
Screen('DrawLine', windowHandle, colors.scaleColor, centerX, centerY - lineWidth*3, centerX, centerY + lineWidth*3, lineWidth); 
Screen('Flip', windowHandle);
WaitSecs(1);

%%%%% Third question
instructions{1} = ['CONTROL QUESTION 3 \n\n' ...
                   'The purpose of this task is: \n' ...
                   'a) Collect as much milk as possible from both farms \n' ...
                   'b) Collect all the milk from each field \n' ...
                   'c) Visit as many fields as possible \n' ...
                   'd) Stay in a field as long as possible \n\n' ...
                   'Please press the letter that corresponds to your answer on the keyboard'];

DrawFormattedText(windowHandle, instructions{1}, centerX/2, 'center', colors.textColor, wrapat_length, [], [], 1.6);
Screen('Flip', windowHandle);

check = 1;
while check
    [key_is_down, ~, key_code] = KbCheck; % check whether a key is pressed and which one 
    if key_is_down && (any(key_code(answer_a)) || any(key_code(answer_b)) || any(key_code(answer_c)) || any(key_code(answer_d)))
        check = 0;
        if ~any(key_code(answer_a))
            raise_hand = true;
            questions{3} = instructions{1};
        end
    end
end
Screen('DrawLine', windowHandle, colors.scaleColor, centerX - lineWidth*3, centerY, centerX + lineWidth*3, centerY, lineWidth);    
Screen('DrawLine', windowHandle, colors.scaleColor, centerX, centerY - lineWidth*3, centerX, centerY + lineWidth*3, lineWidth); 
Screen('Flip', windowHandle);
WaitSecs(1);

% If one of the answers is wrong
if raise_hand
    audio_message = [];
    save([folders.write_folder filesep 'raise_hand_questions_' subject_id '.mat'], 'audio_message');
    DrawFormattedText(windowHandle, 'Please raise your hand', 'center', 'center', colors.textColor, wrapat_length, [], [], 1.6);
    Screen('Flip', windowHandle);
    
    check = 1;
    while check
        [key_is_down, ~, key_code] = KbCheck; % check whether a key is pressed and which one 
        if key_is_down && any(key_code(move_on))
            check = 0;
        end
    end    
end

% Repeat questions with wrong answers
for q = 1:numel(questions)
    if ~isempty(questions{q})
        DrawFormattedText(windowHandle, questions{q}, centerX/2, 'center', colors.textColor, wrapat_length, [], [], 1.6);
        Screen('Flip', windowHandle);
        check = 1;
        while check
            [key_is_down, ~, key_code] = KbCheck; % check whether a key is pressed and which one 
            if key_is_down && any(key_code(wrong_question))
                check = 0;
            end
        end    
            Screen('DrawLine', windowHandle, colors.scaleColor, centerX - lineWidth*3, centerY, centerX + lineWidth*3, centerY, lineWidth);     Screen('DrawLine', windowHandle, colors.scaleColor, centerX, centerY - lineWidth*3, centerX, centerY + lineWidth*3, lineWidth); 
        Screen('DrawLine', windowHandle, colors.scaleColor, centerX, centerY - 15, centerX, centerY + 15, 5);
        Screen('Flip', windowHandle);
        WaitSecs(1);
    end
end



%% INSTRUCTIONS - PART VI
if doTraining 
    move_forward_instr = 'Please press the RIGHT ARROW on the KEYBOARD to START A TRAINING SESSION';
else
    move_forward_instr = 'Please press the RIGHT ARROW on the KEYBOARD';
end

DrawFormattedText(windowHandle, move_forward_instr, 'center', 'center', colors.textColor, wrapat_length, [], [], 1.6);
Screen('Flip', windowHandle);

WaitSecs(1);
check = 1;
while check
    [key_is_down, ~, key_code] = KbCheck; % check whether a key is pressed and which one 
    if key_is_down && any(key_code(to_right))
        check = 0;
    end
end
WaitSecs(0.2);

end