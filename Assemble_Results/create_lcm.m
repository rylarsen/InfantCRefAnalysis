clear
close all

% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

%Read in the MRS data from LCModel.
%Called by run_all_scripts
 
%Output:  lcm contains metabolite data from lcmodel, t2d contains variables
%used to correct the water-scaled data.

load('pathnames') %locations of the combined and individual data.  Set and saved in run_all_scripts 

%metabolties to be extracted from LCModel
met_names = {'GABA','tNAA','NAA','tCr','Cho','Ins','Glx','Glu','GSH','Tau'}; 

%Labels used by LCmodel 
labels = {'GABA','NAA+NAAG','NAA','Cr+PCr','GPC+PCh','Ins','Glu+Gln','Glu','GSH','Tau'};

%reality check: 
if length(met_names) ~= length(labels)
    error('label lengths arent consistent!')
end

%Difference raw scale factor, so that the arbitrary scale values are close to 1.
diff_raw_scale = 1E8;
%off res raw scale factor, so that the arbitrary scale values are close to 1.
off_raw_scale = 1E3;

% Make a list of available scan sessions: fns_fam
af = dir(fullfile(pathnames.MRS_data_fol,'FAM*'));
Nsess = length(af);
for jj = 1:length(af)
    fns_fam{jj} = af(jj).name;
end


%% Import Subjectdata
Subjectdata_file = fullfile(pathnames.Subject_data_fol,'Subject_data.xlsx');

