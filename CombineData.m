function [CombinedFile]=CombineData(column)
%imput (required); number of colums of the table to combine (all table MUST
%be same size)

[AllMeans, folderPickAll, filterindex] = uigetfile( ...
{'All Files'}, ...
'Pick a file', ...
'MultiSelect', 'on');   

FindMeans=fullfile(folderPickAll,AllMeans);
FindMeansTwo=string(FindMeans);

CombinedFile=zeros(1,column);
for ind=1:length(FindMeansTwo);
    ThisPose=readmatrix(FindMeansTwo(1,ind));
    CombinedFile=vertcat(CombinedFile,ThisPose);
end
clear AllMeans filterindex FindMeans FindMeansTwo folderPickAll ind ThisPose
CombinedFile(1:1,:)=[];
end
