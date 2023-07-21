function out=LoadCSVsAsMatrix(mousePathdir, csvs)
    % Load all csvs in a matrix. The resulting matrix is N x F x C
    % with N being the number of subjects (ie. the number of csvs),
    % F being the number of frames (ie. each csv's number of rows),
    % C is the number of columns

    % Parameters:
    % - mousePathdir (string): the path of the mouse subject
    % - csvs: the list of csvs without any parent folder to load in our final matrix

    % First, we need to know how big any of these matrices are
    testMatrix = readmatrix(fullfile(mousePathdir, csvs{1}));
    [frames, columns] = size(testMatrix);
    
    out = zeros(1, frames, columns);

    for i=1:length(csvs)
        csv = csvs{i};
        matrix = readmatrix(fullfile(mousePathdir,  csv));
        out(i, :, :) = matrix(1:frames, :);
    end
end
