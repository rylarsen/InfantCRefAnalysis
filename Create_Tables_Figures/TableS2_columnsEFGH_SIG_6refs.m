% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

%Create Table S2 columns EFGH from Larsen et al, NMR in Biomedicine

clear
close all
load('rlt')

ref_metabolites = {'tNAA','tCr','Cho','Ins','Glx','GSH'};
use_SD_SIG = 'SIG';
calculate_CRef;

tbl = table;
for jj = 1:length(rlt.met_names)
    tbl.met_names{jj} = rlt.met_names{jj}
end

tbl.mean_o = round(rlt.metoMEAN',2);
tbl.sd_o = round(rlt.metoSIG',3);
tbl.cv_o = round((rlt.metoSIG./rlt.metoMEAN)',3);

tbl.mean = round(rlt.metwMEAN',2) %one number for each metabolite.
tbl.sd = round(rlt.metwSIG',3)
tbl.cv = round((rlt.metwSIG./rlt.metwMEAN)',3)

tbl.rat_cv= round(tbl.cv_o./tbl.cv,2)

tbl.w_o = NaN*ones(length(rlt.met_names),1);
tbl.w_x = NaN*ones(length(rlt.met_names),1);

%compare metw vs meto
for jj = 1:length(rlt.met_names)
    x = rlt.metw_CRef_R(:,jj)
    y = rlt.meto_CRef_R(:,jj)
    [r,p] = corrcoef(x,y,'rows','complete');
    tbl.R_met_meto(jj) = round(r(1,2),4);
    tbl.percent_diff(jj) = round(100*nanmean(abs(x-y)./y),1);
    tbl.N(jj) = nnz(~isnan(x.*y));
end

%For GABA, we are going to take the position that calculating R_CRef is not
%of interest for the raw signal because you can't do it with a single
%subject.  Values of RCRef from raw signal are still highly correlated with
%water-scaled data, but that is because the difference and the off
%resonance  share a lot of variance.  Since we want our results to be
%applicable to single subjects, we will ignore gaba whenever we do no water
%scaling.
%
GABAind = find(strcmp(rlt.met_names,'GABA'))
tbl.percent_diff(GABAind) = NaN;

tbl = removevars(tbl,{'mean_o','sd_o','mean','sd'})

%now add information about the relative weights.
%table tbb only contains info about the reference metabolites.

tbb = table;
tbb.sd_o(:,1) = rlt.metoSIG(rlt.my_refs)';
metoHM = 1/mean(1./rlt.metoSIG(rlt.my_refs));
tbb.norm_SD_o(:,1) = round(metoHM./rlt.metoSIG(rlt.my_refs)/length(ref_metabolites)*100,0);

tbb.sd_x(:,1) = rlt.metwSIG(rlt.my_refs)'
metwHM = 1/mean(1./rlt.metwSIG(rlt.my_refs));
tbb.norm_SD_x(:,1) = round(metwHM./rlt.metwSIG(rlt.my_refs)/length(ref_metabolites)*100,0);

tbl.w_o(rlt.my_refs) = tbb.norm_SD_o(:,1);
tbl.w_x(rlt.my_refs) = tbb.norm_SD_x(:,1);

filename = 'TableS2_columnsEFGH_SIG_6refs.xlsx';
fol = fullfile('Results','Tables');
delete(fullfile(fol,filename))
writetable(tbl,fullfile(fol,filename))




