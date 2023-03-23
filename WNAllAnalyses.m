Pathdir = ['WN results'];
files = dir(Pathdir);
nfiles = size(files);
for i=1:nfiles
    if files(i).isdir
        num = files(i).name;
        if ~strcmp(num, "Mean Distances WM")
            WNPoseExtractionOneMouse3D(num)
        end
    end
end