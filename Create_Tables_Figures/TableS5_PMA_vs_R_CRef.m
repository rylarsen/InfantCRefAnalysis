% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

%Create Supplemental Table S5 from Larsen et al, NMR in Biomedicine

clear
close all

ref_metabolites = {'GABA','tNAA','tCr','Cho','Ins','Glx','GSH'};
use_SD_SIG = 'SD';
calculate_CRef;

tbl = table;
tbl.Metabolites = cell(rlt.Nmets,1);
tbl.N_scan_sessions = NaN*ones(rlt.Nmets,1);
tbl.N_u_subs = NaN*ones(rlt.Nmets,1);
tbl.C0 = NaN*ones(rlt.Nmets,1);
tbl.C1 = NaN*ones(rlt.Nmets,1);
tbl.C2 = NaN*ones(rlt.Nmets,1);
tbl.SD = NaN*ones(rlt.Nmets,1);
for jj = 1:rlt.Nmets
    [r,~,~] = find(~isnan(rlt.metw_CRef_R(:,jj)).*~isnan(rlt.GA(:))); %get rid of NaNs
    N_scan_sessions = length(r);
    N_u_subs = length(unique(rlt.subnum(r)));
    ps = rlt.metw_CRef_ps(jj,:);
    
    tbl.Metabolite{jj,1} = rlt.met_names{jj};
    tbl.N_scan_sessions(jj,1) = length(r);
    tbl.N_u_subs(jj,1) = length(unique(rlt.subnum(r)));
    tbl.C0(jj,1) = round(ps(3),2);
    tbl.C1(jj,1) = round(ps(2),2);
    tbl.C2(jj,1) = round(ps(1),3);
    tbl.SD(jj,1) = round(rlt.metw_CRef_SD(jj),3);
end
filename = 'TableS5_PMA_vs_R_CRef.xlsx';
fol = fullfile('Results','Tables');
delete(fullfile(fol,filename))
writetable(tbl,fullfile(fol,filename));

