function [richReward, poorReward, envType, jitter] = BEH_FR_design
    % Written by Nick Sidorenko, PhD student at Philippe Tobler group, Zurich Center for Neuroeconomics
    
    maxTime = 120;

    % Rich environment
%     richEnv = repelem({'low', 'medium', 'high'}, [20, 30, 50]);
%     richEnv = richEnv(randperm(length(richEnv)));
    richEnv = {'high','medium','high','low','high','medium','low','high','high','medium','low','high','medium','low','high','high','medium','high','high', ...
               'medium','high','high','low','high','high','medium','high','low','medium','medium','high','medium','medium','low','high','high','medium','high',...
               'low','high','high','high','medium','medium','high','high','high','low','low','medium','high','medium','medium','high','high','low','low','high',...
               'medium','high','high','medium','high','low','low','high','medium','medium','high','high','high','high','high','low','high','medium','high','medium',...
               'medium','low','low','high','medium','high','high','low','medium','medium','high','high','medium','high','low','high','high','high','low','medium','medium','high'};
    richReward = zeros(length(0:0.05:maxTime), length(richEnv));
    for e = 1:length(richEnv)
        richReward(:,e) = FR_patchRewardFunction(richEnv{e}, maxTime);
        disp(e);
    end

    % Poor environment
%     poorEnv = repelem({'low', 'medium', 'high'}, [50, 30, 20]);
%     poorEnv = poorEnv(randperm(length(poorEnv)));
    poorEnv = {'low','low','medium','low','high','medium','medium','low','high','low','low','medium','high','low','medium','low','low','medium','high','low',...
               'low','low','medium','high','low','medium','high','medium','low','low','high','low','low','medium','medium','low','medium','high','low','low','low',...
               'medium','high','low','low','medium','low','high','low','medium','high','medium','medium','low','medium','low','low','low','high','low','low','low',...
               'medium','low','medium','low','low','medium','high','high','low','high','low','high','medium','medium','medium','low','low','low','medium','high','low',...
               'high','low','medium','low','medium','low','low','medium','low','medium','high','medium','high','low','low','low','low'};
    poorReward = zeros(length(0:0.05:maxTime), length(poorEnv));
    for e = 1:length(richEnv)
        poorReward(:,e) = FR_patchRewardFunction(poorEnv{e}, maxTime);
        disp(e);
    end

    % Order of environments - kept the same for each participant
%     order = randi([1 2], 1);
%     switch order
%         case 1
%             envType = {'rich', 'poor'};
%         case 2
%             envType = {'poor', 'rich'};
%     end

    envType = {'poor', 'rich'};
    jitter = 3 + rand(1, 100)*(4-3);
    jitter = round(jitter(randperm(length(jitter))),1);

end