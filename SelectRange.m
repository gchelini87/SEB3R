% Inspect a subject and extract a range of interest

import tools.GetCSVs;
subjectPath = uigetdir("Please choose a subject");
modulesPath = fullfile(subjectPath, 'Modules');
times = inputdlg({'Begin time (in seconds, first second is 1)', 'End time (in seconds, first second is 1)'}, 'Time frame inspector');

start = str2num(times{1});
stop = str2num(times{2});

[modules csvs]= GetCSVs(modulesPath, "Mouse");

for i=1:length(modules)
    data = readmatrix(fullfile(modulesPath, csvs{i}));
    out = data(start:stop, :)
    if i == 1
        filteredPath = fullfile(modulesPath, sprintf("Filtered-%d-%d", start, stop));
        disp(filteredPath);
        mkdir(filteredPath);
    end
    outPath = fullfile(filteredPath, string(modules{i}) + ".csv");
    writematrix(out, outPath);
end
