function [pathdir, CombinedFile]=CombineData(column)
    %input (required); number of colums of the table to combine (all table MUST
    %be same size)
    % output: pathdir and combined mean dir

pathdir = uigetdir();
FindMeans = dir(pathdir);

%FindMeans=fullfile(folderPickAll,AllMeans);
%FindMeansTwo=string(FindMeans);
FindMeansTwo = FindMeans
CombinedFile=zeros(1,column);
for ind=1:length(FindMeansTwo);
    file = FindMeansTwo(ind);
    if ~file.isdir
        ThisPose=readmatrix(fullfile(pathdir, file.name));
        CombinedFile=vertcat(CombinedFile,ThisPose);
    end
end
clear AllMeans filterindex FindMeans FindMeansTwo folderPickAll ind ThisPose
CombinedFile(1:1,:)=[];
end
