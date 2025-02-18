# [ASAP: An automatic sustained attention prediction method for infants and toddlers using wearable device signals](https://github.com/yisiszhang/ASAP)
## GENERAL INFORMATION

### Authors
Yisi Zhang, A. Priscilla Martinez-Cedillo, Harry T. Mason, Quoc C. Vuong, M. Carmen Garcia-de-Soria, David Mullineaux, Marina Knight, Elena Geangu

Date of data collection: 2021 - 2023

Geographic location of data collection: York, UK

Information about funding sources that supported the collection of the data: Wellcome Leap - The 1kD Program

### SHARING/ACCESS INFORMATION

Links to publications that cite or use the data: Zhang, Yisi Zhang; Martinez-Cedillo, A. Priscilla; Mason, Harry T.; Vuong, Quoc C.; Garcia-de-Soria, M. Carmen; Mullineaux, David; Knight, Marina; Geangu, Elena "ASAP: An automatic sustained attention prediction method for infants and toddlers using wearable device signals"


## DATA & FILE OVERVIEW

### File List: 

model_training_data.mat
This file contains data for training and testing the ASAP model.

model_param_asap.mat
This file contains the ASAP model parameters.

model_prediction_demo.m
This code applies the trained model to predicting attention from the 'model_training_data'-like data.

attention_visual_data.mat
This file contains mean saliency and clutter data during attention and inattention (human-coded and ASAP predicted).

attention_visual_lm.m
This code tests the linear model on attention x visual feature x age.

### Additional related data collected that was not included in the current data package: 
The data was processed from raw ECG, Accelerometer signals, and head-mounted camera videos.

## METHODOLOGICAL INFORMATION

Description of methods used for collection/generation of data: 
The data were collected from 75 infant and toddler participants in the laboratory performing naturalistic tasks and free-play.

Methods for processing the data: 
The ECG signals were converted to heart rate, and the accelerometer signals were converted to magnitude.
Change-point detection was applied to detect the boundaries of abrupt HR change.
Wavelet packet transform was applied to the extracted HR and Acc magnitudes.
Multivariate locally stationary wavelet processes were applied to calculate the local coherence between HR and Acc.
Saliency and clutter were estimated as the mean values of the saliency/clutter map per frame.

Software-specific information needed to interpret the data: 
The data can be accessed using MATLAB.

DATA-SPECIFIC INFORMATION FOR: model_param_asap.mat

This file contains a data structure with fields listed
beta: logistic regression coefficients (post model selection)
lr_thresh: logistic regression threshold
max_duration: maximal duration of attention, used for CP segment merging (in seconds)  
min_duration: minimal duration of attention (in seconds)
min_gap: the minimal gap between segments (in seconds)
segment_frac: minimal percentage of occupancy within a change-point segment to merge
selected_features: selected indices of the original feature data

DATA-SPECIFIC INFORMATION FOR: model_training_data.mat

This file contains a data structure with fields listed
data: a table containing the features (normalised), labels, and session information
sample_rate: the sampling rate of the time series data

DATA-SPECIFIC INFORMATION FOR: attention_visual_data.mat

This file contains a data structure with fields listed
data: a table containing the visual features (normalised), human-coded attention labels, ASAP-predicted attention labels, and age
