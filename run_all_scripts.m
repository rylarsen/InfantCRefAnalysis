% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

%These scripts can be used to reproduce all tables and figures from the
%following paper:

%Larsen,  RJ, et. al. "Quantification of Magnetic Resonance Spectroscopy data
%using a combined reference: Application in typically developing infants"
%in NMR in Biomedicine, 2021.

%These scripts require the original data, available at the Illinois Data
%Bank:  https://doi.org/10.13012/B2IDB-3548139_V1

%All tables and figures can be created simply by running this script. To do
%this, assign the variable "pathnames.MRS_data_fol" as the directory that
%contains the "Individual_Data" directory from the Illinois Data Bank. Then
%specify the variable "pathnames.Subject_data_fol" as the director that
%contains the "Combined_Data" directory from the Illinois Data Bank. Open
%the Matlab project, InfantCRefAnalysis.prj The active directory of Matlab
%should be the project directory, InfantCRefAnalysis, where this script
%resides.

%The files produced by the script are output to the "Results" directory,
%within the project directory, InfantCRefAnalysis.
%These scripts have been tested for Windows 10, Matlab 2020a.  
 
pathnames.MRS_data_fol = 'P:\Individual_Data';
pathnames.Subject_data_fol = 'P:\Combined_Data';
save('pathnames','pathnames')

%Make directories where the Results will reside
mkdir('Results')
mkdir(fullfile('Results','Tables'))
mkdir(fullfile('Results','Figures'))
mkdir(fullfile('Results','Summary_Data'))

% %read in metabolite signals and T2 data
create_lcm
%  
%quality control and triage of the data:
create_rlt

%calculate the PMA dependence of C_WS, water-scaled, non-corrected (metw).
metw_change_PMA 

%calculate the PMA dependence of C_WSc, water-scaled corrected, (metfw).
metfw_change_PMA  %creates TableS6

%calculate the PMA dependence of raw signal, S, values (meto).
meto_change_PMA 

%characterize the PMA-dependence of the raw water signal:
wat_change_PMA

%this prepares the structure that contains data needed for the single
%subject calculations (including the app).
export_data_to_app

%this prepares a spreadsheet of the data from lcmodel
export_spreadsheet

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plots and Tables in the NMR Biomed article:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Tables in publication
% Table 1: Show QA parameters from spectral analysis.
Table1_QA_Stats
% Table 3: Compare R_CRef calculated from water-scaled vs. non-water-scaled data.
Table3
% Table 4: Compare the combined reference signal to the corrected water signal.
Figure5_Table4_TablesS7_S8
% Table 5: Evaluate the accuracy of C_CRef in predicting C_WSc
Table5
% Table 6: Stats on PMA vs. C_WSc
Table6

%% Figures in publication

% Figure 3A,Stackplots, R_CRef:
R_CRef_plots_outer_Figure3A
% Figure 3B, Stackplots, CWSc:
metfw_plots_outer_Figure3B

%PMA dependence of the relaxation and partial volume
%corrections to the water signal
Figure4

%compare metabolite reference signals with water reference signals
Figure5_Table4_TablesS7_S8

%compare numerical consistency of C_CRef with C_WSc
Figure6A
Figure6B

%% Tables and Figures in Supporting Materials

% Compare CV values from raw and water-scaled
Table_S1

% w factors without removing PMA-dependence variance 
TableS2_columnsEFGH_SIG_6refs 

%Compare w factors from water-scale data using 6 vs. 7 reference.
TableS3_columnA_SD_6refs 
TableS3_columnB_SD_7refs % table showing weights for 7 reference, when using water-scaling.
TableS3_columnC_SD %correlate 6 refs vs 7 refs

% Demonstrate that when weighting factors are not used, the reference is
% biased towards metabolites of greatest variance.
TableS4_columnsAB
TableS4_columnsCD

% %demonstrate that metabolites that show the greatest reduction in CV when
% %water scaling is performed exhibit greater correlations of raw metabolite
% %signal with the water signal
Figure_S5

%PMA-dependence of R_CRef and C_CRef
TableS5_PMA_vs_R_CRef
TableS9_PMA_vs_C_CRef
%(TableS6 created by: metfw_change_PMA)

%compare metabolite reference signals with water reference signals
Figure5_Table4_TablesS7_S8

%compare numerical consistency of C_CRef with C_WSc
Figure6A
Table5
TableS10_columnsDEF
TableS10_columnsGHI
 
% Stackplots, CWSc:
metfw_plots_outer_Figure3B

% Stackplots, raw signal:
meto_plots_outer_FigureS4A

% Stackplots, R_CRef:
R_CRef_plots_outer_Figure3A

% Stackplots, water-scaled signal, A:
metw_plots_outer_FigureS4B

% Stackplots, C_CRef
C_CRef_plots_outer_FigureS6A

