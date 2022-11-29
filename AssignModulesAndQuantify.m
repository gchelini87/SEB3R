%This step simply assign the final BM to each frame, animal-by-animal.
%The output prints CSV files containing BM assigned at any given frame of
%the original CSV files plus a summary table of BMs frequency for each test
%trial.

%CRITICAL: the subject ID needs to match the ID
%of the files you are loading, otherwise the modules will match wrongly
%with the postures
Subject=()  %Declare subject name first! (as a number)

% Get the ModulesAssigned.CSV file and create a new matrix with it. 
[FILEname,folderFILE]=uigetfile(); FindFILE=fullfile(folderFILE,FILEname);
ModulesAssigned=readmatrix(FindFILE);

clear FindFILE FILEname folderFILE

% Get the ClusteredFiles.CSV (ClusteredOF,
% ClusteredSHAM,ClusteredT1,ClusteredT2,ClusteredT3)files and create a new matrix.
% CRITICAL: files need to be loaded sequentially in temporal order;
% changing order wil result in incorrect matching

[FILEname,folderFILE]=uigetfile(); FindFILE=fullfile(folderFILE,FILEname);
ClusteredOF=readmatrix(FindFILE);
clear FindFILE FILEname folderFILE
[FILEname,folderFILE]=uigetfile(); FindFILE=fullfile(folderFILE,FILEname);
ClusteredSHAM=readmatrix(FindFILE);
clear FindFILE FILEname folderFILE
[FILEname,folderFILE]=uigetfile(); FindFILE=fullfile(folderFILE,FILEname);
ClusteredT1=readmatrix(FindFILE);
clear FindFILE FILEname folderFILE
[FILEname,folderFILE]=uigetfile(); FindFILE=fullfile(folderFILE,FILEname);
ClusteredT2=readmatrix(FindFILE);
clear FindFILE FILEname folderFILE
[FILEname,folderFILE]=uigetfile(); FindFILE=fullfile(folderFILE,FILEname);
ClusteredT3=readmatrix(FindFILE);
clear FindFILE FILEname folderFILE


for index=(1:length(ModulesAssigned));  
    
for k=(1:max(ModulesAssigned(:,3)));
      
        for i=(1:length(ClusteredOF(:,8)));
            
        if ModulesAssigned(index,1)==Subject && ClusteredOF(i,8)==ModulesAssigned(index,2);
               ClusteredOF(i,9)=(ModulesAssigned(index,3));
          end 
        end
end
end


for index=(1:length(ModulesAssigned));  
    
for k=(1:max(ModulesAssigned(:,3)));
      
        for i=(1:length(ClusteredSHAM(:,8)));
            
        if ModulesAssigned(index,1)==Subject && ClusteredSHAM(i,8)==ModulesAssigned(index,2);
               ClusteredSHAM(i,9)=(ModulesAssigned(index,3));
          end 
        end
end
end


for index=(1:length(ModulesAssigned));  
    
for k=(1:max(ModulesAssigned(:,3)));
      
        for i=(1:length(ClusteredT1(:,8)));
            
        if ModulesAssigned(index,1)==Subject && ClusteredT1(i,8)==ModulesAssigned(index,2);
               ClusteredT1(i,9)=(ModulesAssigned(index,3));
          end 
        end
end
end

for index=(1:length(ModulesAssigned));  
    
for k=(1:max(ModulesAssigned(:,3)));
      
        for i=(1:length(ClusteredT2(:,8)));
            
        if ModulesAssigned(index,1)==Subject && ClusteredT2(i,8)==ModulesAssigned(index,2);
               ClusteredT2(i,9)=(ModulesAssigned(index,3));
          end 
        end
end
end

for index=(1:length(ModulesAssigned));  
    
for k=(1:max(ModulesAssigned(:,3)));
      
        for i=(1:length(ClusteredT3(:,8)));
            
        if ModulesAssigned(index,1)==Subject && ClusteredT3(i,8)==ModulesAssigned(index,2);
               ClusteredT3(i,9)=(ModulesAssigned(index,3));
          end 
        end
end
end

writematrix(ClusteredOF, 'MouseXOF.csv')
writematrix(ClusteredSHAM, 'MouseXSHAM.csv')
writematrix(ClusteredT1, 'MouseXT1.csv')
writematrix(ClusteredT2, 'MouseXT2.csv')
writematrix(ClusteredT3, 'MouseXT3.csv')

figure ('Name','OF poses overtime')
scatter(ClusteredOF(:,1),ClusteredOF(:,9));
figure ('Name','SHAM poses overtime')
scatter(ClusteredSHAM(:,1),ClusteredSHAM(:,9));
figure ('Name','Trial1 poses overtime')
scatter(ClusteredT1(:,1),ClusteredT1(:,9));
figure ('Name','Trial2 poses overtime')
scatter(ClusteredT2(:,1),ClusteredT2(:,9));
figure ('Name','Trial3 poses overtime')
scatter(ClusteredT3(:,1),ClusteredT3(:,9));

clear index i k

%Starting From the ClusteredData matrix and the ModulesAssigned file extract each single cluster and plot
%the corresponding posture on a scatter plot

for Cluster2Explore=(1:max(ModulesAssigned(:,3)));
    num=length(ClusteredOF);
    Cluster(1:9)=zeros;
    ClusterIndex=0;

for ind=1:num;
   if ClusteredOF(ind,9)==Cluster2Explore;
       ClusterIndex=(ClusterIndex+1);
        Cluster(ClusterIndex,1:9)=ClusteredOF(ind,1:9);

   end
