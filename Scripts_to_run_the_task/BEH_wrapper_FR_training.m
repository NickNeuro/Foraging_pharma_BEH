function windowHandle = BEH_wrapper_FR_training(subject_id, session, general_folder, windowHandle, eyeTracker, doTraining)
% Written by Nick Sidorenko, PhD student at Philippe Tobler group, Zurich Center for Neuroeconomics

    %% ARGUMENTS
    folders = struct;
    folders.subject_folder = dir(fullfile(general_folder, '**', 'BEH', '**', ['subject_', subject_id])); folders.subject_folder = folders.subject_folder.folder;
    folders.instructions_folder =  dir(fullfile(general_folder, '**', 'FR/Instructions')); folders.instructions_folder = folders.instructions_folder.folder;
    folders.images_folder = dir(fullfile(general_folder, '**', 'FR/time')); folders.images_folder = folders.images_folder.folder;
%     folders.write_folder = dir(fullfile(general_folder, '**', 'Outcome')); folders.write_folder = folders.write_folder.folder;
    folders.write_folder = '';
    rewardByTrial = load([folders.instructions_folder filesep 'trainingReward.mat']);
    rewardByTrial = rewardByTrial.trainingReward;
    trainingNotReminder = true; 
    
    if isempty(windowHandle)
        windowHandle = BEH_FR_instructions(folders, subject_id, [], doTraining);
    else
        BEH_FR_instructions(folders, subject_id, windowHandle, doTraining);
    end
    if doTraining
        [responses, timing, ~] = BEH_FR_training(subject_id, session, folders, rewardByTrial, 'rich', trainingNotReminder, windowHandle, eyeTracker); 
        save([folders.write_folder filesep 'SNS_BEH_FR_training_S', subject_id, '_', session, '.mat'], 'responses', 'timing');
    end
end