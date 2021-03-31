% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

%Perform triage, corrections, discarding of data.
%Called by run_all_scripts

%Inputs: lcm (assembled data from lcmodel) and t2d (assembled T2 correction
%information)
%Output: The structure rlt, saved in rlt.mat.

clear
close all

load('lcm')
load('t2d')
rlt = lcm;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Eliminate those with no water-scaled data.
noWSs = rlt.metw(:,2)<0.1; %when there is no water-scaling data the absolute values of metabolite concentrations are very low
rlt.metw(noWSs,:) = NaN;
rlt.meto(noWSs,:) = NaN;

%number discarded due to lack of water reference: 
NnoWS = length(find(noWSs));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %eliminate data that have been marked by me as having a bad dif spectrum,
% %so eliminate GABA
GABAno = find(strcmp(rlt.met_names,'GABA'));
rlt.metw(strcmp(rlt.session_fol,'FAM128_1'),GABAno) = NaN;
rlt.metw(strcmp(rlt.session_fol,'FAM057_2'),GABAno) = NaN; 
rlt.meto(strcmp(rlt.session_fol,'FAM128_1'),GABAno) = NaN;
rlt.meto(strcmp(rlt.session_fol,'FAM057_2'),GABAno) = NaN; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%throw out bad spectra that have more than 3 metabolites listed as
%positive outliers in absolute cramer-rao
rlt.cr_abs = rlt.metw.*rlt.sd;
myvotes = zeros(rlt.Nsess,1);
iom = zeros(rlt.Nsess,rlt.Nmets);
for metind = 1:rlt.Nmets
    rlt.session_fol(isoutlier(rlt.cr_abs(:,metind)));
    isout = isoutlier(rlt.cr_abs(:,metind),'quartiles');
    ispos = rlt.cr_abs(:,metind)>nanmedian(rlt.cr_abs(:,metind));
    iom(:,metind) = isout.*ispos;
    rlt.session_fol(find(iom(:,metind)));
end
myvotes = sum(iom,2);
trop_outliers = myvotes>=4;

%scan sessions to be eliminated:
rlt.session_fol(trop_outliers);

rlt.metw(trop_outliers,:) = NaN;
rlt.meto(trop_outliers,:) = NaN;
rlt.cr_abs(trop_outliers,:) = NaN;
rlt.sd(trop_outliers,:) = NaN;
rlt.fwhm_w(trop_outliers,:) = NaN;
rlt.snr_w(trop_outliers,:) = NaN;
rlt.fwhm_o(trop_outliers,:) = NaN;
rlt.snr_o(trop_outliers,:) = NaN;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Evaluate metabolites for fwhm dependence. 
%Shows that GABA has the most FWHM dependence by far.
%evaluate_fwhm_dependence

%correct metabolite signal for FWHM dependence.
fwhm_corr = {'GABA'};

%I could do the FWHM correction for Tau, but I think I won’t because the
%FWHM dependence seems to be driven by a few metabolites of high apparent
%concentration at high FWHM.  When the high FWHM are removed there isn’t dependence on FWHM.   By contrast
%the GABA dependence on FWHM is very consistent and linear.

%now perform a statistical correction for fwhm:
% we will use fwhm from the offset spectrum.  Because it seems to be a better
% estimate of the true fwhm. This is my conclusion from looking at a plot
% of fwhm vs. GABA
[rlt.metw] = fwhm_correction(rlt.metw,rlt.fwhm_w(:,2),rlt.met_names,fwhm_corr);
[rlt.meto] = fwhm_correction(rlt.meto,rlt.fwhm_o(:,2),rlt.met_names,fwhm_corr);

%Now that we have meto and met data in place, we can use their ratio to
%calculate the water signal.
avmets = {'tNAA','tCr','Cho','Ins','Glx','GSH'};
avinds = ismember(rlt.met_names,avmets);
wsig=rlt.meto(:,avinds)./rlt.metw(:,avinds);
rlt.mwsig = nanmean(wsig,2);
rlt.sdwsig = std(wsig,'omitnan');
rlt.raw_water_cvs = rlt.sdwsig./rlt.mwsig;
%very little variance in the estimate of water signal:
nanmean(rlt.raw_water_cvs);
nanmax(rlt.raw_water_cvs);

length(find(~isnan(rlt.fscale)));

%for subjects with outlier values of T2_csf, vf_csf, etc, fscale is not
%valid
[t2d.T2_csf,eliminatedA,~] = outlier_elim_by_visit_iter(t2d.T2_csf,rlt.session);
rlt.fscale(eliminatedA{1}) = NaN; %if T2_csf is outlier, toss fscale

[t2d.vf_csf,eliminatedB,~] = outlier_elim_by_visit_iter(t2d.vf_csf,rlt.session);
rlt.fscale(eliminatedB{1}) = NaN;

[t2d.T2_brn,eliminatedC,~] = outlier_elim_by_visit_iter(t2d.T2_brn,rlt.session);
rlt.fscale(eliminatedC{1}) = NaN;

[t2d.vf_gm,eliminatedD,~] = outlier_elim_by_visit_iter(t2d.vf_gm,rlt.session);
rlt.fscale(eliminatedD{1}) = NaN;

rlt.vf_gm = t2d.vf_gm;
rlt.vf_gm(isnan(rlt.fscale)) = NaN;

rlt.T2_brn = t2d.T2_brn;
rlt.T2_csf = t2d.T2_csf;
rlt.T2_brn(isnan(rlt.fscale)) = NaN;
rlt.T2_csf(isnan(rlt.fscale)) = NaN;
rlt.T2_corr_68(isnan(rlt.fscale)) = NaN;

%list of the scan sessions with eliminate data:
elims = [eliminatedA{1}; eliminatedB{1}; eliminatedC{1}];
rlt.session_fol(sort(elims));

rlt.CrRaoMEAN = nanmean(rlt.sd);

%calculate water scaled and corrected values
rlt.metfw = rlt.metw.*rlt.fscale;

save('rlt','rlt')
clear