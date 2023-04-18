function WNposeExtractionOneMouse3D(pathdir, Mouse)
    set(0, 'DefaultFigureVisible', 'off');

    % Import data from CSV file. Copy full path and file name
    meanDistancesPathdir = [pathdir '/Mean Distances/'];
    pathdir = [pathdir '/' Mouse];
    [labels, csvs] = GetCSVs(pathdir, Mouse);
    matrix = LoadCSVsAsMatrix(pathdir, csvs);

    mkdir meanDistancesPathdir;
    
    [nSubjs, frames, cols] = size(matrix);

    % Take all subjects and concat them in our matrix.
    % The reason this looks ugly is that:
    % - cat cannot concatenate a *single* matrix along an axis
    % - reshape does not work as it will first pick the ith row of each subject
    %   before going to the next row, rather than iterating by subject first,
    %   and rows seconds.
    % The latter is due to the fact matlab is column-major rather than row-major,
    % thus values are spilled by the first dimension (subjects) rather than
    % the one-but-last (frames);
    % This wouldn't be a problem hadn't it been that COLUMN MAJOR MAKES NO
    % FREAKING SENSE WITH TENSORS!!!

    ThisMouse = zeros(nSubjs*frames, cols);
    for i=0:nSubjs-1
        ThisMouse(frames*i+1:frames*(i+1), :) = matrix(i+1, :, :);
    end

    % Replace the gaps (NaN cells) with closest value in the column
    ThisMouseY = fillmissing(ThisMouse(:, 3:3:end), 'previous');

    FramesThisMouse = repmat((1:frames)', nSubjs, 1);

    % Makes each id start from 1 for our convenience
    ThisMouse(:, 1) = ThisMouse(:, 1) + 1;

    % Calculate Body-parts distances for the Y coordinates
    % by enumerating all body-part pairs

    DistMatrix = [];
    [yframes, bodyparts] = size(ThisMouseY);

    for i=(1:bodyparts)
        for j=(i+1:bodyparts)
            DistMatrix(end+1, :) = ThisMouseY(:, i) - ThisMouseY(:, j);
        end
    end

    DistMatrix = DistMatrix.';

    % TIME FOR CLUSTERING
    % FIXME the number of clusters should/could be fixed
    Elbow=kmeans_opt(DistMatrix);  %K-mean clustering using Elbow method to determine optilan number (UNSUPERVISED)
    Clusters=unique(Elbow);
    for i=1:length(Clusters)
        counts(i)=sum(Elbow==Clusters(i));
    end

    clear i

    %POSTURE DETERMINATION
    %Now that the clustering is done, assign each original observation to a
    %cluster
    ClusterSummary=[Clusters, counts'];                  %Recall number of Frames per Cluster
   
    ClusteredDist=[FramesThisMouse,DistMatrix,Elbow];    %Distance matrix with Frames and Clusters
    ClusteredYData=[FramesThisMouse,ThisMouseY,Elbow];   %Original Coordinates with Clusters assigned
    ThisMouseClustered=[ThisMouse,Elbow];     %Original DLC output with Clusters assigned

    for subjId=0:nSubjs-1
        label = labels{subjId+1};
        clustered = ClusteredYData(frames*subjId+1:frames*(subjId+1), :);
        title = [label ' poses overtime'];
        fig = figure ('Name', title);
        scatter(clustered(:, 1), clustered(:, 8));
        saveas(fig, [pathdir '/' label '_over_time.png']);
    end

    
    % clear counts  FramesThisMouse i SHAMy T1y T2y T3y DistMatrix FindSHAM FindT1 FindT2 FindT3

    %Starting From the ClusteredData matrix extract each single cluster and plot
    %the corresponding posture on a scatter plot
    disp(pathdir)
    mkdir([pathdir '/Clusters/']);

    for Cluster2Explore=1:length(ClusterSummary)
        num=length(ClusteredYData);
        ClusterIndex=0;

        for ind=1:num
            if ClusteredYData(ind,8)==Cluster2Explore
                ClusterIndex=(ClusterIndex+1);
                Cluster(ClusterIndex,1:8)=ClusteredYData(ind,1:8);

            end
        end

        NameCluster=num2str(Cluster2Explore);
        %assignin('base',NameCluster,Cluster);

        writematrix(Cluster, [pathdir '/Clusters/C' num2str(Cluster2Explore) '.csv']);
        ClusterMean=[mean(Cluster(:,2:7))];

        %Create a Representative Scatter Plot for the Cluster just analyzed
        fig = figure('Name',NameCluster);
        Ycoord=[ClusterMean/-1];
        Xcoord=[1:6];
        plot(Xcoord,Ycoord,'-x');
        saveas(fig, [pathdir '/Clusters/C' label '_rep.png']);

        ClusterIndex=(ClusterIndex+1);
        saveas(gcf, [pathdir '/Clusters/' num2str(ind) '-' num2str(Cluster2Explore) '.png']);
        AllClustersMean(Cluster2Explore,:)=mean(Cluster(:,2:end));

        clear Cluster
    end

    %Average the ClusteredDist Matrix for future analysis
    for DistIndex=1:length(ClusterSummary)
        [Dist2Avg]=find(ClusteredDist(:,17)==DistIndex);
        toAVG=[ClusteredDist(Dist2Avg,2:16)];
        ClusteredDistMeans(DistIndex,:)=[mean(toAVG),DistIndex];
    end

    %Create a string vetor with the Animal Code to include with the Cluster
    %Mean Summary
    code=strings(length(ClusterSummary), 1);
    code(:)=Mouse;

    %Generate Cluster Mean Summary for both Ycoordinates and Distances
    AllClustersMean=[code,AllClustersMean,ClusterSummary(:,2:end)];
    ClusteredDistMeans=[code,ClusteredDistMeans];

    AllClustersMean(1:end,1:1)=Mouse;    %Assign the Mouse Identity to the first column of the matrix
    ClusteredDistMeans(1:end,1:1)=Mouse;


    ClusterDir = [pathdir '/Clusters/'];
    SummaryDir = [pathdir '/Summary/'];
    mkdir(ClusterDir);
    mkdir(SummaryDir);

    %Print Outcome in CSV files
    writematrix(AllClustersMean, [SummaryDir 'Mouse' Mouse 'CoordMeans.csv']);
    writematrix(ClusteredDistMeans, [meanDistancesPathdir 'Mouse' Mouse 'DistMeans.csv']);
    writematrix(ClusteredYData, [SummaryDir 'Clustered' Mouse 'Data.csv']);
    writematrix(ClusteredDist, [SummaryDir 'Clustered' Mouse 'Dist.csv']);
    writematrix(ThisMouseClustered, [SummaryDir 'Mouse' Mouse 'Clustered.csv']);

    for subjId=0:nSubjs-1
        label = labels{subjId+1};
        clustered = [ClusteredYData(frames*subjId+1:frames*(subjId+1), :)];
        writematrix(clustered, [ClusterDir 'Clustered' label '.csv']);
    end


    %Eliminate unwanted variables
    clear ans ind num ClusterIndex Xcoord Ycoord Cluster2Explore NameCluster NameCluster ClusterMean toAVG Dist2Avg code T1name T2name T3name SHAMname OFname DistIndex

    %Print Clusters into CSV files

    set(0, 'DefaultFigureVisible', 'on');
end

function [labels, fileList]=GetCSVs(pathdir, mouse)
    % Detect all CSVs in our file
    files = dir(pathdir);
    nfiles = size(files);
    fileList = {};
    labels = {};
    for i = 1:nfiles
        filename = files(i).name;
        if endsWith(filename, ".csv")
            suffixToStrip = '_DLC_3D.csv'; % FIXME
            stripped = filename(length(mouse)+2:end-length(suffixToStrip));
            labels{end+1} = stripped;
            fileList{end+1} = filename;
        end
    end
end

function out=LoadCSVsAsMatrix(mousePathdir, csvs)
    % Load all csvs in a matrix. The resulting matrix is N x F x C
    % with N being the number of subjects (ie. the number of csvs),
    % F being the number of frames (ie. each csv's number of rows),
    % C is the number of columns

    % First, we need to know how big any of these matrices are
    testMatrix = readmatrix([mousePathdir '/' csvs{1}]);
    [frames, columns] = size(testMatrix);
    frames = frames - 1; % FIXME

    out = zeros(1, frames, columns);

    for i=1:length(csvs)
        csv = csvs{i};
        matrix = readmatrix([mousePathdir '/' csv]);
        out(i, :, :) = matrix(1:frames, :);
    end
end
