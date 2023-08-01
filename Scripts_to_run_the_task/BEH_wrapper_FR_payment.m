function windowHandle = BEH_wrapper_FR_payment(subject_id, session, general_folder, windowHandle)
% Written by Nick Sidorenko, PhD student at Philippe Tobler group, Zurich Center for Neuroeconomics

    %% ARGUMENTS
    folders = struct;
    folders.subject_folder = dir(fullfile(general_folder, '**', 'BEH', '**', ['subject_', subject_id])); folders.subject_folder = folders.subject_folder.folder;
%     folders.write_folder = dir(fullfile(general_folder, '**', 'Outcome')); folders.write_folder = folders.write_folder.folder;
    folders.write_folder = '';
    responses_poor = load([folders.write_folder filesep 'SNS_BEH_FR_task_poor_S', subject_id, '_', session, '.mat']);
    responses_rich = load([folders.write_folder filesep 'SNS_BEH_FR_task_rich_S', subject_id, '_', session, '.mat']);
    finalAmount = responses_poor.responses.finalAmount + responses_rich.responses.finalAmount;
    
    if isempty(windowHandle)
        windowHandle = BEH_FR_payment(finalAmount, []);
    else
        BEH_FR_payment(finalAmount, windowHandle);
    end
end