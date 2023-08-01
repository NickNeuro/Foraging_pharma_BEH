function BEH_wrapperTrainingAndTasks(s, session, drugTaken)
    
    % Written by Nick Sidorenko, PhD student at Philippe Tobler group, Zurich Center for Neuroeconomics
    % This is the main wrapper script that runs the entire experiment for a single participant 
    % s = subject ID, e.g. 1
    % session = session. In the present study, the session was always equal to '1', as all participants performed the four main tasks only once
    % drugTaken = time when the pill was take, e.g. '10:15'
        
    oldValue = Screen('Preference', 'SyncTestSettings', 0.0006);
    general_folder = '';
    if s < 10
        subject_id = ['0000' num2str(s)];
    elseif s > 9 && s < 100
        subject_id = ['000' num2str(s)];
    elseif s > 99
        subject_id = ['00' num2str(s)];
    end
    sb_folder = dir(fullfile(general_folder, '**', 'Subjects\BEH')); sb_folder = sb_folder.folder;
    write_folder = '';
    scripts_folder = dir(fullfile(general_folder, '**', 'Scripts')); scripts_folder = scripts_folder.folder;
    cd(scripts_folder);
    taskOrder = load([sb_folder filesep 'taskOrderAssignment.mat']); taskOrder = taskOrder.taskOrder;
    
    
    % INITIAL SETUP
    windowHandle = [];
    eyeTracker = 0;
    
    %   TRAINING SESSION
     [windowHandle, ~] = BEH_WELCOME(windowHandle, eyeTracker);
    for o = 1:4
        BEH_INTER_TASKS(o, 0, write_folder, subject_id, windowHandle);
        switch taskOrder(s,o)
            case 1
%                 BEH_wrapper_RISKGARP_training(subject_id, session, general_folder, windowHandle, eyeTracker, 1);
            case 2
%                 BEH_wrapper_WTP_training(subject_id, session, general_folder, windowHandle, eyeTracker, 1);
            case 3
                BEH_wrapper_FR_training(subject_id, session, general_folder, windowHandle, eyeTracker, 1);
            case 4
%                 BEH_wrapper_FAB_training(subject_id, session, general_folder, windowHandle, eyeTracker, 1);
        end
    end
    
    % TASKS
    
%     Check timing for the gum drug
    save([write_folder filesep 'SNS_BEH_drugTaken_S', subject_id, '_', session, '.mat'], 'drugTaken');
    timeNow = clock();
    drugTimeElapsed = timeNow(4)*60 + timeNow(5) - (str2double(drugTaken(1:2))*60 + str2double(drugTaken(4:5)));
    
    timeLeft = 1;
    while drugTimeElapsed < 60
        if drugTimeElapsed < 53 % if participants still have more than 7 minutes, they will have a chance to review as many task instructions as they want   
            [~, timeLeft] = BEH_REPEAT_TRAINING(s, taskOrder, timeLeft, subject_id, session, general_folder, windowHandle, eyeTracker);
        else
            timeLeft = 0; % if participants have less than 7 minutes, this is the last chance to review one task instructions
            BEH_REPEAT_TRAINING(s, taskOrder, timeLeft, subject_id, session, general_folder, windowHandle, eyeTracker);
        end
        timeNow = clock();
        drugTimeElapsed = timeNow(4)*60 + timeNow(5) - (str2double(drugTaken(1:2))*60 + str2double(drugTaken(4:5)));
    end
    BEH_GUM_INSTRUCTIONS(windowHandle, write_folder, subject_id, session); % audio instructions about how to chew the gum 

     eyeTracker = 1;
       [~, et] = BEH_INTER_SESSIONS(windowHandle, eyeTracker);
    for o = 1:4
        BEH_INTER_TASKS(o, 1, write_folder, subject_id, windowHandle);
         et.calibrate();
        switch taskOrder(s,o)
            case 1
%                 [~, et] = BEH_wrapper_RISKGARP_task(subject_id, session, general_folder, windowHandle, eyeTracker, et);
            case 2
%                 [~, et] = BEH_wrapper_WTP_task(subject_id, session, general_folder, windowHandle, eyeTracker, et);
            case 3
                [~, et] = BEH_wrapper_FR_task(subject_id, session, general_folder, windowHandle, eyeTracker, et);
            case 4
%                 [~, et] = BEH_wrapper_FAB_task(subject_id, session, general_folder, windowHandle, eyeTracker, et);
        end
    end
    
    BEH_SUPP_TASKS(windowHandle, 1, subject_id, write_folder, eyeTracker, 'main');
%     BEH_wrapper_EST_task(subject_id, session, general_folder, windowHandle, eyeTracker, et);    
    windowHandle = BEH_SUPP_TASKS([], 2, subject_id, write_folder, eyeTracker, 'main');
    et = [];
    BEH_wrapper_TIME_task(subject_id, session, general_folder, windowHandle, eyeTracker, et);    

    % PAYMENT
    rng('shuffle');
    payed_task = randperm(4,1);
    switch payed_task
        case 1
%             BEH_wrapper_RISKGARP_payment(subject_id, session, general_folder, windowHandle);
%             payed_task = 'RISKGARP';
        case 2
%             BEH_wrapper_WTP_payment(subject_id, session, general_folder, windowHandle, randsample([1 2 3],1));
%             payed_task = 'WTP';
        case 3
            BEH_wrapper_FR_payment(subject_id, session, general_folder, windowHandle);
            payed_task = 'FR';
        case 4
%             BEH_wrapper_FAB_payment(subject_id, session, general_folder, windowHandle);
%             payed_task = 'FAB';
    end
    save([write_folder filesep 'SNS_BEH_payment_S', subject_id, '_', session, '.mat'], 'payed_task');

    
end