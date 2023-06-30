pathdir = uigetdir();
files = dir(pathdir);
nfiles = size(files);
disp(size(nfiles));


% Take the first viable subject, then extract the conditions
oldVersion = false;

for i=1:nfiles[1];
    num = files(i).name;
    if files(i).isdir && ~isnan(str2double(num));
        subjPath = fullfile(pathdir, num, "Modules");
        conditions = GetCSVs(subjPath, "Mouse");
        % The old version used different names for the modules.
        if length(conditions) == 0;
            disp("Warning: this dataset was obtained from an old version of SEB3R.");
            conditions = GetCSVs(subjPath, "MouseX");
        end
        break
    end
end

nconditions = length(conditions);

% Perform sequencing. This will result in a folder "Sequenced" containing
% $nconditions folders, each
for icond = 1:nconditions;
    clear FullSeqs;
    condition = conditions{icond};
    TotalFrames = 0;
    

    for i = 1:nfiles(1)
        if files(i).isdir()
            num = files(i).name;
            if ~isnan(str2double(num));
                subj = num;
                out=SingleSubjectCount(pathdir, subj, condition, oldVersion);
                [nmodules, cols] = size(out);
                FullSeqs(TotalFrames+1:TotalFrames+nmodules, :) = out;
                TotalFrames = TotalFrames + nmodules;
            end
        end
    end
    outdir = fullfile(pathdir, "Sequenced");
    mkdir(outdir);
    writematrix(FullSeqs, fullfile(outdir, condition + ".csv"));
end

function frameCount = SingleSubjectCount(pathdir, subject, condition, oldVersion)
    parentPath = fullfile(pathdir, subject, "Modules");

    % this is pretty ugly
    mouseStr = 'Mouse';
    if oldVersion;
        mouseStr = 'MouseX';
    end

    path = fullfile(parentPath, [mouseStr condition '.csv']);
    frameData = readmatrix(path);
    [rows, cols] = size(frameData);
    frameModules = frameData(:, cols); % last column = BM
    frameCount = CountFrames(frameModules);
    outPath = fullfile(parentPath, "Sequenced" + condition + ".csv");

    %writematrix(frameCount, outPath);
end

function out=CountFrames(frames)
    if length(frames) == 0;
        error("Expecting non-empty numerical array, found an empty array. Is your subject data complete?");
    end

    lastSeen = frames(1);
    counter = 1;
    foundSeqs = 1;
    for i=2:length(frames)
        if frames(i) == lastSeen;
            counter = counter + 1;
        else
            out(foundSeqs, :) = [lastSeen, counter];
            lastSeen = frames(i);
            counter = 1;
            foundSeqs = foundSeqs + 1;
        end
    end

    % The last iteration is always left out
    out(foundSeqs, :) = [lastSeen, counter];
end
