% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

%Create Supplemental Figure S5 from Larsen et al, NMR in Biomedicine

% Demonstrate why some metabolites show greater reductions
% of CV than others when water scaling is performed.  It turns out the
% magnitude of the reduction in variance is greater when the metabolite raw
% signal is more highly correlated with the water signal.  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PMA-controled metabolite values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
close all
load('rlt')


ref_metabolites = {'GABA','tNAA','tCr','Cho','Ins','Glx','GSH'};
my_refs = ismember(rlt.met_names,ref_metabolites);

tbl = table;

for jj = 1:rlt.Nmets
    [r,p] = corrcoef(rlt.metoZ(:,jj),rlt.mwsigZ,'rows','complete');
    %[r,p] =
    %corrcoef(rlt.meto(:,jj),rlt.mwsig./rlt.fscale,'rows','complete'); %in
    %case you want to look at the correction
    tbl.rs(jj) = r(1,2);
end

for jj = 1:length(rlt.met_names)
    tbl.names{jj} = rlt.met_names{jj};
end

tbl.mean_o = round(rlt.metoMEAN',2);
tbl.sd_o = round(rlt.metoSD',3);
tbl.cv_o = round((rlt.metoSD./rlt.metoMEAN)',3);

tbl.mean = round(rlt.metwMEAN',2); %one number for each metabolite.
tbl.sd = round(rlt.metwSD',3);
tbl.cv = round((rlt.metwSD./rlt.metwMEAN)',3);

tbl.rat_cv= round(tbl.cv_o./tbl.cv,2);
tbl.CrRaoMEAN=rlt.CrRaoMEAN';

figure(2)
plot(tbl.rs,tbl.rat_cv,'ks')
set(gca,'YMinorTick','on')
set(gca,'XMinorTick','on')
hold on;
zoff = 0.03+zeros(size(tbl.names));
%zoff = choose_zoff_SD_rat_CV(tbl);
for jj = 1:length(tbl.names)
    text(tbl.rs(jj)-0.0012,tbl.rat_cv(jj)-zoff(jj),strcat('\uparrow',tbl.names{jj}),'fontsize',13,'color','k');
end

xlabel(strcat('Pearson R, S_D vs. W_D'),'fontsize',16)
ylabel(strcat('CV_S/CV_A'),'fontsize',16)
ylim([1.7 3.2]);
xlim([0.82 0.96]);

set(gca,'TickLength',[0.03 0.03])
set(gca,'Fontsize',16,'linewidth',2)
set(gca,'color','w');

tbb.sd_o(:,1) = rlt.metoSD(my_refs)';
metoHM = 1/mean(1./rlt.metoSD(my_refs));
tbb.norm_SD_o(:,1) = round(metoHM./rlt.metoSD(my_refs)/length(ref_metabolites)*100,0);

tbb.sd_x(:,1) = rlt.metwSD(my_refs)';
metwHM = 1/mean(1./rlt.metwSD(my_refs));
tbb.norm_SD_x(:,1) = round(metwHM./rlt.metwSD(my_refs)/length(ref_metabolites)*100,0);

script_fol = pwd;
cd(fullfile('Results','Figures'))
print -dtiff -r600 Figure_S5_A
cd(script_fol)
    
figure(3)
close(3)
figure(3)
plot(tbl.rs,tbl.CrRaoMEAN,'ks')
set(gca,'YMinorTick','on')
set(gca,'XMinorTick','on')
hold on;
zoff = 0.4+zeros(size(tbl.names));
%zoff = choose_zoff_SD_rat_CV(tbl);
for jj = 1:length(tbl.names)
    text(tbl.rs(jj)-0.0015,tbl.CrRaoMEAN(jj)-zoff(jj),strcat('\uparrow',tbl.names{jj}),'fontsize',13,'color','k')
end

set(gca,'TickLength',[0.03 0.03])
set(gca,'Fontsize',16,'linewidth',2)
set(gca,'color','w');
xlabel(strcat('Pearson R, S_D vs. W_D'),'fontsize',16)
ylabel(strcat('average percent CRLBs'),'fontsize',16)
ylim([1 14])
xlim([0.82 0.96])

script_fol = pwd;
cd(fullfile('Results','Figures'))
print -dtiff -r600 Table_S5_B
cd(script_fol)