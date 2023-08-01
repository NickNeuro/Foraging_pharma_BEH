function TIME_bucket_with_juice(windowHandle, bucket, juiceHeight, condition, colors)
% Written by Nick Sidorenko, PhD student at Philippe Tobler group, Zurich Center for Neuroeconomics
% This function creates a bucket to display with milk at a given time
        Screen('FillRect', windowHandle, colors.bucketColor, bucket.basement);
        Screen('FillRect', windowHandle, colors.bucketColor, bucket.top);
        if strcmp(condition, 'blind')
            Screen('FillRect', windowHandle, colors.bucketColor, juiceHeight);
            Screen('DrawLine', windowHandle, colors.juiceColor, bucket.bar(1), bucket.bar(2), bucket.bar(3), bucket.bar(4), 5);
        else
            Screen('FillRect', windowHandle, colors.juiceColor, juiceHeight);
        end
end