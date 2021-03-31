% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

%Create Figure S6A from Larsen et al, NMR in Biomedicine

clear
close all
load('rlt')

ref_metabolites = {'GABA','tNAA','tCr','Cho','Ins','Glx','GSH'};
use_SD_SIG = 'SD';
calculate_CRef;

xs = 260:1:440;% for the fit curve

scalef =0.8;
figure('units','inches','outerposition',[0 0 3 10])

widthw = 2*scalef;
heightw = 1.1*scalef;
stxcrd = 1;
stycrd = 1;

stackmet = [5:-1:1];

C_CRef_plots_inner

script_fol = pwd;
cd(fullfile('Results','Figures'))
print -dtiff  -r600 C_CRef_stack_FigureS6A_1
cd(script_fol)
close all

figure('units','inches','outerposition',[0 0 3 10])

stackmet = [10:-1:6];

C_CRef_plots_inner

script_fol = pwd;
cd(fullfile('Results','Figures'))
print -dtiff  -r600 CRef_stack_FigureS6A_2
cd(script_fol)
clear
