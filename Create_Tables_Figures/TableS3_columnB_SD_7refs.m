% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

%Create Table S3 column B from Larsen et al, NMR in Biomedicine

clear
close all
load('rlt')

ref_metabolites = {'GABA','tNAA','tCr','Cho','Ins','Glx','GSH'};
use_SD_SIG = 'SD';
calculate_CRef;

tbl = table;

for jj = 1:length(rlt.met_names)
    tbl.met_names{jj} = rlt.met_names{jj};
end

tbl.w_x = NaN*ones(length(rlt.met_names),1);

%now add information about the relative weights.
%table tbb only contains info about the reference metabolites.
tbb = table;
tbb.sd_x(:,1) = rlt.metwSD(rlt.my_refs)';
metwHM = 1/mean(1./rlt.metwSD(rlt.my_refs));
tbb.norm_SD_x(:,1) = round(metwHM./rlt.metwSD(rlt.my_refs)/length(ref_metabolites)*100,0);

tbl.w_x(rlt.my_refs) = tbb.norm_SD_x(:,1);

filename = 'TableS3_columnB_SD_7refs.xlsx';
fol = fullfile('Results','Tables');
delete(fullfile(fol,filename))
writetable(tbl,fullfile(fol,filename))

%Save a copy of rlt.metw_CRef_R that can be compared with the 6 metabolite version:
rlt7.metw_CRef_R = rlt.metw_CRef_R;
save('rlt7','rlt7');



