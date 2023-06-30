# SEB3R: Stimulus-Evoked Behavioural Tracking for Rodents

The SeB3R framework allows you to automate and standardize ethologically-driven observations of mice in freely-moving scenarios.

In short, it allows for automatic between- and within-groups posture and body module labelling of mice data starting from already-tracked frames; this is accomplished through a 2-step k-means clustering: from the 3D position of the mice skeleton we identify N subject-specific behavioural clusters. After some analysis, the user can reforce the analysis to make all subjects be reclassified on a constant K number of behavioural modules, and obtain tagged frame data that can be superimposed to the original dataset.

There are very few constraints on the dataset, which are discussed below. [Our paper](https://doi.org/10.1101/2022.11.27.518077 ) motivates and applies this framework on an applied use case of whisker nuisance, but any behavioral task is allowed.

**NOTE**: tracking goes beyond the scope of this tool. We recommend DeepLabCut for this task, and also urge you to follow the dataset specifications below.

## Installation

First, download or clone this repo.

Secondly, **install the [kmeans_opt](https://it.mathworks.com/matlabcentral/fileexchange/65823-kmeans_opt) package**, by either moving its main module or adding it to MATLAB's search path.

## How to use

We provide a whisker nuisance dataset experiment for reference. To run the analysis, you can either:

- run `SEB3R.m`, which will automatically call the modules mentioned below, or
- run in order `PoseExtraction.m`, `ModulesExtraction.m`, `AssignModulesAndQuantify.m`, `SequenceDuration.m` (**NEW**). **This is recommended**, as it requires you to *think* about how many body modules you want.

This is a breakdown of what each step entails:

1. We start by investigating body postures **on a per-subject basis**. Run `PoseExtraction.m`. This will ask you to select your dataset root folder and will perform the analysis itself, and subsequently create a `Clusters` folder inside each subject folder, showing the corresponding frame for each found cluster (e.g. `058/Clusters/C3.csv` contains all frames that matched the third cluster).

2. Next, we assign previously found clusters to body modules (or BM). Run `ModulesExtraction.m`. It will prompt the user to provide the number of wished BMs, and then the dataset folder again (TODO in the `SEB3R.m` script this could be passed as a parameter?). Such number can be arbitrary but we recommend taking into account the cohort cluster distribution first. Refer to the module for details.

3. Lastly, re-perform clustering on the newly found BMs. Run `AssignModulesAndQuantify.m`.

4. Optionally, extract the sequence length for each body module of interest. After being propmted a directory for the dataset of interest, it will create a directory
containing all sequencing grouped by experimental condition.

### Dataset format

Please make sure your dataset follows the following format:

- A folder contains a list of subjects, arranged in subject folders.

- Each subject folder follows a purely numeric code, e.g. "123" or "007"; note that "007" and "7" are distinct.

- Each subject folder contains the same set of evaluating condition, named `${SUBJECT}_{CONDITION}_DLC_3D.csv`, for example [058_OF_DLC_3D.csv](https://github.com/gchelini87/SEB3R/blob/main/WN%20results/058/058_OF_DLC_3D.csv). These will be processed in lexicographical order, therefore if you wish to ensure consistent ordering we recommend prefixing them with a number, e.g. `1_Control`, `2_ExperimentalCondition` etc.

- Each condition is stored in a CSV matrix as returned by DLC. In particular:

  - Each matrix should have the same header as shown [here](https://github.com/gchelini87/SEB3R/blob/main/WN%20results/058/058_OF_DLC_3D.csv)
  
  - Each matrix should have the same number of frames and tracked body parts. **Warning: currently the number of followed body parts is 6 due to instrumental and visual occlusion limitations**. This may change in future releases!


# Questions

We understand the instructions above may not be exhaustive. For bug-related questions (e.g crashes), please open an issue, otherwise drop us an email and we will assist you.