end
     ClusterFrequency=length(Cluster);
     if Cluster==0;
         ClusterFrequency=0;
     end
     ClusterMean(1:6)=[mean(Cluster(:,2:7))];
     ClusterRecap=[Cluster2Explore ClusterMean ClusterFrequency];
       
     ClusterIndex=(ClusterIndex+1);
     OFModulesMean(Cluster2Explore,:)=[ClusterRecap];
     clear Cluster
end

clear Cluster2Explore ClusterFrequency ClusterIndex ClusterMean ind num ClusterRecap

%Starting From the ClusteredData matrix and the ModulesAssigned file extract each single cluster and plot
%the corresponding posture on a scatter plot

for Cluster2Explore=(1:max(ModulesAssigned(:,3)));
    num=length(ClusteredSHAM);
    Cluster(1:9)=zeros;
    ClusterIndex=0;

for ind=1:num;
   if ClusteredSHAM(ind,9)==Cluster2Explore;
       ClusterIndex=(ClusterIndex+1);
        Cluster(ClusterIndex,1:9)=ClusteredSHAM(ind,1:9);

   end
end
     ClusterFrequency=length(Cluster);
      if Cluster==0;
         ClusterFrequency=0;
      end
     ClusterMean(1:6)=[mean(Cluster(:,2:7))];
     ClusterRecap=[Cluster2Explore ClusterMean ClusterFrequency];
       
     ClusterIndex=(ClusterIndex+1);
     ShamModulesMean(Cluster2Explore,:)=[ClusterRecap];
     clear Cluster
end

clear Cluster2Explore ClusterFrequency ClusterIndex ClusterMean ind num ClusterRecap

%Starting From the ClusteredData matrix and the ModulesAssigned file extract each single cluster and plot
%the corresponding posture on a scatter plot

for Cluster2Explore=(1:max(ModulesAssigned(:,3)));
    num=length(ClusteredT1);
    Cluster(1:9)=zeros;
    ClusterIndex=0;

for ind=1:num;
   if ClusteredT1(ind,9)==Cluster2Explore;
       ClusterIndex=(ClusterIndex+1);
        Cluster(ClusterIndex,1:9)=ClusteredT1(ind,1:9);

   end
end
     ClusterFrequency=length(Cluster);
      if Cluster==0;
         ClusterFrequency=0;
      end
     ClusterMean(1:6)=[mean(Cluster(:,2:7))];
     ClusterRecap=[Cluster2Explore ClusterMean ClusterFrequency];
       
     ClusterIndex=(ClusterIndex+1);
     T1ModulesMean(Cluster2Explore,:)=[ClusterRecap];
     clear Cluster
end

clear Cluster2Explore ClusterFrequency ClusterIndex ClusterMean ind num ClusterRecap

%Starting From the ClusteredData matrix and the ModulesAssigned file extract each single cluster and plot
%the corresponding posture on a scatter plot

for Cluster2Explore=(1:max(ModulesAssigned(:,3)));
    num=length(ClusteredT2);
    Cluster(1:9)=zeros;
    ClusterIndex=0;

for ind=1:num;
   if ClusteredT2(ind,9)==Cluster2Explore;
       ClusterIndex=(ClusterIndex+1);
        Cluster(ClusterIndex,1:9)=ClusteredT2(ind,1:9);

   end
end
     ClusterFrequency=length(Cluster);
      if Cluster==0;
         ClusterFrequency=0;
      end
     ClusterMean(1:6)=[mean(Cluster(:,2:7))];
     ClusterRecap=[Cluster2Explore ClusterMean ClusterFrequency];
       
     ClusterIndex=(ClusterIndex+1);
     T2ModulesMean(Cluster2Explore,:)=[ClusterRecap];
     clear Cluster
end

clear Cluster2Explore ClusterFrequency ClusterIndex ClusterMean ind num ClusterRecap

%Starting From the ClusteredData matrix and the ModulesAssigned file extract each single cluster and plot
%the corresponding posture on a scatter plot

for Cluster2Explore=(1:max(ModulesAssigned(:,3)));
    num=length(ClusteredT3);
    Cluster(1:9)=zeros;
    ClusterIndex=0;

for ind=1:num;
   if ClusteredT3(ind,9)==Cluster2Explore;
       ClusterIndex=(ClusterIndex+1);
        Cluster(ClusterIndex,1:9)=ClusteredT3(ind,1:9);

   end
end
     ClusterFrequency=length(Cluster);
      if Cluster==0;
         ClusterFrequency=0;
      end
     ClusterMean(1:6)=[mean(Cluster(:,2:7))];
     ClusterRecap=[Cluster2Explore ClusterMean ClusterFrequency];
       
     ClusterIndex=(ClusterIndex+1);
     T3ModulesMean(Cluster2Explore,:)=[ClusterRecap];
     clear Cluster
end

clear Cluster2Explore ClusterFrequency ClusterIndex ClusterMean ind num ClusterRecap

%Generate Matrix containing the frame frequencies for each modules in each
%trial
FrequenciesModules=[OFModulesMean ShamModulesMean T1ModulesMean T2ModulesMean T3ModulesMean];
FrequenciesMatrix= [OFModulesMean(:,8) ShamModulesMean(:,8) T1ModulesMean(:,8) T2ModulesMean(:,8) T3ModulesMean(:,8)];
writematrix(FrequenciesModules, 'FrequenciesModulesMouseX.csv');
writematrix(FrequenciesMatrix, 'FrequenciesMouseX.csv');

%The output also plot BM distribution over the time of the test on a
%scatter plot
figure('Name','Modules Heatmap')
heatmap(FrequenciesMatrix)
colormap(jet)
 