%Setup the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 6);
% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A2:F141";
% Specify column names and types
opts.VariableNames = ["SubjectID", "Sex", "PMAscan1", "PMAscan2", "Agescan1", "Agescan2"];
opts.VariableTypes = ["string", "categorical", "double", "double", "double", "double"];
% Specify variable properties
opts = setvaropts(opts, "SubjectID", "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["SubjectID", "Sex"], "EmptyFieldRule", "auto");
% Import the data
Subjectdata = readtable(Subjectdata_file, opts, "UseExcel", false);
clear opts


%% Import scan session data from LCModel and T2 analysis
load(fullfile(pathnames.Subject_data_fol,'T2_combined_data')); %imported combined T2 data from all scan sessions
PD_info_file='T2_individual_results'; %this is the name of the file for each subject that contains the T2 information.

%insert metaboltie names into lcm structure
lcm.met_names = met_names;
lcm.Nmets = length(met_names);

%%%%%%%%%%%%%%%%%%%%%%
%Initialize variables in the lcm structure
lcm.subnum = cell(Nsess,1);
lcm.session = NaN*ones(Nsess,1);
lcm.session_fol= cell(Nsess,1);
lcm.GA = NaN*ones(Nsess,1);
lcm.Ages = NaN*ones(Nsess,1);
lcm.fscale= NaN*ones(Nsess,1); %correction factor:  CWSc = CWS*fscale
lcm.metw = NaN*ones(Nsess,lcm.Nmets); %water-scaled, non-corrected
lcm.meto = NaN*ones(Nsess,lcm.Nmets); %raw signal, non-water-scaled
lcm.metfw = NaN*ones(Nsess,lcm.Nmets); %water-scaled, corrected
lcm.sd = NaN*ones(Nsess,lcm.Nmets); %cramer-rao lower bounds.
lcm.fwhm_w = NaN*ones(Nsess,2);
lcm.snr_w = NaN*ones(Nsess,2);
lcm.fwhm_o = NaN*ones(Nsess,2);
lcm.snr_o = NaN*ones(Nsess,2);
lcm.max_resid_csf= NaN*ones(Nsess,1);
t2d.vf_csf= NaN*ones(Nsess,1);
t2d.vf_gm= NaN*ones(Nsess,1);
t2d.T2_brn= NaN*ones(Nsess,1);
t2d.T2_csf= NaN*ones(Nsess,1);

% compare water scaling with CRef:
%first we re-ran the data through LCModel without water scaling.
%this was done by rerun_no_WS.
load_wo_NWS

%now read in the water-scaled signal.
for subjectindex = 1:Nsess
    session_fol = fns_fam{subjectindex}; %Scan session Identifier
    subnum = session_fol(1:6); %Subject number
    session = str2double(session_fol(8));  %Session type (1 month vs 3 month)
    
    %include postmenstrual age data in lcm
    if session == 1
        lcm.GA(subjectindex,1) = Subjectdata.PMAscan1(strcmp(Subjectdata.SubjectID,subnum));
        lcm.Ages(subjectindex,1) = Subjectdata.Agescan1(strcmp(Subjectdata.SubjectID,subnum));
    elseif session ==2
        lcm.GA(subjectindex,1) = Subjectdata.PMAscan2(strcmp(Subjectdata.SubjectID,subnum));
        lcm.Ages(subjectindex,1) = Subjectdata.Agescan2(strcmp(Subjectdata.SubjectID,subnum));
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %now calculate fscale:
    if ismember(session_fol,subj_fols_good)
        t2_data_path=fullfile(pathnames.MRS_data_fol,session_fol,'T2_data');
        tpd = load(fullfile(t2_data_path,PD_info_file));
        lcm.fscale(subjectindex,1) =  1/tpd.vf_gm/tpd.T2_corr_68; %this factor multiples metw, or C_WS, to give metfw, or C_WSc
        lcm.T2_corr_68(subjectindex,1) = tpd.T2_corr_68;
        t2d.vf_csf(subjectindex,1) = tpd.vf_csf;
        t2d.vf_gm(subjectindex,1) = tpd.vf_gm;
        t2d.T2_brn(subjectindex,1) = tpd.T2_brn;
        t2d.T2_csf(subjectindex,1) = tpd.T2_csf;
        clear tpd
    end
    
    %load metabolite values from difference spectrum
    spectroscopy_data_path=fullfile(pathnames.MRS_data_fol,session_fol,'LCmodel_Results_Water_Scaled','Difference');
    ag = dir(fullfile(spectroscopy_data_path,'t*'));
    info_dif = mrs_readLcmodelTABLE(fullfile(spectroscopy_data_path,ag(1).name));
    
    %QA information from the difference spectrum.
    read_fwhm_bch
    lcm.fwhm_w(subjectindex,1) = fwhm;
    lcm.snr_w(subjectindex,1) = snr;
    
    %load metabolite values from the off-resonance spectrum
    spectroscopy_data_path=fullfile(pathnames.MRS_data_fol,session_fol,'LCmodel_Results_Water_Scaled','Off_Resonance');
    ag = dir(fullfile(spectroscopy_data_path,'t*'));
    info = mrs_readLcmodelTABLE(fullfile(spectroscopy_data_path,ag(1).name));
    
    %QA information from the off-resonance spectrum.
    read_fwhm_bch
    lcm.fwhm_w(subjectindex,2) = fwhm;
    lcm.snr_w(subjectindex,2) = snr;
        
    %%%metabolite information into the lcm structure
    %LCModel was run with default settings for water concentration (35880) and
    %water relaxation (0.7). We replace water concentration with 55556
    %and water relaxation with 1. 
    attenuation_h20_old = 0.7; %default from LCModel
    h20_concentration_old  = 35880;  %default from LCModel
    
    ii = 1;
    lcm.metw(subjectindex,ii)= info_dif.concentration(strcmp(info_dif.name,labels(ii)))*55556/h20_concentration_old/attenuation_h20_old;
    lcm.sd(subjectindex,ii)= info_dif.SDpct(strcmp(info_dif.name,labels(ii)));    
    for ii = 2:size(met_names,2)  %loop through the metabolites.
        lcm.metw(subjectindex,ii)= info.concentration(strcmp(info.name,labels(ii)))*55556/h20_concentration_old/attenuation_h20_old;
        lcm.sd(subjectindex,ii)= info.SDpct(strcmp(info.name,labels(ii)));
    end
end
lcm.Nsess = Nsess;
lcm.labels = labels;

%add sex to lcm structure. 
lcm.sex = categorical(Subjectdata.Sex);

save('lcm','lcm')
save('t2d','t2d')
clear