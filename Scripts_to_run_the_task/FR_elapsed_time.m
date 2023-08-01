function FR_elapsed_time(windowHandle, imageTexture, time, colors, counter, textSize)
% Written by Nick Sidorenko, PhD student at Philippe Tobler group, Zurich Center for Neuroeconomics
    seconds = flip(0:6:120);
    Screen('DrawTexture', windowHandle, imageTexture{counter, 1}, [], time.Pos);
    Screen('TextSize', windowHandle, textSize.task);
    DrawFormattedText(windowHandle, ['Remaining time: ' num2str(seconds(counter)) ' sec'], time.textPos(1), time.textPos(2), colors.textColor); % mean price
end