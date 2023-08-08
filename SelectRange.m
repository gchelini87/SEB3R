% Inspect a SINGLE subject and extract a range of interest
% It also recomputes the BM frequencies for that subject.

import tools.Concatenate;

yes = "Just a subject";
no = "All subjects";
isSpecific = questdlg("Do you want to extract a range from a single subject or a whole dataset?", "Select Range", yes, no, yes);
[start, stop] = getTime();

if isSpecific == yes
    subjectPath = uigetdir("Please choose a subject");
    GetRange(subjectPath, start, stop);
else
    folderPath = uigetdir("Please choose a dataset");

    files = dir(folderPath);
    nfiles = size(files);
    disp(size(nfiles));

    for i=1:nfiles[1]
        if files(i).isdir
            num = files(i).name;
            if ~isnan(str2double(num))
                GetRange(fullfile(folderPath, files(i).name), start, stop);
            end
        end
    end

    % Lastly, concatenate the filtered frequencies
    concatenatedOutput = Concatenate(folderPath, [start, stop]);
    outPath = fullfile(folderPath, FreqFiltered(start, stop));
    writematrix(concatenatedOutput, outPath);
end

function GetRange(subjectPath, start, stop)
    import tools.GetCSVs;

    modulesPath = fullfile(subjectPath, 'Modules');
    disp(modulesPath);

    [modules csvs]= GetCSVs(modulesPath, "Mouse");

    % Extract the original number of BMs
    % TODO we could just save those in a config...

    originalFreqs = readmatrix(fullfile(modulesPath, "Frequencies.csv"));
    [numBMs, numModules] = size(originalFreqs)

    freqs = zeros(numBMs, length(modules));

    for i=1:length(numModules)
        data = readmatrix(fullfile(modulesPath, csvs{i}));
        out = data(start:stop, :)
        if i == 1
            filteredPath = fullfile(modulesPath, sprintf("Filtered-%d-%d", start, stop));
            mkdir(filteredPath);
        end
        outPath = fullfile(filteredPath, string(modules{i}) + ".csv");
        writematrix(out, outPath);

        % Extract the frequencies for this trial. Not vectorised but easier to read.
        bms = out(:, end);
        minBm = min(bms);
        maxBm = max(bms);
        for j=1:length(bms)
            freqs(bms(j), i) = freqs(bms(j), i) + 1;
        end
    end

    outPath = fullfile(modulesPath, sprintf("FrequenciesFiltered-%d-%d.csv", start, stop));
    writematrix(freqs, outPath);
end


function [start, stop] = getTime()
    times = inputdlg({'Begin time (in frames, first frame is 1)', 'End time (in frames, first frame is 1)'}, 'Time frame inspector');

    start = str2num(times{1});
    stop = str2num(times{2});
end

function out = FreqFiltered(start, stop)
    out = sprintf("FrequenciesFiltered-%d-%d.csv", start, stop);
end
