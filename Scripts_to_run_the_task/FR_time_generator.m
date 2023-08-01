folder_to_save = 'C:\Users\nsidor\Documents\GitLab\Neuromodulation\FR\Time\';
% Written by Nick Sidorenko, PhD student at Philippe Tobler group, Zurich Center for Neuroeconomics

if ~exist(folder_to_save, 'dir')
    mkdir(folder_to_save);
end

for elapsedTime = 0:1:20
    file_name = [folder_to_save filesep num2str(elapsedTime) '.bmp'];
    fig = figure('visible', 'on');
    fig.Color = [178.5 178.5 178.5]./255;
    fig.InvertHardcopy = 'off';
    x = [(20 - elapsedTime)/20, elapsedTime/20];
    labels = {'', ''};
    timeCircle = pie(x, [], labels);
    timeCircle(1).FaceColor = [178.5 178.5 178.5]./255;
    timeCircle(3).FaceColor = [214 46 62]./255;
    pos = get(gca, 'Position');
    set(gca, 'Position', [0.1 0.1 0.8 0.8])
    saveas(gcf, file_name);
    %Image cropping
    I = imread(file_name);
    [rows, columns, numberOfColorChannels] = size(I);
    rect = centerCropWindow2d(size(I), [min(rows, columns), min(rows, columns)]);
    J = imcrop(I, rect);
    imwrite(J, file_name);

end


