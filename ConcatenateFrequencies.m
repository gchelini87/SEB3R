% This script takes all Frequencies.csv (aka: BM frequency filtered by trials)
% from each subject and concatenates them into a final csv file, called
% "CombinedFrequencies.csv".

import tools.Concatenate;

path = uigetdir();
res = Concatenate(path);
outputPath = fullfile(path, "CombinedFrequencies.csv");
writematrix(res, outputPath);

