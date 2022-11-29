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

nBM=10   %Chose the number of BM you want.
WNClusters=CombineData(17);
Clusters=WNClusters(:,17);

% Run the clustering
Modules=kmeans(WNClusters(:,2:16),nBM);

WNmodules=[WNClusters,Modules];
N=max(Modules);

ModulesSummary=1:18;             


clear Clusters Modules WNClusters

for Cluster2Explore=1:N;
    num=length(WNmodules);
    ClusterIndex=0;

for ind=1:num;
   if WNmodules(ind,18)==Cluster2Explore;
       ClusterIndex=(ClusterIndex+1);
        Module(ClusterIndex,1:18)=WNmodules(ind,1:18);
    end
end
     NameCluster=string(num2let(Cluster2Explore));
     assignin('base',NameCluster,Module);
     ClusterMean=[mean(Module(:,2:17))];
     
     ClusterIndex=(ClusterIndex+1);
     ModulesSummary=[ModulesSummary;Module];
     clear Module
    
end
ModulesSummary(1,:)=[];
PostureModulesAssigned=[ModulesSummary(:,1),ModulesSummary(:,17),ModulesSummary(:,18)];
writematrix(ModulesSummary,'ModulesSummary.csv');
writematrix(PostureModulesAssigned,'ModulesAssigned.csv');
