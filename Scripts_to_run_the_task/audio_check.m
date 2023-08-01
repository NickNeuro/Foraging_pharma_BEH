function audio_check(s, write_folder)
    % Written by Nick Sidorenko, PhD student at Philippe Tobler group, Zurich Center for Neuroeconomics
    files = dir(fullfile(write_folder, '**', ['*raise_hand_questions*', s, '*.mat']));
    if length(files) ~= 0
        [soundData, freq] = audioread('questions.wav');
        pahandle = PsychPortAudio('Open', [], [], 0, freq, [], [], 0.015);
        PsychPortAudio('FillBuffer', pahandle, soundData');
        PsychPortAudio('Start', pahandle, 1, 0); 
        delete([files.folder filesep files.name]);
    end
    files = dir(fullfile(write_folder, '**', ['*raise_hand_training*', s, '*.mat']));
    if length(files) ~= 0
        [soundData, freq] = audioread('training.wav');
        pahandle = PsychPortAudio('Open', [], [], 0, freq, [], [], 0.015);
        PsychPortAudio('FillBuffer', pahandle, soundData');
        PsychPortAudio('Start', pahandle, 1, 0); 
        delete([files.folder filesep files.name]);
    end
    files = dir(fullfile(write_folder, '**', ['*raise_hand_gum_start*', s, '*.mat']));
    if length(files) ~= 0
        [soundData, freq] = audioread('gum_start.wav');
        pahandle = PsychPortAudio('Open', [], [], 0, freq, [], [], 0.015);
        PsychPortAudio('FillBuffer', pahandle, soundData');
        PsychPortAudio('Start', pahandle, 1, 0); 
        delete([files.folder filesep files.name]);
    end
    files = dir(fullfile(write_folder, '**', ['*raise_hand_gum_end*', s, '*.mat']));
    if length(files) ~= 0
        [soundData, freq] = audioread('gum_end.wav');
        pahandle = PsychPortAudio('Open', [], [], 0, freq, [], [], 0.015);
        PsychPortAudio('FillBuffer', pahandle, soundData');
        PsychPortAudio('Start', pahandle, 1, 0); 
        delete([files.folder filesep files.name]);
    end
    files = dir(fullfile(write_folder, '**', ['*raise_hand_eye*', s, '*.mat']));
    if length(files) ~= 0
        [soundData, freq] = audioread('eye.wav');
        pahandle = PsychPortAudio('Open', [], [], 0, freq, [], [], 0.015);
        PsychPortAudio('FillBuffer', pahandle, soundData');
        PsychPortAudio('Start', pahandle, 1, 0); 
        delete([files.folder filesep files.name]);
    end
end