Pathdir = ['WN results'];
files = dir(Pathdir);
nfiles = size(files);
disp(size(nfiles));

for i=1:nfiles[1]
    if files(i).isdir
        num = files(i).name;
        if ~isnan(str2double(num))
            WNposeExtractionOneMouse3D(num);
        end
    end
end