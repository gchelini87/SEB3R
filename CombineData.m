function [pathdir, subjdir, CombinedFile]=CombineData(column)
    %input (required); number of colums of the table to combine (all table MUST
    %be same size)
    % output: pathdir and combined mean dir

    pathdir = uigetdir();
    subjdir = fullfile(pathdir, '..');
    FindMeans = dir(pathdir);

    %FindMeans=fullfile(folderPickAll,AllMeans);
    %FindMeansTwo=string(FindMeans);
    FindMeansTwo = FindMeans;
    disp(column);
    disp(subjdir);
    CombinedFile=zeros(1,column);
    for ind=1:length(FindMeansTwo);
        file = FindMeansTwo(ind);
        if ~file.isdir
            ThisPose=readmatrix(fullfile(pathdir, file.name));
            disp(size(CombinedFile))
            disp(size(ThisPose))
            CombinedFile=vertcat(CombinedFile,ThisPose);
        end
    end
    CombinedFile(1:1,:)=[];
end
