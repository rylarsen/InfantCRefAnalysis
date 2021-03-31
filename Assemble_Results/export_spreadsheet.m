% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

% Export study data to a file that summarizes the study data.  
% The created file is shared as part of the data set in the "Combined_Data"
% folder at the Illinois Data Bank: https://doi.org/10.13012/B2IDB-3548139_V1

clear
load('rlt')

tbl = table;
tbl.session_fol = rlt.session_fol;
tbl.meto =rlt.meto;
tbl = splitvars(tbl,'meto','NewVariableNames',strcat(rlt.met_names,'_raw'));
tbl.metw = rlt.metw;
tbl = splitvars(tbl,'metw','NewVariableNames',strcat(rlt.met_names,'_WS'));
tbl.metfw =rlt.metfw;
tbl = splitvars(tbl,'metfw','NewVariableNames',strcat(rlt.met_names,'_WSc'));
tbl.T2_corr_68 =rlt.T2_corr_68;
tbl.vf_gm=rlt.vf_gm;
tbl.T2_brn=rlt.T2_brn;
tbl.T2_csf=rlt.T2_csf;
tbl.mwsig=rlt.mwsig;
delete(fullfile('Results','Summary_Data','Scan_session_data.xlsx'))
writetable(tbl,fullfile('Results','Summary_Data','Scan_session_data.xlsx'))
