path = uigetdir();
res = Concatenate(path);
outputPath = fullfile(path, "CombinedFrequencies.csv");
writematrix(res, outputPath);


function res = Concatenate(path)
    import tools.GetSubjects;
    subjects = GetSubjects(path);

    
    for subjId = 1:length(subjects);
        subject = subjects{subjId};
        modulePath = fullfile(path, subject, "Modules", "Frequencies.csv");
        subjFreqs = readmatrix(modulePath);
        [nModules, nTasks] = size(subjFreqs);
        subjAsNum = str2num(subject);

        % Append id to frequency
        subjFreqs = [repelem(subjAsNum, nModules, 1) (1:nModules)' subjFreqs];

        if exist('res', 'var')
            res = [res; subjFreqs];
        else
            res = subjFreqs;
        end
    end
end

