pathdir = uigetdir();
%pathdir = 'WN results';
files = dir(pathdir);
nfiles = length(files);

for i=1:nfiles
    if files(i).isdir
        num = files(i).name;
        if ~isnan(str2double(num))
            Assign(pathdir, num);
        end
    end
end

function Assign(pathdir, subject)
   set(0,'DefaultFigureVisible','off');

   %This step simply assign the final BM to each frame, animal-by-animal.
   %The output prints CSV files containing BM assigned at any given frame of
   %the original CSV files plus a summary table of BMs frequency for each test
   %trial.

   % Get the ModulesAssigned.CSV file and create a new matrix with it. 
   ModulesAssigned = readmatrix(fullfile(pathdir, 'ModulesAssigned.csv'));

   clusterPathdir = fullfile(pathdir, subject, 'Clusters');
   modulePathdir = fullfile(pathdir, subject, 'Modules');
   subjectAsNum = str2double(subject);
   mkdir(modulePathdir);

   [phaseLabels, phaseCSVs] = GetCSVs(clusterPathdir, subject);
   disp(clusterPathdir);
   disp(phaseCSVs);
   clusteredPhases = LoadCSVsAsMatrix(clusterPathdir, phaseCSVs);
   numPhases = length(phaseLabels);

   numClusters = max(ModulesAssigned(:,3)); % Maximum cluster number
   % TODO: explain what 8 and 9 and 3 are.


   modulesMean = zeros(numPhases, numClusters, 8);

   % Reassign clusters to modules
   for phase=(1:numPhases)
      singlePhaseCluster = squeeze(clusteredPhases(phase, :, :));

      for index=(1:length(ModulesAssigned))
         for i = (1:length(singlePhaseCluster(:, 8)))
            if ModulesAssigned(index,1) == subjectAsNum && singlePhaseCluster(i,8)==ModulesAssigned(index,2);
               clusteredPhases(phase, i, 9)=(ModulesAssigned(index,3));
            end
         end
      end

      % Reload, just in case Matlab keeps an old version
      singlePhaseCluster = squeeze(clusteredPhases(phase, :, :));
      phaseName = phaseLabels{phase};
      phasePath = fullfile(modulePathdir, ['Mouse' phaseName '.csv'] );
      writematrix(singlePhaseCluster, phasePath);

      title = [phaseName 'poses overtime'];
      fig = figure ('Name', title);
      scatter(singlePhaseCluster(:,1), singlePhaseCluster(:,9));
      saveas(fig, fullfile(modulePathdir, [phaseName '_over_time.png']));


      % Calculate per-BM frequency distribution
      for Cluster2Explore=1:numClusters
         num=length(singlePhaseCluster);
         Cluster(1:9)=zeros;
         ClusterIndex=0;

         for ind=1:num;
            if singlePhaseCluster(ind,9)==Cluster2Explore;
               % There are better ways to do this actually...
               ClusterIndex=(ClusterIndex+1);
               Cluster(ClusterIndex,1:9)=singlePhaseCluster(ind,1:9);
            end
         end
         ClusterFrequency=length(Cluster);
         if Cluster==0;
            ClusterFrequency=0;
         end
         ClusterMean(1:6)=[mean(Cluster(:,2:7))];
         ClusterRecap=[Cluster2Explore ClusterMean ClusterFrequency];

         ClusterIndex=(ClusterIndex+1);
         modulesMean(phase, Cluster2Explore,:)=[ClusterRecap];
      end
   end
   
   clear Cluster2Explore ClusterFrequency ClusterIndex ClusterMean ind num ClusterRecap

   %Generate Matrix containing the frame frequencies for each modules in each
   %trial

   FrequenciesModules = zeros(numClusters, numPhases*8);
   for i=0:numPhases-1
      FrequenciesModules(:, i*8+1:(i+1)*8) = modulesMean(i+1, :, :);
   end

   FrequenciesMatrix = FrequenciesModules(:, 8:numPhases*8:8);

   writematrix(FrequenciesModules, fullfile(modulePathdir, ...
      sprintf('FrequenciesModules.csv', subject)));
   writematrix(FrequenciesMatrix, fullfile(modulePathdir, ...
      sprintf('Frequencies.csv', subject)));

   set(0,'DefaultFigureVisible','on');

   %The output also plot BM distribution over the time of the test on a
   %scatter plot
   fig = figure('Name','Modules Heatmap');
   heatmap(FrequenciesMatrix);
   colormap(jet);
   saveas(fig, fullfile(modulePathdir, sprintf("Reassigned.png", subject)));

end

function [labels, fileList]=GetCSVs(pathdir, mouse)
    % Detect all CSVs in our file
    files = dir(pathdir);
    nfiles = size(files);
    fileList = {};
    labels = {};
    prefixToStrip = 'Clustered';
    suffixToStrip = '.csv'; 
    for i = 1:nfiles
        filename = files(i).name;
        if endsWith(filename, suffixToStrip) && startsWith(filename, prefixToStrip);
            stripped = filename(length(prefixToStrip)+1:end-length(suffixToStrip));
            labels{end+1} = stripped;
            fileList{end+1} = filename;
        end
    end
end

