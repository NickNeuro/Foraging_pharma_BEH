function [responses, timing, windowHandle, et] = BEH_FR_task(subject_id, session, folders, rewardByTrial, envType, windowHandle, previousResponses, eyeTracker, et)
% Written by Nick Sidorenko, PhD student at Philippe Tobler group, Zurich Center for Neuroeconomics

% This function allows to do the main task
%%%% Inputs %%%%
% 'subject_id' = subject number (string). Ex.: '00001' or '00059'
% 'session' = session number (string). Ex. : '1'
% 'folders' = a structure containing paths to the subject folder, folder with example images, images
% for the instructions and the folder where the outcome should of the function should be written.
% 'trialOrder' = a cell array containing the names of the lottery images to be presented in the task
% 'nTrials' = number of trials (integer). Ex. : 20. Please be aware the nTrials should be smaller than or
% equal to the length of the provided dataset 'trialOrder'.
% 'windowHandle' : window pointer. Ex. : 10. This argument should be given only if the PTB screen has 
% already been open by another function. If that's not the case, do not specify 'windowHandle' as
% argument when calling the current function.

%%%% Output %%%%
% 'responses' = structure containing the responses of the subject
% 'timing' = structure containing the timing of the subject
% 'windowHandle' : window pointer (may be used afterwards to execute another function on the same
% screen)

% Check variables
if  exist('subject_id', 'var') && exist('session', 'var') && exist('folders', 'var') && exist('rewardByTrial', 'var') && exist('envType', 'var')
    if ischar(subject_id) && ischar(session) && isstruct(folders) && isnumeric(rewardByTrial) && ischar(envType)
        % Output file
        responses_file_name = [folders.write_folder filesep 'SNS_BEH_FR_task_' envType '_S', subject_id, '_', session, '.mat'];

        % Check to prevent overwriting previous data
        file_existence = exist([responses_file_name '.mat'], 'file');
        if file_existence
            writeover = input('Filename already exists, do you want to overwrite? 1 = yes, 0 = no ');
        else
            writeover = 2; % no messages necessary
        end

        switch writeover
            case 0
                subject_id = input('Enter proper subject ID as text string: ');
                responses_file_name = [folders.write_folder filesep 'SNS_BEH_FR_task_' envType '_S', subject_id, '_', session, '.mat'];
            case 1
                disp('responses file will be overwritten')
        end
        clear file_existence writeover
        
        % EyeTracker file
        if eyeTracker
            et_file_name = ['FR', subject_id(3:end), envType(1), '.edf'];
        end
    else
        error('Your arguments are not valid');
    end
else
    error('You did not provide enough arguments');
end

%%%% PREPARATIONS %%%%
%% INITIALISE AND CALIBRATE EYE TRACKER (ESSENTIAL)
% if eyeTracker
%     try
%         et = EyeTracker();
%         et.init(0, screenRect, false, []);
%         et.calibrate();
% 
%     catch e
%         disp_e_message(e);
%         return;
%     end
% end

%% TIMING VARIABLES
presenceInEnv = 5*60;
timeToPassInPatch = 120;
timeRateElapsing = 0:0.05:timeToPassInPatch;
timeSlots = 1;
timeToTravel = 6;
timeRateWaiting = 0:timeToTravel;

%% KEY BOARD
KbName('UnifyKeyNames');
space = KbName('space'); 

%% OUTPUT VARIABLES
responses = struct; % responses variable 
timing = struct; % timing variable
responses.collectedReward = []; 
responses.numberOfTrials = 0;
timing.trial_start_time = []; 
timing.decision_time = []; 
timing.reaction_time = []; 
timing.timeInEnv = 0;

%% IMAGES
images_folder = folders.images_folder;
% Transforme the Lottery images into matrices
imageMatrix = cell(length(0:timeSlots:timeToTravel), 1);
counter = 1;
for currImage = 0:timeSlots:timeToTravel
    imageMatrix{counter, 1} = double(imread([images_folder filesep num2str(currImage) '.bmp'])); 
    counter = counter + 1;
end

%% SCREEN
% Recognize the screen
if ~exist('windowHandle', 'var')
    [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [255 255 255]/2); % full screen
%     [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5], [0 0 1280 1024]); % debugging mode
end
if exist('windowHandle', 'var') && isempty(windowHandle)
    [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [255 255 255]/2); % full screen
%     [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [178.5 178.5 178.5], [0 0 500 500]); % debugging mode
end

%HideCursor;

% Determine dimensions of the opened screen
[screenWidth, screenHeight] = Screen('WindowSize', windowHandle);
centerX = floor(0.5 * screenWidth);
centerY = floor(0.5 * screenHeight);
crossSize = screenHeight/216;

