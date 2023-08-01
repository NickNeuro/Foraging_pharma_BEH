function FR_collected_reward(windowHandle, reward, colors, time, imageTexture, counter, textSize)
    % Written by Nick Sidorenko, PhD student at Philippe Tobler group, Zurich Center for Neuroeconomics
    % Dispaly collected reward
    Screen('FillRect', windowHandle, colors.bucketColor, reward.bucket);
    Screen('FillRect', windowHandle, colors.milkColor, reward.milk);
    % Display remaining time
    Screen('TextSize', windowHandle, textSize.task);
    DrawFormattedText(windowHandle, 'Time to reach the next field:', 'center', time.textPos, colors.textColor);
    Screen('DrawTexture', windowHandle, imageTexture{counter, 1}, [], time.Pos);
end