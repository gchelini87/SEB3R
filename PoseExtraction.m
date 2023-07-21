% This entry point will perform all analyses on your mice data.
% You will be prompted to provide a folder that contains your DLC results

import tools.PoseExtractionSingle;

pathdir = uigetdir();
files = dir(pathdir);
nfiles = size(files);
disp(size(nfiles));

for i=1:nfiles[1]
    if files(i).isdir
        num = files(i).name;
        if ~isnan(str2double(num))
            PoseExtractionSingle(pathdir, num);
        end
    end
end
