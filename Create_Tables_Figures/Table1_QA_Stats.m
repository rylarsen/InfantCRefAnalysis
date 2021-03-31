% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

%create Table 1 of Larsen et al, NMR in Biomedicine

clear
load('pathnames')

%create a table showing some basic stats on discarded averages.

%Read in QA stats for each scan session
ab = dir(fullfile(pathnames.MRS_data_fol,'FAM*'));
qa_av = table;
qa_av.no_scans = NaN*ones(length(ab),1);
qa_av.navg = NaN*ones(length(ab),1);
qa_av.nbad_unlike = NaN*ones(length(ab),1);
qa_av.nsd = NaN*ones(length(ab),1);

for jj = 1:length(ab)
   load(fullfile(pathnames.MRS_data_fol,ab(jj).name,'Raw_and_Preprocessed','Results_FID-A'));
   qa_av.no_scans(jj) = qa_params.no_scans; %number of acquisitoins
   qa_av.navg(jj) = qa_params.nAvgTotal1; %total number of spectra acquired.
   qa_av.nbad_unlike(jj) = qa_params.nBadAvgTotal1;  %number of spectra removed due to non-likeness issues
   qa_av.nsd(jj) = params.nsd1; %# standard deviations from unlikeness metric
end

%navg and nbad_unlike are in units of # of spectra, where there are 2
%spectra per acquision.  Convert to # of acquisitions
qa_av.navg = qa_av.navg/2;
qa_av.nbad_unlike = qa_av.nbad_unlike/2;

%calculate number removed due to drift.
qa_av.nbad_drift = qa_av.navg - qa_av.no_scans - qa_av.nbad_unlike;

%some basic numbers that were included in the paper related to the
%unlikeness threshold.
length(find(qa_av.nsd==3.2));
qa_av.nsd(find(qa_av.nsd~=3.2));

%make a table of parameters related to QA:
Available = [min(qa_av.navg); max(qa_av.navg); round(mean(qa_av.navg),1); median(qa_av.navg)];
Unlike = [min(qa_av.nbad_unlike); max(qa_av.nbad_unlike); round(mean(qa_av.nbad_unlike),1); median(qa_av.nbad_unlike)];
Drift = [min(qa_av.nbad_drift); max(qa_av.nbad_drift); round(mean(qa_av.nbad_drift),1); median(qa_av.nbad_drift)];
Numscans = [min(qa_av.no_scans); max(qa_av.no_scans); round(mean(qa_av.no_scans),1); median(qa_av.no_scans)];

%add SNR and fwhm:
load('rlt')

%diff:
snr_w_dif = [min(rlt.snr_w(:,1)); max(rlt.snr_w(:,1)); round(nanmean(rlt.snr_w(:,1)),1); nanmedian(rlt.snr_w(:,1))];
fwhm_w_dif = [min(rlt.fwhm_w(:,1)); max(rlt.fwhm_w(:,1)); round(nanmean(rlt.fwhm_w(:,1)),3); nanmedian(rlt.fwhm_w(:,1))];

%off res:
snr_w_off = [min(rlt.snr_w(:,2)); max(rlt.snr_w(:,2)); round(nanmean(rlt.snr_w(:,2)),1); nanmedian(rlt.snr_w(:,2))];
fwhm_w_off = [min(rlt.fwhm_w(:,2)); max(rlt.fwhm_w(:,2)); round(nanmean(rlt.fwhm_w(:,2)),3); nanmedian(rlt.fwhm_w(:,2))];

stats = table(Available, Unlike, Drift, Numscans,snr_w_dif,snr_w_off,fwhm_w_dif,fwhm_w_off);

filename = 'Table1_QA_Stats.xlsx';
fol = fullfile('Results','Tables');
delete(fullfile(fol,filename))
writetable(stats,fullfile(fol,filename))