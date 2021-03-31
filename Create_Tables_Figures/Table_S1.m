% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

%Create Table S1 from Larsen et al, NMR in Biomedicine

clear
close all
load('rlt')

tbl = table;
for jj = 1:length(rlt.met_names)
    tbl.met_names{jj} = rlt.met_names{jj};
end

tbl.mean_o = round(rlt.metoMEAN',2);
tbl.sd_o = round(rlt.metoSD',2);
tbl.cv_o = round((rlt.metoSD./rlt.metoMEAN)',2);

tbl.mean = round(rlt.metwMEAN',2) %one number for each metabolite.
tbl.sd = round(rlt.metwSD',2);
tbl.cv = round((rlt.metwSD./rlt.metwMEAN)',2);

tbl.rat_cv= round((rlt.metoSD./rlt.metoMEAN)'./(rlt.metwSD./rlt.metwMEAN)',2);

filename = 'TableS1.xlsx';
fol = fullfile('Results','Tables');
delete(fullfile(fol,filename))
writetable(tbl,fullfile(fol,filename));

