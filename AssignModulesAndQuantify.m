import tools.GetCSVs;
% import tools.GetSubjects;

pathdir = uigetdir(); % TODO: can this be passed along in SEB3R?
files = dir(pathdir);
nfiles = length(files);

% TODO: replace with GetSubjects?
for i=1:nfiles
    if files(i).isdir
        numFrames = files(i).name;
        if ~isnan(str2double(numFrames))
            Assign(pathdir, numFrames);
        end
    end
end

function FrequenciesModules = Assign(pathdir, subject)
   set(0,'DefaultFigureVisible','off');

   %This step assigns the final BM to each frame, animal-by-animal.
   %The output prints CSV files containing BM assigned at any given frame of
   %the original CSV files plus a summary table of BMs frequency for each test
   %trial.

   % Get the ModulesAssigned.CSV file and create a new matrix with it. 
   ModulesAssigned = readmatrix(fullfile(pathdir, 'ModulesAssigned.csv'));

   clusterPathdir = fullfile(pathdir, subject, 'Clusters');
   modulePathdir = fullfile(pathdir, subject, 'Modules');
   subjectAsNum = str2double(subject);
   mkdir(modulePathdir);

   [phaseLabels, phaseCSVs] = GetCSVs(clusterPathdir, 'Clustered');
   disp(clusterPathdir);
   disp(phaseCSVs);
   clusteredPhases = LoadCSVsAsMatrix(clusterPathdir, phaseCSVs);
   numPhases = length(phaseLabels);

   numModules = max(ModulesAssigned(:,3)); % Maximum cluster number
   % TODO: explain what 8 and 9 and 3 are.

   modulesMean = zeros(numPhases, numModules, 8);

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
      for Module2Explore=1:numModules
         numFrames=length(singlePhaseCluster);
         % ... WHY ARE WE DOING THIS???
         Cluster(1:9)=zeros;
         ClusterIndex=0;

         for frame=1:numFrames
            if singlePhaseCluster(frame,9)==Module2Explore
               % There are better ways to do this actually...
               ClusterIndex=(ClusterIndex+1);
               Cluster(ClusterIndex,1:9)=squeeze(singlePhaseCluster(frame,1:9));
            end
         end
         disp(size(Cluster));
         ClusterFrequency=length(Cluster)
         if Cluster==0
            ClusterFrequency=0;
         end
         ClusterMean(1:6)=[mean(Cluster(:,2:7))];
         disp(size(Cluster(:, 2:7)));
         disp(size(mean(Cluster(:, 2:7))));
         disp(size(Cluster));
         ClusterRecap=[Module2Explore ClusterMean ClusterFrequency];

         ClusterIndex=(ClusterIndex+1);
         modulesMean(phase, Module2Explore,:)=[ClusterRecap];
         clear Cluster
      end
   end
   
   %clear Module2Explore ClusterFrequency ClusterIndex ClusterMean frame numFrames ClusterRecap

   %Generate Matrix containing the frame frequencies for each modules in each
   %trial

   
   FrequenciesModules = [];
   FrequenciesMatrix = [];
   for i = 1:numPhases
       FrequenciesModules = [FrequenciesModules modulesMean(i, :, :)];
       FrequenciesMatrix = [FrequenciesMatrix; modulesMean(i, :, 8)];
   end

   FrequenciesMatrix = FrequenciesMatrix.';


   writematrix(FrequenciesModules, fullfile(modulePathdir, ...
      sprintf('FrequenciesModules.csv', subject)));
   writematrix(FrequenciesMatrix, fullfile(modulePathdir, ...
      sprintf('Frequencies.csv', subject)));

   %The output also plot BM distribution over the time of the test on a
   %scatter plot
   fig = figure('Name','Modules Heatmap');
   heatmap(FrequenciesMatrix);
   colormap(jet);
   saveas(fig, fullfile(modulePathdir, sprintf("Reassigned.png", subject)));
   set(0,'DefaultFigureVisible','on');
end

