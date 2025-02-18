%% ASAP model application
%
% Follow this template to apply the classification model.
% Input data need to be pre-processed based on methods described in the
% article: 
% ASAP: An automatic sustained attention prediction method for 
% infants and toddlers using wearable device signals

%% Important input and output parameters and variables.  
% input:  
%        X - feature data in column-wise orientation (standardised HR and Acc signals)
%        sample_rate - sample rate of the time series  
%        selected_features - selected indices of the original feature data
%        beta - logistic regression coefficients
%        lr_thresh - logistic regression threshold
%        segment_frac - minimal percentage of occupancy within a change-point
%                       segment to merge
%        max_duration - maximal duration of attention, used for CP segment merging (in seconds)  
%        min_duration - minimal duration of attention (in seconds)
%        min_gap - minimal gap between segments (in seconds)
%  
% output:  
%        ypred = glmval(beta,X(:,selected_features),'logit');
%        ypred = ypred>lr_thresh; 
% (C) Yisi Zhang et al., 2024. 
%%
clear
% load the model
load('model_param_asap.mat')
% load the data
load('model_training_data.mat')

% extract features from the data
X = data(:,3:end-2).Variables;
session = data.session;
y = data.attention;
%%
% attention prediction
ypred = glmval(beta,X(:,selected_features),'logit');
ypred = ypred>lr_thresh; 

%%
% refine the point-wise classified attention according to the temporal
% structure
ypred_refine = segmentation_refinement(X, ypred, session, min_gap, min_duration, max_duration, sample_rate, segment_frac);


%%
function ypred_refine = segmentation_refinement(X, ypred, session, min_gap, min_duration, max_duration, sample_rate, segment_frac)
    % segmentation refinement
    unique_sess = unique(session);
    
    % extract the change-point segments
    ypred_cpt = X(:,end);
    ypred_refine = ypred;
    for iu = 1:length(unique_sess)
    
        % extract by sessions
        ypred_sess = ypred(session == unique_sess(iu));
    
        % remove gaps less than min_gap
        on = find(ypred_sess(1:end-1)==0 & ypred_sess(2:end)==1)+1;
        off = find(ypred_sess(1:end-1)==1 & ypred_sess(2:end)==0);
        ind = find(off<on(1));
        off(ind) = [];
        ind = find(on>off(end));
        on(ind) = [];
        gap = on(2:end) - off(1:end-1);
        ind = find(gap<min_gap * sample_rate);
        if ~isempty(ind)
            on(ind+1) = [];
            off(ind) = [];
        end
                        
        ypred_merg_sess = zeros(size(ypred_sess));
        for m = 1:length(on)
            ypred_merg_sess(on(m):off(m)) = 1;
        end
        
        % merge segments within a cp segment
        ypred_cpt_sess = ypred_cpt(session == unique_sess(iu));
        on = find(ypred_cpt_sess(1:end-1)==0 & ypred_cpt_sess(2:end)==1)+1;
        off = find(ypred_cpt_sess(1:end-1)==1 & ypred_cpt_sess(2:end)==0);
        on(on>off(end)) = [];
        off(off<on(1)) = [];
        ypred_merg1 = ypred_merg_sess;
        for m = 1:length(on)
            if off(m)-on(m)+1>=min_duration*sample_rate && off(m)-on(m)+1<max_duration*sample_rate
                segisatt = ypred_merg_sess(on(m) : off(m));
                if sum(segisatt)/(off(m)-on(m)) > segment_frac
                    ypred_merg1(on(m):off(m)) = 1;
                end
            end
        end
    
        % remove attention span shorter than min_duration
        on = find(ypred_merg1(1:end-1)==0 & ypred_merg1(2:end)==1)+1;
        off = find(ypred_merg1(1:end-1)==1 & ypred_merg1(2:end)==0);
        on(on>off(end)) = [];
        off(off<on(1)) = [];
        dur = off - on + 1;
        rmvseg = find(dur<min_duration*sample_rate);
        if ~isempty(rmvseg)
            for m =1:length(rmvseg)
                ypred_merg1(on(rmvseg(m)) : off(rmvseg(m))) = 0;
            end
        end
    
        ypred_refine(session == unique_sess(iu)) = ypred_merg1;
        
    end
end