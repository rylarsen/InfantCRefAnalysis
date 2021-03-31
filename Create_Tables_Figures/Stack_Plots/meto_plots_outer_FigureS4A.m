% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

% Create Figure S4A from Larsen et al, NMR in Biomedicine

clear
close all
load('rlt')

rind = ~isnan(rlt.fscale);
cfac = 35880/55556;

xs = 260:1:440;% for the fit curve

scalef =0.85;

figure('units','inches','outerposition',[0 0 3 10])
widthw = 2*scalef;
heightw = 1.1*scalef;
stxcrd = 1;
stycrd = 1;
stackmet = [5:-1:1];

meto_plots_inner

script_fol = pwd;
cd(fullfile('Results','Figures'))
print -dtiff  -r600 meto_stack_FigureS4A1
cd(script_fol)

close all

figure('units','inches','outerposition',[0 0 3 10])
stackmet = [10:-1:6];

meto_plots_inner

script_fol = pwd;
cd(fullfile('Results','Figures'))
print -dtiff -r600 meto_stack_FigureS4A2
cd(script_fol)
clear