% Colors and text
colors = struct;
colors.textColor = [255 255 255]; % off white
colors.bucketColor = [255 255 255]/2;
colors.milkColor = [255 255 255];
colors.frameRichEnvColor = [255 255 153];
colors.framePoorEnvColor = [50 100 10];
textSize.task = round(screenHeight/36); % ~30 when full screen mode
textSize.time = round(screenHeight/18);
Screen('TextFont', windowHandle,'Arial');

%% BUCKET and MILK
bucket = struct;
bucket.basement = [centerX - screenWidth/10, centerY - screenHeight/3, centerX + screenWidth/10, centerY + screenHeight/3];
bucket.width = bucket.basement(3) - bucket.basement(1);
bucket.height = bucket.basement(4) - bucket.basement(2);
bucket.top = [bucket.basement(1) - bucket.width/10, ...
              bucket.basement(2) - bucket.height/100, ...
              bucket.basement(3) + bucket.width/10, ...
              bucket.basement(2)];
scaleFactorBucket = (bucket.height - 2*bucket.width/20)/1000;

%% TIME
% Elapsing time
time.Pos = [centerX - screenWidth/10, centerY - screenWidth/10, centerX + screenWidth/10, centerY + screenWidth/10];
Screen('TextSize', windowHandle, textSize.task); 
time.textBounds = Screen('TextBounds', windowHandle, 'Time to reach the next field:');
time.textPos = round(time.Pos(2) - time.textBounds(4));

%% REWARD
reward = struct;
reward.bucket = [centerX - screenWidth/3, ...
                 time.Pos(4), ...
                 centerX + screenWidth/3, ...
                 time.Pos(4) + screenHeight/10];
reward.bucketWidth = reward.bucket(3) - reward.bucket(1);
reward.bucketHeight = reward.bucket(4) - reward.bucket(2);
scaleFactorReward = (reward.bucketWidth - 2*reward.bucketWidth/50)/sum(rewardByTrial(end,1:end/2));
reward.milk = [reward.bucket(1) + reward.bucketWidth/50, ...
               reward.bucket(2) + reward.bucketWidth/50, ...
               reward.bucket(1) + reward.bucketWidth/50, ...
               reward.bucket(4) - reward.bucketWidth/50];

%% TEXTURES
imageTexture = cell(length(0:timeSlots:timeToTravel), 1);
for currImage = 1:length(0:timeSlots:timeToTravel)
    imageTexture{currImage, 1} = Screen('MakeTexture', windowHandle, imageMatrix{currImage, 1});
end

%% TASK %%
if eyeTracker
    et.openFile(et_file_name); %%% needs a string %%%     
    et.startRecording();
    et.setRecordingMessage('EXPERIMENT START'); % displays a message on the eyetracker recording screen %%% NOTE: not saved in the edfFile%%%
    et.setAnalyseMessage('EXPERIMENT START'); % saved in the edfFile%%%
end

% Fixation cross at the beginning of the task
if previousResponses == 0
    Screen('DrawLine', windowHandle, colors.textColor, centerX - crossSize*3, centerY, centerX + crossSize*3, centerY, crossSize);
    Screen('DrawLine', windowHandle, colors.textColor, centerX, centerY - crossSize*3, centerX, centerY + crossSize*3, crossSize);
    Screen('Flip', windowHandle);
end
WaitSecs(3.5);

