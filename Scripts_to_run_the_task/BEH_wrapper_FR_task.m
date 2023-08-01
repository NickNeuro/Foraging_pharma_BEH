function [windowHandle, et] = BEH_wrapper_FR_task(subject_id, session, general_folder, windowHandle, eyeTracker, et)
% Written by Nick Sidorenko, PhD student at Philippe Tobler group, Zurich Center for Neuroeconomics

    %% ARGUMENTS
    folders = struct;
    folders.general_folder = general_folder;
    folders.scripts_folder = dir(fullfile(general_folder, '**', 'Scripts')); folders.scripts_folder = folders.scripts_folder.folder;
    folders.subject_folder = dir(fullfile(general_folder, '**', 'BEH', '**', ['subject_', subject_id])); folders.subject_folder = folders.subject_folder.folder;
    folders.images_folder = dir(fullfile(general_folder, '**', 'FR/Time')); folders.images_folder = folders.images_folder.folder;
    folders.instructions_folder =  dir(fullfile(general_folder, '**', 'FR/Instructions')); folders.instructions_folder = folders.instructions_folder.folder;
%     folders.write_folder = dir(fullfile(general_folder, '**', 'Outcome')); folders.write_folder = folders.write_folder.folder;
    folders.write_folder = '';
    trainingRewardByTrial = load([folders.instructions_folder filesep 'trainingReward.mat']);
    trainingRewardByTrial = trainingRewardByTrial.trainingReward;
    rewardByTrial = load([folders.subject_folder filesep 'SNS_BEH_FR_set_S', subject_id, '_', session, '.mat']);
    trainingNotReminder = false;

    if isempty(windowHandle)
        windowHandle = BEH_FR_reminder(windowHandle);
    else
        BEH_FR_reminder(windowHandle);
    end
    eyeTracker = 0;
    [responses, timing, ~] = BEH_FR_training(subject_id, session, folders, trainingRewardByTrial, 'rich', trainingNotReminder, windowHandle, eyeTracker); 
    save([folders.write_folder filesep 'SNS_BEH_FR_training_2_S', subject_id, '_', session, '.mat'], 'responses', 'timing');
    BEH_TASK_STARTER(windowHandle);
    eyeTracker = 1;
    if strcmp(rewardByTrial.envType{1}, 'rich')
        [responses, timing, ~, et] = BEH_FR_task(subject_id, session, folders, rewardByTrial.richReward, 'rich', windowHandle, 0, eyeTracker, et);
        save([folders.write_folder filesep 'SNS_BEH_FR_task_rich_S', subject_id, '_', session, '.mat'], 'responses', 'timing');
        [responses, timing, ~, et] = BEH_FR_task(subject_id, session, folders, rewardByTrial.poorReward, 'poor', windowHandle, responses.finalAmount, eyeTracker, et);
        save([folders.write_folder filesep 'SNS_BEH_FR_task_poor_S', subject_id, '_', session, '.mat'], 'responses', 'timing');
    else
        [responses, timing, ~, et] = BEH_FR_task(subject_id, session, folders, rewardByTrial.poorReward, 'poor', windowHandle, 0, eyeTracker, et);
        save([folders.write_folder filesep 'SNS_BEH_FR_task_poor_S', subject_id, '_', session, '.mat'], 'responses', 'timing');
        [responses, timing, ~, et] = BEH_FR_task(subject_id, session, folders, rewardByTrial.richReward, 'rich', windowHandle, responses.finalAmount, eyeTracker, et);
        save([folders.write_folder filesep 'SNS_BEH_FR_task_rich_S', subject_id, '_', session, '.mat'], 'responses', 'timing');
    end
end