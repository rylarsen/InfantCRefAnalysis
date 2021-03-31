% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

%Create Figure 6A from Larsen et al, NMR in Biomedicine


clear
close all

%% 7 references

ref_metabolites = {'GABA','tNAA','tCr','Cho','Ins','Glx','GSH'};
use_SD_SIG = 'SD';
calculate_CRef;

qmets = table;
mr_inds = [1:10];

qmets.names = cell(length(mr_inds),1);
qmets.r_raw = NaN*ones(length(mr_inds),1);
qmets.r = NaN*ones(length(mr_inds),1);
qmets.SD_SD = NaN*ones(length(mr_inds),1);

for jj = 1:length(mr_inds)
    mj = mr_inds(jj);    
    qmets.names{jj} = rlt.met_names{mj};
       
    %normalize by total variance
    [r,p]=corrcoef(rlt.metw_CRef(:,mj),rlt.metfw(:,mj),'rows','complete');
    qmets.r_raw(jj) = round(r(1,2),2);
    qmets.CV_raw(jj) = round(rlt.metfwSIG(mj)./rlt.metfwMEAN(mj),3); %SIG/Mean
    
    %normalize by PA-corrected variance, CRef_R_D vs C_WSc_D
    [r,p]=corrcoef(rlt.metw_CRef_D(:,mj),rlt.metfwD(:,mj),'rows','complete');
    qmets.r(jj) = round(r(1,2),2);
    qmets.CV(jj) = round(rlt.metfwCVs(mj),3); %SD/Mean
    
    %deviation, normalize
    devi =(rlt.metw_CRef(:,mj) - rlt.metfw(:,mj))/rlt.metfwSD(mj);
    devi_sd = nanstd(rlt.metw_CRef(:,mj) - rlt.metfw(:,mj));
    qmets.SD_SD(jj) = round(devi_sd/rlt.metfwSD(mj),2);
    
    %remove NaNs
    devi2 = devi(find(~isnan(devi)));
    
    %grap average cramer-rao lower bounds
    qmets.sd(jj) = nanmean(rlt.sd(:,mj));
    
    Ns(jj) = length(find(~isnan(devi)));
    Nsubs(jj) = length(unique(rlt.subnum(find(~isnan(devi)))));
    
end
qmets_7refs = qmets;
plot_CV_vs_R(qmets_7refs,'ks','k');

%% 1 reference

ref_metabolites = {'tCr'};
use_SD_SIG = 'SD';
calculate_CRef;

qmets = table;
mr_inds = [1:3,5:10];
qmets.names = cell(length(mr_inds),1);
qmets.r_raw = NaN*ones(length(mr_inds),1);
qmets.r = NaN*ones(length(mr_inds),1);
qmets.SD_SD = NaN*ones(length(mr_inds),1);
for jj = 1:length(mr_inds)
    mj = mr_inds(jj);    
    qmets.names{jj} = rlt.met_names{mj};
       
    %normalize by total variance
    [r,p]=corrcoef(rlt.metw_CRef(:,mj),rlt.metfw(:,mj),'rows','complete');
    qmets.r_raw(jj) = round(r(1,2),2);
    qmets.CV_raw(jj) = round(rlt.metfwSIG(mj)./rlt.metfwMEAN(mj),3); %SIG/Mean
    
    %normalize by PA-corrected variance, CRef_R_D vs C_WSc_D
    [r,p]=corrcoef(rlt.metw_CRef_D(:,mj),rlt.metfwD(:,mj),'rows','complete');
    qmets.r(jj) = round(r(1,2),2);
    qmets.CV(jj) = round(rlt.metfwCVs(mj),3); %SD/Mean
    
    %deviation, normalize
    devi =(rlt.metw_CRef(:,mj) - rlt.metfw(:,mj))/rlt.metfwSD(mj);
    devi_sd = nanstd(rlt.metw_CRef(:,mj) - rlt.metfw(:,mj));
    qmets.SD_SD(jj) = round(devi_sd/rlt.metfwSD(mj),2);
    
    %remove NaNs
    devi2 = devi(find(~isnan(devi)));
    
    %grap average cramer-rao lower bounds
    qmets.sd(jj) = nanmean(rlt.sd(:,mj));
    
    Ns(jj) = length(find(~isnan(devi)));
    Nsubs(jj) = length(unique(rlt.subnum(find(~isnan(devi)))));
    
end
qmets_1refs = qmets;
plot_CV_vs_R(qmets_1refs,'rx','x');

%% 5 references
ref_metabolites = {'GABA','tNAA','tCr','Cho','GSH'};
use_SD_SIG = 'SD';
calculate_CRef;

qmets = table;
mr_inds = [1:10];
qmets.names = cell(length(mr_inds),1);
qmets.r_raw = NaN*ones(length(mr_inds),1);
qmets.r = NaN*ones(length(mr_inds),1);
qmets.SD_SD = NaN*ones(length(mr_inds),1);
for jj = 1:length(mr_inds)
    mj = mr_inds(jj);    
    qmets.names{jj} = rlt.met_names{mj};
       
    %normalize by total variance
    [r,p]=corrcoef(rlt.metw_CRef(:,mj),rlt.metfw(:,mj),'rows','complete');
    qmets.r_raw(jj) = round(r(1,2),2);
    qmets.CV_raw(jj) = round(rlt.metfwSIG(mj)./rlt.metfwMEAN(mj),3); %SIG/Mean
    
    %normalize by PA-corrected variance, CRef_R_D vs C_WSc_D
    [r,p]=corrcoef(rlt.metw_CRef_D(:,mj),rlt.metfwD(:,mj),'rows','complete');
    qmets.r(jj) = round(r(1,2),2);
    qmets.CV(jj) = round(rlt.metfwCVs(mj),3); %SD/Mean
    
    %deviation, normalize
    devi =(rlt.metw_CRef(:,mj) - rlt.metfw(:,mj))/rlt.metfwSD(mj);
    devi_sd = nanstd(rlt.metw_CRef(:,mj) - rlt.metfw(:,mj));
    qmets.SD_SD(jj) = round(devi_sd/rlt.metfwSD(mj),2);
    
    %remove NaNs
    devi2 = devi(find(~isnan(devi)));
    
    %grap average cramer-rao lower bounds
    qmets.sd(jj) = nanmean(rlt.sd(:,mj));
    
    Ns(jj) = length(find(~isnan(devi)));
    Nsubs(jj) = length(unique(rlt.subnum(find(~isnan(devi)))));
    
end
qmets_1refs = qmets;
plot_CV_vs_R(qmets_1refs,'mo','o');

script_fol = pwd;
cd(fullfile('Results','Figures'))
print -dtiff -r600 Figure6A
cd(script_fol)

