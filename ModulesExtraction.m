%Starting For a Combined Matrix containing the average coordinates for each animals and relative postures
%Extract Behavioral Modules by clustering accross different animals
%CRITICAL! you'll need to assign a number to the variable nBM. This way you
%can chose te number of BM to identify among all the posture extracted per
%every single mouse. The choice of BM might result in an iterative process
%where the user decides the number that better describes each subject. It
%is reccomended to start with a number to N+/-1 respect to the lower number of
%postures identified in one single subject
%EXAMPLE: if in your cohort the lowest number of posture observed is 10
%(in one or more subject), chose something between 9 and 11 to avoid data
%distorsion where some subjects are overrepresented in one BM and other are not
%present.

% TODO needs rewriting

nBMStr = inputdlg("Choose the number of BM you want.");
nBM = str2num(nBMStr{1});
[pathdir, subjdir, ExpClusters] = CombineData(17);
Clusters=ExpClusters(:,17);

% Run the clustering
Modules=kmeans(ExpClusters(:,2:16),nBM);

PrevModules=[ExpClusters,Modules];
N=max(Modules);

ModulesSummary=1:18;             

for Cluster2Explore=1:N;
   num=length(PrevModules);
   ClusterIndex=0;

   for ind=1:num;
      if PrevModules(ind,18)==Cluster2Explore;
         ClusterIndex=(ClusterIndex+1);
         Module(ClusterIndex,1:18)=PrevModules(ind,1:18);
      end
   end
   ClusterIndex=(ClusterIndex+1);
   ModulesSummary=[ModulesSummary;Module];
   clear Module
end

ModulesSummary(1,:)=[];
PostureModulesAssigned=[ModulesSummary(:,1),ModulesSummary(:,17),ModulesSummary(:,18)];
summaryPath = fullfile(subjdir, 'ModulesSummary.csv');
posturePath = fullfile(subjdir, 'ModulesAssigned.csv');
writematrix(ModulesSummary, summaryPath);
writematrix(PostureModulesAssigned, posturePath);

function [pathdir, subjdir, CombinedFile]=CombineData(column)
    % TODO rewrite docstring
    %input (required); number of colums of the table to combine (all table MUST
    %be same size)
    % output: pathdir and combined mean dir

    pathdir = uigetdir();
    subjdir = fullfile(pathdir, '..');
    FindMeans = dir(pathdir);

    disp(column);
    disp(subjdir);
    CombinedFile=zeros(1,column);
    for ind=1:length(FindMeans);
        file = FindMeans(ind);
        if ~file.isdir
            ThisPose=readmatrix(fullfile(pathdir, file.name));
            disp(size(CombinedFile))
            disp(size(ThisPose))
            CombinedFile=vertcat(CombinedFile,ThisPose);
        end
    end
    CombinedFile(1:1,:)=[];
end
