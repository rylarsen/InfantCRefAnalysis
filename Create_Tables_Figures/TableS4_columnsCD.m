% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

%Create Table S4, columns CD from Larsen et al, NMR in Biomedicine


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

tbl.mean_o = round(rlt.metoMEAN',2);
tbl.sd_o = round(rlt.metoSD',3);
tbl.cv_o = round((rlt.metoSD./rlt.metoMEAN)',3);

tbl.mean = round(rlt.metwMEAN',2); %one number for each metabolite.
tbl.sd = round(rlt.metwSD',3);
tbl.cv = round((rlt.metwSD./rlt.metwMEAN)',3);

tbl.range_norm_o = NaN*ones(size(tbl.met_names));
tbl.range_norm_sd_o = NaN*ones(size(tbl.met_names));
tbl.range_norm = NaN*ones(size(tbl.met_names));
tbl.range_norm_sd = NaN*ones(size(tbl.met_names));

refinds = find(ismember(rlt.met_names,ref_metabolites));
av_ref = mean(tbl.mean(refinds));
av_ref_sd = mean(tbl.mean(refinds)./tbl.sd(refinds));
av_ref_o = mean(tbl.mean_o(refinds));
av_ref_sd_o = mean(tbl.mean_o(refinds)./tbl.sd_o(refinds));
for jj = 1:length(refinds)
    pp = refinds(jj);
    %in this approach we don't divide by SD
    myconcs_high = tbl.mean(refinds); %if only using averagers
    myconcs_high(jj) = tbl.mean(pp)+tbl.sd(pp); %raid the MOI of 1 SD
    myconcs_low = tbl.mean(refinds); %if only using averagers
    myconcs_low(jj) = tbl.mean(pp)-tbl.sd(pp); %raid the MOI of 1 SD
    range(jj) = (mean(myconcs_high) - mean(myconcs_low)); %what is the range that the reference can move?
    range_norm(jj) = range(jj)/av_ref; %normalize by average reference
    tbl.range_norm(pp) = round(range_norm(jj)*100,1);
    
    %in this approach we divide by SD
    myconcs_high = tbl.mean(refinds)./tbl.sd(refinds); %if only using averagers
    myconcs_high(jj) = (tbl.mean(pp)+tbl.sd(pp))./tbl.sd(pp); %raid the MOI of 1 SD
    myconcs_low = tbl.mean(refinds)./tbl.sd(refinds); %if only using averagers
    myconcs_low(jj) = (tbl.mean(pp)-tbl.sd(pp))./tbl.sd(pp); %raid the MOI of 1 SD
    range_sd(jj) = (mean(myconcs_high) - mean(myconcs_low)); %what is the range that the reference can move?
    range_norm_sd(jj) = range_sd(jj)/av_ref_sd; %normalize by average reference
    tbl.range_norm_sd(pp) = round(range_norm_sd(jj)*100,1);
    
    %in this approach we don't divide by SD
    myconcs_high = tbl.mean_o(refinds); %if only using averagers
    myconcs_high(jj) = tbl.mean_o(pp)+tbl.sd_o(pp); %raid the MOI of 1 SD
    myconcs_low = tbl.mean_o(refinds); %if only using averagers
    myconcs_low(jj) = tbl.mean_o(pp)-tbl.sd_o(pp); %raid the MOI of 1 SD
    range_o(jj) = (mean(myconcs_high) - mean(myconcs_low)); %what is the range that the reference can move?
    range_norm_o(jj) = range_o(jj)/av_ref_o; %normalize by average reference
    tbl.range_norm_o(pp) = round(range_norm_o(jj)*100,1);
    
    %in this approach we divide by SD
    myconcs_high = tbl.mean_o(refinds)./tbl.sd_o(refinds); %if only using averagers
    myconcs_high(jj) = (tbl.mean_o(pp)+tbl.sd_o(pp))./tbl.sd_o(pp); %raid the MOI of 1 SD
    myconcs_low = tbl.mean_o(refinds)./tbl.sd_o(refinds); %if only using averagers
    myconcs_low(jj) = (tbl.mean_o(pp)-tbl.sd_o(pp))./tbl.sd_o(pp); %raid the MOI of 1 SD
    range_sd_o(jj) = (mean(myconcs_high) - mean(myconcs_low)); %what is the range that the reference can move?
    range_norm_sd_o(jj) = range_sd_o(jj)/av_ref_sd_o; %normalize by average reference
    tbl.range_norm_sd_o(pp) = round(range_norm_sd_o(jj)*100,1);
end

tbl = tbl(refinds,:);
tbl = removevars(tbl,{'mean_o','cv_o','mean','cv'});
tbl = movevars(tbl,'sd','Before','range_norm');

%we are only using the water-scaled values
tbl = removevars(tbl,{'sd','sd_o','range_norm_o','range_norm_sd_o'});

filename = 'TableS4_columnsCD.xlsx';
fol = fullfile('Results','Tables');
delete(fullfile(fol,filename))
writetable(tbl,fullfile(fol,filename))
