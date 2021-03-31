% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

%Create Table 3 from Larsen et al, NMR in Biomedicine

clear
close all
load('rlt')

ref_metabolites = {'tNAA','tCr','Cho','Ins','Glx','GSH'};
use_SD_SIG = 'SD';
calculate_CRef;

tbl = table;
for jj = 1:length(rlt.met_names)
    tbl.met_names{jj} = rlt.met_names{jj};
end

tbl.mean_o = round(rlt.metoMEAN',2);
tbl.sd_o = round(rlt.metoSD',3);
tbl.cv_o = round((rlt.metoSD./rlt.metoMEAN)',3);

tbl.mean = round(rlt.metwMEAN',2);
tbl.sd = round(rlt.metwSD',3);
tbl.cv = round((rlt.metwSD./rlt.metwMEAN)',3);

tbl.rat_cv= round(tbl.cv_o./tbl.cv,2);

tbl.w_o = NaN*ones(length(rlt.met_names),1);
tbl.w_x = NaN*ones(length(rlt.met_names),1);

%compare metw vs meto
for jj = 1:length(rlt.met_names)
    x = rlt.metw_CRef_R(:,jj);
    y = rlt.meto_CRef_R(:,jj);
    [r,p] = corrcoef(x,y,'rows','complete');
    tbl.R_met_meto(jj) = round(r(1,2),4);
    tbl.percent_diff(jj) = round(100*nanmean(abs(x-y)./y),1);
    tbl.N(jj) = nnz(~isnan(x.*y));
end

%
GABAind = find(strcmp(rlt.met_names,'GABA'));
tbl.percent_diff(GABAind) = NaN;

tbl = removevars(tbl,{'mean_o','sd_o','mean','sd'});

%now add information about the relative weights.
%table tbb only contains info about the reference metabolites.
tbb = table;
tbb.sd_o(:,1) = rlt.metoSD(rlt.my_refs)';
metoHM = 1/mean(1./rlt.metoSD(rlt.my_refs));
tbb.norm_SD_o(:,1) = round(metoHM./rlt.metoSD(rlt.my_refs)/length(ref_metabolites)*100,0);

tbb.sd_x(:,1) = rlt.metwSD(rlt.my_refs)';
metxHM = 1/mean(1./rlt.metwSD(rlt.my_refs));
tbb.norm_SD_x(:,1) = round(metxHM./rlt.metwSD(rlt.my_refs)/length(ref_metabolites)*100,0);

tbl.w_o(rlt.my_refs) = tbb.norm_SD_o(:,1);
tbl.w_x(rlt.my_refs) = tbb.norm_SD_x(:,1);

%Make Table 3:

filename = 'Table3.xlsx';
fol = fullfile('Results','Tables');
delete(fullfile(fol,filename))
writetable(tbl,fullfile(fol,filename));



