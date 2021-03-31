% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

%Create Table S3 column C from Larsen et al, NMR in Biomedicine

clear
close all
load('rlt6')
load('rlt7')
load('rlt')

tbl = table;

for jj = 1:length(rlt.met_names)
    tbl.met_names{jj} = rlt.met_names{jj};
end

for jj = 1:length(rlt.met_names)
    x = rlt6.metw_CRef_R(:,jj);
    y = rlt7.metw_CRef_R(:,jj);
    [r,p] = corrcoef(x,y,'rows','complete');
    tbl.R_met_meto(jj) = round(r(1,2),4);
    tbl.percent_diff(jj) = round(100*nanmean((x-y)./y),1);
    tbl.N(jj) = nnz(~isnan(x.*y));    
end

filename = 'TableS3_columnC_SD.xlsx';
fol = fullfile('Results','Tables');
delete(fullfile(fol,filename))
writetable(tbl,fullfile(fol,filename))