function [windowHandle, et] = BEH_wrapper_TIME_task(subject_id, session, general_folder, windowHandle, eyeTracker, et)
% Written by Nick Sidorenko, PhD student at Philippe Tobler group, Zurich Center for Neuroeconomics

    %% ARGUMENTS
    folders = struct;
    folders.subject_folder = dir(fullfile(general_folder, '**', 'BEH', '**', ['subject_', subject_id])); folders.subject_folder = folders.subject_folder.folder;
    folders.instructions_folder =  dir(fullfile(general_folder, '**', 'TIME/Instructions')); folders.instructions_folder = folders.instructions_folder.folder;
    folders.scripts_folder = dir(fullfile(general_folder, '**', 'Scripts')); folders.scripts_folder = folders.scripts_folder.folder;
%     folders.write_folder = dir(fullfile(general_folder, '**', 'Outcome')); folders.write_folder = folders.write_folder.folder;
    folders.write_folder = '';    
    subj_dataset = load([folders.subject_folder filesep 'SNS_BEH_TIME_set_S', subject_id, '_', session, '.mat']);
    
    if session == '1'
        sessID = '0';
    else
        sessID = '1';
    end
 
    screenRect = [];
    et = [];
    if eyeTracker
        et = EyeTracker();
        et.init(max(Screen('Screens')), screenRect);
        et.calibrate();
    end
    
    if isempty(windowHandle)
        windowHandle = BEH_TIME_instructions(folders, []);
    else
        BEH_TIME_instructions(folders, windowHandle);
    end
    
    responses = [];
    timing = [];
    for t = 1:12
        [~, ~, ~, et] = BEH_TIME_task(subject_id, session, folders, subj_dataset.fillingRate(:,t), [], 'visible', windowHandle, eyeTracker, et, num2str(t), ['TP', sessID, subject_id(3:end), '.edf']);
        [responses_temp, timing_temp, ~, et] = BEH_TIME_task(subject_id, session, folders, subj_dataset.fillingRate(:,t), subj_dataset.timing_to_leave(t), 'blind', windowHandle, eyeTracker, et, num2str(t), ['TP', sessID, subject_id(3:end), '.edf']);
        responses = [responses; responses_temp];
        timing = [timing; timing_temp];
        save([folders.write_folder filesep 'SNS_BEH_TIME_task_blind_S', subject_id, '_', session, '.mat'], 'responses', 'timing');
    end
    if eyeTracker 
        cd(folders.write_folder);
        et.stopRecording();
        et.closeFile();
        et.receiveFile();
        cd(folders.scripts_folder);
    end

end