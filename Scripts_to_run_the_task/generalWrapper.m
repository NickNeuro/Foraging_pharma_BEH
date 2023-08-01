% Written by Nick Sidorenko, PhD student at Philippe Tobler group, Zurich Center for Neuroeconomics
%% BEHAVIOURAL STUDY %%
% Set up input and output variables
general_folder = '';
scripts_folder = dir(fullfile(general_folder, '**', 'Scripts')).folder; cd(scripts_folder);
sb_folder = dir(fullfile(general_folder, '**', 'Subjects\BEH')); sb_folder = sb_folder.folder;
session = '1';
n = 160;

% In which order each subject should do the tasks
taskOrder = zeros(n, 4);
for t = 1:160
    taskOrder(t,:) = randperm(4);
end
save([sb_folder filesep 'taskOrderAssignment.mat'], 'taskOrder');

for s = 1:160
%     BEH_wrapper_RISKGARP_design(general_folder, sb_folder, s, session);
%     BEH_wrapper_WTP_design(general_folder, sb_folder, s, session);
    BEH_wrapper_FR_design(sb_folder, s, session);
%     BEH_wrapper_FAB_design(general_folder, sb_folder, s, session);
%     BEH_wrapper_TIME_design(sb_folder, s, session);
%     BEH_wrapper_TIME_design(sb_folder, s, '0');
end