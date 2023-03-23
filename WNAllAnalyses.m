Pathdir = ['WN results'];
files = dir(Pathdir);
nfiles = size(files);
j = 0;
for i=1:nfiles
    if files(i).isdir
        num = files(i).name;
        if ~isnan(str2double(num))
            j = j + 1;
            WNposeExtractionOneMouse3D(num)
        end
    end
end