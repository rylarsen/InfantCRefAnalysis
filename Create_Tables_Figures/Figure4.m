% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

%Create Figure 4 from Larsen et al, NMR in Biomedicine

%Figure 4 shows the PMA dependence of the relaxation and partial volume
%corrections to the water signal

clear
close all
load('rlt')

axis_font = 10;
label_font = 12;
msize = 3;
lwidth = 0.5;
awidth = 0.8;

figure(1)
subplot(2,2,3)
plot(rlt.GA*12/365.25,1./rlt.T2_corr_68,'ks','markersize',msize,'linewidth',lwidth)
set(gca,'YMinorTick','on')
set(gca,'XMinorTick','on')
hold on;

myvars = rlt.GA.*rlt.T2_corr_68;
Ns = length(find(~isnan(myvars )));
Nsubs = length(unique(rlt.subnum(find(~isnan(myvars )))));

set(gca,'TickLength',[0.03 0.03]);
set(gca,'Fontsize',axis_font,'linewidth',awidth);
xlim([260 440]*12/365.25);
set(gca,'color','w');
xlabel('PMA (months)','fontsize',label_font)
ylabel('R_W','fontsize',label_font)

subplot(2,2,1)
plot(rlt.GA*12/365.25,rlt.T2_brn,'ks','markersize',msize,'linewidth',lwidth)
set(gca,'YMinorTick','on')
set(gca,'XMinorTick','on')
hold on;

myvars = rlt.GA.*rlt.T2_brn;
Ns = length(find(~isnan(myvars )));
Nsubs = length(unique(rlt.subnum(find(~isnan(myvars )))));

set(gca,'TickLength',[0.03 0.03]);
set(gca,'Fontsize',axis_font,'linewidth',awidth);
xlim([260 440]*12/365.25)
set(gca,'color','w');
xlabel('PMA (months)','fontsize',label_font)
ylabel('T2_{brn}','fontsize',label_font)

subplot(2,2,2)
plot(rlt.GA*12/365.25,rlt.T2_csf,'ks','markersize',msize,'linewidth',lwidth)
set(gca,'YMinorTick','on')
set(gca,'XMinorTick','on')
hold on;

myvars = rlt.GA.*rlt.T2_csf;
Ns = length(find(~isnan(myvars )));
Nsubs = length(unique(rlt.subnum(find(~isnan(myvars )))));

set(gca,'TickLength',[0.03 0.03]);
set(gca,'Fontsize',axis_font,'linewidth',awidth);
xlim([260 440]*12/365.25);
set(gca,'color','w');
xlabel('PMA (months)','fontsize',label_font)
ylabel('T2_{csf}','fontsize',label_font)

subplot(2,2,4)
plot(rlt.GA*12/365.25,rlt.vf_gm,'ks','markersize',msize,'linewidth',lwidth)
set(gca,'YMinorTick','on')
set(gca,'XMinorTick','on')
hold on;

myvars = rlt.GA.*rlt.vf_gm;
Ns = length(find(~isnan(myvars )));
Nsubs = length(unique(rlt.subnum(find(~isnan(myvars )))));

set(gca,'TickLength',[0.03 0.03]);
set(gca,'Fontsize',axis_font,'linewidth',awidth);
xlim([260 440]*12/365.25)
set(gca,'color','w');
xlabel('PMA (months)','fontsize',label_font)
ylabel('f_{Br}','fontsize',label_font)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
script_fol = pwd;
cd(fullfile('Results','Figures'))
print -dtiff -r600 'Figure4.tif'
cd(script_fol)
