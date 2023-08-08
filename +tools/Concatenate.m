function res = Concatenate(path, filteredRange)
    % Concatenate all frequency data from a dataset path.
    % Arguments:
    % - path: a dataset path
    % - filteredRange: if provided, it should be a tuple [start, finish], meaning that
    %   the expected frequency file is "FrequenciesFiltered-$start-$finish.csv"

    import tools.GetSubjects;
    subjects = GetSubjects(path);

    if nargin == 2
        start = filteredRange(1);
        stop = filteredRange(2);
        freqFileName = sprintf("FrequenciesFiltered-%d-%d.csv", start, stop);
    else
        freqFileName = "Frequencies.csv";
    end
    
    for subjId = 1:length(subjects);
        subject = subjects{subjId};
        modulePath = fullfile(path, subject, "Modules", freqFileName);
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

