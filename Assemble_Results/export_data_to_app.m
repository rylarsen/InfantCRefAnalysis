% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

% Export study data to a file that can be read by the app described in the
% publication and the read me files.
% The created files are shared as part of the data set in the "Combined_Data"
% folder at the Illinois Data Bank: https://doi.org/10.13012/B2IDB-3548139_V1

clear
close all

ref_metabolites = {'GABA','tNAA','tCr','Cho','Ins','Glx','GSH'};
use_SD_SIG = 'SD';
calculate_CRef;

load('pathnames');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ald.met_names = rlt.met_names;
ald.metwSD = rlt.metwSD;
ald.metfwSD = rlt.metfwSD;
ald.metfw_ps = rlt.metfw_ps;
ald.mu = rlt.mu;
ald.T2_brn = rlt.T2_brn;
session_fol = rlt.session_fol;

ald.metfwE = rlt.metfwE;
ald.metfw = rlt.metfw;
ald.metw = rlt.metw;
ald.PMA = rlt.GA;

%Calculate the accuracy of C_CRef for predicting C_WSc:
for jj = 1:size(rlt.metfwZ,1)
    offset(jj,1) =   mean(rlt.metw_CRef_Z(jj,:) - rlt.metfwZ(jj,:));  %mean (over metabolites) deviation (C_CRef - C_WSc)
    offset_abs(jj,1) =   abs(mean(rlt.metw_CRef_Z(jj,:) - rlt.metfwZ(jj,:))); %absolute value of the mean deviation
    mresid_crf(jj,1) = mean(abs(rlt.metw_CRef_Z(jj,:) - rlt.metfwZ(jj,:))); %means of the residuals
end

%% Rearrange the order of the datasets:

%First list those with valid off-resonance spectra (183)
naa = isnan(ald.metw(:,2));
[Y ind1] = sort(naa); 
Nsubs = nnz(Y==0); 

ald.metfwE = ald.metfwE(ind1,:);
ald.metfw = ald.metfw(ind1,:);
ald.metw = ald.metw(ind1,:);
ald.PMA = ald.PMA(ind1);
ald.mresid_crf = mresid_crf(ind1);
session_fol = session_fol(ind1);

%remove infants with no data 
ald.metfwE = ald.metfwE(1:Nsubs,:);
ald.metfw = ald.metfw(1:Nsubs,:);
ald.metw = ald.metw(1:Nsubs,:);
ald.PMA = ald.PMA(1:Nsubs);
ald.mresid_crf = ald.mresid_crf(1:Nsubs);
session_fol = session_fol(1:Nsubs);

%reorder again, the two without GABA go at the end
gaba = isnan(ald.metw(:,1));
[Y ind1] = sort(gaba);

ald.metfwE = ald.metfwE(ind1,:);
ald.metfw = ald.metfw(ind1,:);
ald.metw = ald.metw(ind1,:);
ald.PMA = ald.PMA(ind1);
ald.mresid_crf = ald.mresid_crf(ind1);
session_fol = session_fol(ind1);

%reorder again; subjects with true concentration measurements go first
% Highest accuracy of C_CRef goes first.
[Y ind1] = sort(ald.mresid_crf);

ald.metfwE = ald.metfwE(ind1,:);
ald.metfw = ald.metfw(ind1,:);
ald.metw = ald.metw(ind1,:);
ald.PMA = ald.PMA(ind1);
ald.mresid_crf = ald.mresid_crf(ind1);
session_fol = session_fol(ind1);
save(fullfile('Results','Summary_Data','App_data'),'ald');

%save a spreadsheet relating subject numbers in app to the session names.
ctbl = table;
ctbl.nums = [1:183]';
ctbl.session_fol = session_fol;
ctbl.Properties.VariableNames = {'App number';'scan_session'};
delete(fullfile('Results','Summary_Data','App_Subject_Key.xlsx'));
writetable(ctbl,fullfile('Results','Summary_Data','App_Subject_Key.xlsx'));
