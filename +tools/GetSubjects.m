function subjects=GetSubjects(pathdir)
    % Get the list of subjects as a cell array of strings.
    % Arguments:
    % - expPath: the experiment path

    files = dir(pathdir);
    nfiles = size(files);
    disp(size(nfiles));

    subjects = {};
    subjectsCounter = 0;

    % Take the first viable subject, then extract the conditions
    oldVersion = false;

    for i=1:nfiles[1];
        num = files(i).name;
        if files(i).isdir && ~isnan(str2double(num));
            subjectsCounter = subjectsCounter + 1;
            subjects{subjectsCounter} = num;
        end
    end
end