% try
timeSpentInEnv = tic();
currTrial = 0;
while toc(timeSpentInEnv) < presenceInEnv
    timing.trial_start_time = [timing.trial_start_time; GetSecs];
    currTrial = currTrial + 1;
    milkHeight = zeros(length(rewardByTrial(:,currTrial)), 4);
    for r = 1:length(rewardByTrial(:,currTrial))
        milkHeight(r,:) = [bucket.basement(1) + bucket.width/10, ...,
                           bucket.basement(4) - bucket.width/20 - rewardByTrial(r,currTrial)*scaleFactorBucket, ...
                           bucket.basement(3) - bucket.width/10, ...
                           bucket.basement(4) - bucket.width/20]; 
    end
    spaceBarDown = 1;
    spaceBarHold = 1;
    if eyeTracker
        et.setAnalyseMessage('Press_space_bar'); % sets a message in the edf file, (will be saved in the edf-structure) %%%
        et.setRecordingMessage('Press_space_bar'); % displays a message on the eyetracker recording screen %%% NOTE: not saved in the edfFile%%%
    end

    while spaceBarDown
        Screen('TextSize', windowHandle, textSize.task);
        DrawFormattedText(windowHandle, 'Please press and hold the space bar', 'center', 'center', colors.textColor);
        Screen('Flip', windowHandle);
        [key_is_down, ~, key_code] = KbCheck; % check whether a key is pressed and which one 
        if key_is_down && any(key_code(space))
            if eyeTracker
                et.setAnalyseMessage('Bucket_filling'); % sets a message in the edf file, (will be saved in the edf-structure) %%%
                et.setRecordingMessage('Bucket_filling'); % displays a message on the eyetracker recording screen %%% NOTE: not saved in the edfFile%%%
            end
            spaceBarDown = 0;
            elapsedTime = tic();
            while toc(elapsedTime) <= timeToPassInPatch && spaceBarHold
                [~, closestIdx] = min(abs(timeRateElapsing - toc(elapsedTime)));
                FR_bucket_with_milk(windowHandle, bucket, milkHeight(closestIdx,:), colors, envType);
                Screen('Flip', windowHandle);
                % Check of the key board    
                [key_is_down, ~, key_code] = KbCheck; % check whether a key is pressed and which one 
                if ~key_is_down || ~any(key_code(space))
                    timing.decision_time = [timing.decision_time; GetSecs];
                    timing.reaction_time = [timing.reaction_time; timing.decision_time(end) - timing.trial_start_time(end)];
                    spaceBarHold = 0;
                end
            end
            FR_bucket_with_milk(windowHandle, bucket, milkHeight(closestIdx,:), colors, envType);
            Screen('Flip', windowHandle);
            responses.collectedReward = [responses.collectedReward; rewardByTrial(closestIdx, currTrial)];
            clear milkHeight closestIdx
        end
    end        
    save(responses_file_name, 'responses', 'timing');
    
    % Travelling between patches
    if currTrial == 1
        reward.milk(3) = reward.milk(3) + responses.collectedReward(currTrial)*scaleFactorReward + previousResponses*scaleFactorReward;
    else
        reward.milk(3) = reward.milk(3) + responses.collectedReward(currTrial)*scaleFactorReward;
    end
    responses.collectedTotalReward = cumsum(responses.collectedReward);
    timeCircle = 0;
    counter = 6;
    if eyeTracker
        et.setAnalyseMessage('Travel_time'); % sets a message in the edf file, (will be saved in the edf-structure) %%%
        et.setRecordingMessage('Travel_time'); % displays a message on the eyetracker recording screen %%% NOTE: not saved in the edfFile%%%
    end

    tickingTimeToWait = tic(); 
    for i = 1:timeToTravel
        [~, closestIdx] = min(abs(timeRateWaiting - toc(tickingTimeToWait)));
        if toc(tickingTimeToWait) < timeCircle + timeSlots 
            FR_collected_reward(windowHandle, reward, colors, time, imageTexture, counter, textSize);
            Screen('Flip', windowHandle);
         else
            timeCircle = timeCircle + timeSlots;
            counter = counter - 1;
            FR_collected_reward(windowHandle, reward, colors, time, imageTexture, counter, textSize);
            Screen('Flip', windowHandle);
        end
        WaitSecs(1);
    end
    responses.numberOfTrials = currTrial;
    save(responses_file_name, 'responses', 'timing');

end
timing.timeInEnv = toc(timeSpentInEnv);
save(responses_file_name, 'responses', 'timing');

if eyeTracker
    et.setAnalyseMessage('Environment_end'); % sets a message in the edf file, (will be saved in the edf-structure) %%%
    et.setRecordingMessage('Environment_end'); % displays a message on the eyetracker recording screen %%% NOTE: not saved in the edfFile%%%
end

% Fixation cross between environments and at the end of the task
Screen('DrawLine', windowHandle, colors.textColor, centerX - crossSize*3, centerY, centerX + crossSize*3, centerY, crossSize);
Screen('DrawLine', windowHandle, colors.textColor, centerX, centerY - crossSize*3, centerX, centerY + crossSize*3, crossSize);
Screen('Flip', windowHandle);
WaitSecs(3.5);

if previousResponses == 0
    DrawFormattedText(windowHandle, 'Now you will go to the other farm', 'center', 'center', colors.textColor);
    Screen('Flip', windowHandle);
    et.setRecordingMessage('Between_environments'); % displays a message on the eyetracker recording screen %%% NOTE: not saved in the edfFile%%%
    et.setAnalyseMessage('Between_environments'); % saved in the edfFile%%%
    WaitSecs(timeToTravel);
end

% Payment     
endowment = 150;
finalAmount = responses.collectedTotalReward(end);
responses.endowment = endowment;
responses.finalAmount = finalAmount;
responses.finalTotalAmount = endowment + finalAmount;

% catch
%     Screen('CloseAll');
%     error('Something went wrong. Please check your code for eventual errors');
% end
% 
save(responses_file_name, 'responses', 'timing');

if eyeTracker 
    cd(folders.write_folder);
    et.stopRecording();
    et.closeFile();
    et.receiveFile();
    cd(folders.scripts_folder);
end

% if eyeTracker
%     et.shutdown()
%     clear et;
% end

%% CLOSE DISPLAY
%Screen('CloseAll');

end % end of function
