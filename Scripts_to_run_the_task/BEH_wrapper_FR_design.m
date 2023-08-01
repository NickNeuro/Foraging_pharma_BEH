function BEH_wrapper_FR_design(sb_folder, s, session)
% Written by Nick Sidorenko, PhD student at Philippe Tobler group, Zurich Center for Neuroeconomics
%%%% This function create a dataset for the Foraging task

%%%% Inputs %%%%
% 'sb_folder' = the whole path to the folder where a subject folder will be stored
% 's' = subject number (string)
% 'session' = session number (integer)

%%%% Outputs %%%%

        %% Set up a folder where the dataset will be stored
        if s > 0 && s <= 9
            disp(s);
            subject_id = ['0000', num2str(s)];
            subject_folder = [sb_folder filesep 'subject_', subject_id];
            if ~exist(subject_folder, 'dir')
                mkdir(subject_folder);
            end
        elseif s > 9 && s <= 99
            disp(s);
            subject_id = ['000', num2str(s)];
            subject_folder = [sb_folder filesep 'subject_', subject_id];
            if ~exist(subject_folder, 'dir')
                mkdir(subject_folder);
            end
        elseif s > 99
            disp(s);
            subject_id = ['00', num2str(s)];
            subject_folder = [sb_folder filesep 'subject_', subject_id];
            if ~exist(subject_folder, 'dir')
                mkdir(subject_folder);
            end
        end
        
        %% Create a dataset
        filename = [subject_folder filesep 'SNS_BEH_FR_set_S', subject_id, '_', session, '.mat'];

        if ~exist(filename, 'file')
            [richReward, poorReward, envType, jitter] = BEH_FR_design();
            save(filename, 'richReward', 'poorReward', 'envType', 'jitter');
            disp(['Subject ' num2str(s) ' has been processed for the FR task']);
        else
           writeover = input(['FR task dataset for subject ' num2str(s) ' already exists, do you want to overwrite? 1 = yes, 0 = no ', '\n']);
           if writeover
                [richReward, poorReward, envType, jitter] = BEH_FR_design();
                save(filename, 'richReward', 'poorReward', 'envType', 'jitter');
                disp(['Subject ' num2str(s) ' has been processed for the FR task']);
           end % end of overwriting
        end % end of if loop
end % end of function




