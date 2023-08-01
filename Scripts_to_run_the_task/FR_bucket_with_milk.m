function FR_bucket_with_milk(windowHandle, bucket, milkHeight, colors, envType)
% Written by Nick Sidorenko, PhD student at Philippe Tobler group, Zurich Center for Neuroeconomics
% This function creates a bucket to display with milk at a given time
        Screen('FillRect', windowHandle, colors.bucketColor, bucket.basement);
        Screen('FillRect', windowHandle, colors.bucketColor, bucket.top);
        Screen('FillRect', windowHandle, colors.milkColor, milkHeight);
        switch envType
            case 'rich'
                Screen('FrameRect', windowHandle, colors.frameRichEnvColor, [bucket.top(1) - 300, bucket.top(2) - 80, bucket.top(3) + 300, bucket.basement(4) + 80], 30); 
            case 'poor'
                Screen('FrameRect', windowHandle, colors.framePoorEnvColor, [bucket.top(1) - 300, bucket.top(2) - 80, bucket.top(3) + 300, bucket.basement(4) + 80], 30); 
        end
end