% %% ASAP visual features
%
% Input data were processed based on the article: 
% ASAP: An automatic sustained attention prediction method for 
% infants and toddlers using wearable device signals

%% Important input and output parameters and variables.  
% input:  
%        data - table containing mean saliency (normalised), clutter (normalised), 
%        attention, data source, and age
%        data.Attention - binary encoding inattention (0) and attention (1)
%        states
%        data.Source - data source from human-coding (0) and ASAP prediction (1) 
%  
% output:  
%        mdl = fitglm(data, formula);

% (C) Yisi Zhang et al., 2024. 

%%
clear
load('attention_visual_data.mat')

formula = 'Saliency ~ Attention * Source * Age';
mdl1 = fitglm(data, formula)

formula = 'Clutter ~ Attention * Source * Age';
mdl2 = fitglm(data, formula)