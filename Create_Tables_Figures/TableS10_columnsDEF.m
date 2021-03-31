% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

%Create Table S10 columns DEF from Larsen et al, NMR in Biomedicine

clear
close all

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
    
    %normalize by PA-corrected variance, CRef_R_D vs C_WSc_D
    [r,p]=corrcoef(rlt.metw_CRef_D(:,mj),rlt.metfwD(:,mj),'rows','complete');
    qmets.r(jj) = round(r(1,2),2);

    %deviation, normalize
    devi =(rlt.metw_CRef(:,mj) - rlt.metfw(:,mj))/rlt.metfwSD(mj);
    devi_sd = nanstd(rlt.metw_CRef(:,mj) - rlt.metfw(:,mj));
    qmets.SD_SD(jj) = round(devi_sd/rlt.metfwSD(mj),2);
    
    Ns(jj) = length(find(~isnan(devi)));
    Nsubs(jj) = length(unique(rlt.subnum(find(~isnan(devi)))));
    
end

filename = 'TableS10_columnsGHI.xlsx';
fol = fullfile('Results','Tables');
delete(fullfile(fol,filename))
writetable(qmets,fullfile(fol,filename));