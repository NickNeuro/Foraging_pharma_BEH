function rewardInTrial = TIME_patchRewardFunction(yieldType, maxTime)
% Written by Nick Sidorenko, PhD student at Philippe Tobler group, Zurich Center for Neuroeconomics

switch yieldType
    case 'low'
        S = 32.5;
    case 'medium'
        S = 45;
    case 'high'
        S = 57.5;
    case 'constant'
        S = 700;
end

rewardRate = (0:0.05:maxTime)';
if ~(strcmp(yieldType, 'constant'))
    fun = @(x) S*exp(-0.075*x); %Exponential function currently
    for t = 1:length(rewardRate)
        rewardRate(t) = integral(fun, rewardRate(t), rewardRate(t) + 0.05);
    end
    % Vector
    rewardInTrial = cumsum(rewardRate);
else
    fun = @(x) S*x; %Exponential function currently
    for t = 1:length(rewardRate)
        rewardRate(t) = integral(fun, rewardRate(t), rewardRate(t) + 0.05);
    end
    % Vector
    rewardInTrial = rewardRate;
end
    


end