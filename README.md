# SeB3R

The SeB3R framework provides a simple framework to analyse DeepLabCut(DLC)-labelled rodent data and perform posture assignment via simple k-means clustering.

There are very few constraints on the dataset, which are discussed below. [Our paper](https://doi.org/10.1101/2022.11.27.518077 ) motivates and applies this framework on an applied use case of whisker nuisance, but any behavioral task is allowed.

## Installation

First, download or clone this repo.

Secondly, **install the [kmeans_opt](https://it.mathworks.com/matlabcentral/fileexchange/65823-kmeans_opt) package**, by either moving its main module or adding it to MATLAB's search path.

## How to use

We provide a whisker nuisance dataset experiment for reference, which motivated our main paper.

1. We start by investigating body postures **on a per-subject basis**. Run `WNAllAnalyses.m`. This will ask you to select your dataset root folder and will perform the analysis itself. This will create a `Clusters` folder inside each subject folder, showing the corresponding frame for each found cluster (e.g. `058/Clusters/C3.csv` contains all frames that matched the third cluster).

2. Next, we assign previously found clusters to body modules (or BM). Run `WNmodulesExtraction`. It will prompt you to provide the number of BM you want. Such number can be arbitrary but we recommend an average of the number of clusters found for each subject.

3. Lastly, re-perform clustering on the newly found BMs. Run `AssignModulesAndQuantify`. TODO: this only works on the first subject.

4. TODO.

### Dataset format

Please make sure your dataset follows the following format:

- a folder contains a list of subjects, arranged in subject folders

- each subject folder follows a purely numeric code, e.g. "123".

- each subject folder contains the same set of evaluating condition, named `${SUBJECT}_{CONDITION}_DLC_3D.csv`, for example [058_OF_DLC_3D.csv](https://github.com/gchelini87/WNt3R/blob/main/WN%20results/058/058_OF_DLC_3D.csv) .. These will be processed in lexicographical order, therefore if you wish to ensure consistent ordering we recommend prefixing them with a number, e.g. "1_Control", "2_ExperimentalCondition" etc.

- Each condition is stored in a CSV matrix as returned by DLC. In particular:

  - Each matrix should have the same header as shown [here](https://github.com/gchelini87/WNt3R/blob/main/WN%20results/058/058_OF_DLC_3D.csv)
  
  - Each matrix should have the same number of frames and tracked body parts. **Warning: currently the number of followed body parts is 6 due to instrumental and visual occlusion limitations**.


# Questions

We understand the instructions above may not be exhaustive. For bug-related questions (e.g crashes), please open an issue, otherwise drop us an email and we will assist you.
