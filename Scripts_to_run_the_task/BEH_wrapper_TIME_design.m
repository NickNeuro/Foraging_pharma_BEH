function BEH_wrapper_TIME_design(sb_folder, s, session)
%%%% This function create a dataset for the Time Perception task
% Written by Nick Sidorenko, PhD student at Philippe Tobler group, Zurich Center for Neuroeconomics

%%%% Inputs %%%%
% 'sb_folder' = the whole path to the folder where a subject folder will be stored
% 's' = subject number (string)
% 'session' = session number (integer)

%%%% Outputs %%%%

        %% Set up a folder where the dataset will be stored
        if s > 0 && s <= 9
            disp(s);
            if session == '0'
                subject_id = ['1000', num2str(s)];
            else
                subject_id = ['0000', num2str(s)];
            end
            subject_folder = [sb_folder filesep 'subject_', subject_id];
            if ~exist(subject_folder, 'dir')
                mkdir(subject_folder);
            end
        elseif s > 9 && s <= 99
            disp(s);
            if session == '0'
                subject_id = ['100', num2str(s)];
            else
                subject_id = ['000', num2str(s)];
            end
            subject_folder = [sb_folder filesep 'subject_', subject_id];
            if ~exist(subject_folder, 'dir')
                mkdir(subject_folder);
            end
        elseif s > 99
            disp(s);
            if session == '0'
                subject_id = ['10', num2str(s)];
            else
                subject_id = ['00', num2str(s)];
            end
            subject_folder = [sb_folder filesep 'subject_', subject_id];
            if ~exist(subject_folder, 'dir')
                mkdir(subject_folder);
            end
        end
        
        %% Create a dataset
        filename = [subject_folder filesep 'SNS_BEH_TIME_set_S', subject_id, '_', session, '.mat'];

        if ~exist(filename, 'file')
            maxTime = 120;
            env = {'low', 'medium', 'high', 'constant'};
            env = env(randperm(4));
            fillingRate = zeros(length(0:0.05:maxTime), length(env)*3);
            u = 1;
            for e = 1:length(env)
                fillingRate(:,u) = TIME_patchRewardFunction(env{e}, maxTime); disp(e + u); u = u + 1; 
                fillingRate(:,u) = TIME_patchRewardFunction(env{e}, maxTime); disp(e + u); u = u + 1;
                fillingRate(:,u) = TIME_patchRewardFunction(env{e}, maxTime); disp(e + u); u = u + 1;                
            end
            
            timing_to_leave = zeros(size(fillingRate,2),1);
            for e = 1:length(env)
                if strcmp(env{e}, 'low')
                    temp = [5.2; 7.4; round(1 + rand(1, 1)*(30-1),2)];
                    temp = temp(randperm(3));
                    timing_to_leave([1+(e-1)*3; 2+(e-1)*3; 3+(e-1)*3]) = temp;
                elseif strcmp(env{e}, 'high')
                    temp = [12.8; 15; round(1 + rand(1, 1)*(30-1),2)]; 
                    temp = temp(randperm(3));
                    timing_to_leave([1+(e-1)*3; 2+(e-1)*3; 3+(e-1)*3]) = temp;
                elseif strcmp(env{e}, 'medium')
                    temp = [9.55; 11.75; round(1 + rand(1, 1)*(30-1),2)];
                    temp = temp(randperm(3));
                    timing_to_leave([1+(e-1)*3; 2+(e-1)*3; 3+(e-1)*3]) = temp;
                elseif strcmp(env{e}, 'constant')
                    temp = [6; 12; 18]; % multiples of traveling time
                    temp = temp(randperm(3));
                    timing_to_leave([1+(e-1)*3; 2+(e-1)*3; 3+(e-1)*3]) = temp;
                end 
            end
            
            save(filename, 'env', 'fillingRate', 'timing_to_leave');
            disp(['Subject ' num2str(s) ' has been processed for the TIME task']);
        else
           writeover = input(['TIME task dataset for subject ' num2str(s) ' already exists, do you want to overwrite? 1 = yes, 0 = no ', '\n']);
           if writeover

            maxTime = 120;
            env = {'low', 'medium', 'high', 'constant'};
            env = env(randperm(4));
            fillingRate = zeros(length(0:0.05:maxTime), length(env)*3);
            u = 1;
            for e = 1:length(env)
                fillingRate(:,u) = TIME_patchRewardFunction(env{e}, maxTime); disp(e + u); u = u + 1; 
                fillingRate(:,u) = TIME_patchRewardFunction(env{e}, maxTime); disp(e + u); u = u + 1;
                fillingRate(:,u) = TIME_patchRewardFunction(env{e}, maxTime); disp(e + u); u = u + 1;                
            end
            
            timing_to_leave = zeros(size(fillingRate,2),1);
            for e = 1:length(env)
                if strcmp(env{e}, 'low')
                    temp = [5.2; 7.4; round(1 + rand(1, 1)*(30-1),2)];
                    temp = temp(randperm(3));
                    timing_to_leave([1+(e-1)*3; 2+(e-1)*3; 3+(e-1)*3]) = temp;
                elseif strcmp(env{e}, 'high')
                    temp = [12.8; 15; round(1 + rand(1, 1)*(30-1),2)]; 
                    temp = temp(randperm(3));
                    timing_to_leave([1+(e-1)*3; 2+(e-1)*3; 3+(e-1)*3]) = temp;
                elseif strcmp(env{e}, 'medium')
                    temp = [9.55; 11.75; round(1 + rand(1, 1)*(30-1),2)];
                    temp = temp(randperm(3));
                    timing_to_leave([1+(e-1)*3; 2+(e-1)*3; 3+(e-1)*3]) = temp;
                elseif strcmp(env{e}, 'constant')
                    temp = [6; 12; 18]; % multiples of traveling time
                    temp = temp(randperm(3));
                    timing_to_leave([1+(e-1)*3; 2+(e-1)*3; 3+(e-1)*3]) = temp;
                end 
            end
            
            save(filename, 'env', 'fillingRate', 'timing_to_leave');
            disp(['Subject ' num2str(s) ' has been processed for the TIME task']);
           end % end of overwriting
        end % end of if loop
end % end of function




