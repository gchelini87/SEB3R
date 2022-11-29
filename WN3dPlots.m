%Inport the ClusteredDist file you whish to plot
function WN3dPlots
[FILEname,folderFILE]=uigetfile(); FindFILE=fullfile(folderFILE,FILEname);
ClusteredDist=readmatrix(FindFILE);

%Normalize data
MIN=min(ClusteredDist); 
MAX=max(ClusteredDist); 
norm=(ClusteredDist-MIN)./(MAX-MIN);

%Create 3D Plots Before Clustering
figure('Name','3D Plot of Normalized Distances');
scatter3(norm(:,2:2),norm(:,3:3),norm(:,4:4),20,'filled','LineWidth',3);
colormap(jet); colorbar;
xlabel('PCA1'); ylabel('PCA2');zlabel('PCA3');
xticks(0.2:0.2:1);yticks(0.2:0.2:1);zticks(0.2:0.2:1);

%Create 3D Plots after Clustering
figure('Name','3D Plot of Clustered Data');
scatter3(norm(:,2:2),norm(:,3:3),norm(:,4:4),20,ClusteredDist(:,17:17),'filled','LineWidth',3);
colormap(jet); colorbar;
xlabel('PCA1'); ylabel('PCA2');zlabel('PCA3');
xticks(0.2:0.2:1);yticks(0.2:0.2:1);zticks(0.2:0.2:1);

clear MAX MIN
end
