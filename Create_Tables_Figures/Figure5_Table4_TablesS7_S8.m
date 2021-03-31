% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

%Create Figure 5, Table 4, and Tables S7 and S8 from Larsen et al, NMR in
%Biomedicine

clear
load('rlt')
close all

ref_metabolites = {'GABA','tNAA','tCr','Cho','Ins','Glx','GSH'};
use_SD_SIG = 'SD';
calculate_CRef;

%The first row of the tables is calculated using all reference
%metabolties.  Find a metabolite that is referenced by all the ference
%metabolites.  I use Tau, but I all check that it uses all 7 refs.
all_refs_metabolite = find(strcmp(rlt.met_names,'Tau'));
if sum(rlt.mat_refs(all_refs_metabolite,:)) ~= 7
    error('find a metabolite that uses all seven reference metabolites')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Water-scaled metabolites  (RCref_A)
% % (metabole/water) vs 1/fscale
for jj = 1:length(rlt.refi)
    fCR_sings(:,jj) = rlt.metw(:,rlt.refi(jj)); %single metabolites
    fCR_allbuts(:,jj) = 1./rlt.metw_factor_R(:,rlt.refi(jj)); %combined metabolites
end
fCR_allbuts(:,jj+1) = 1./rlt.metw_factor_R(:,all_refs_metabolite); %all references

%water-scaled that it is compared with:
fWS= 1./rlt.fscale;

%don't control PMA:
mtab = RvW(fCR_sings,fCR_allbuts,fWS,rlt,'no_cntrl_PA',3);
tab_file = 'Table_S8_columnsABCD.xlsx';
outfile = fullfile('Results','Tables',tab_file);
delete(outfile);
writetable(mtab,outfile);

figure(1)
subplot(2,2,3)
xlim([0.7 1.3])
ylim([0.7 1.3])
set(gca,'YTick',[0.8, 1.0, 1.2])
set(gca,'XTick',[0.8, 1.0, 1.2])


%control PMA:
mtab = RvW(fCR_sings,fCR_allbuts,fWS,rlt,'cntrl_PA',4);
tab_file = 'Table_S8_columnsEFGH.xlsx';
outfile = fullfile('Results','Tables',tab_file);
delete(outfile);
writetable(mtab,outfile);

figure(1)
subplot(2,2,4)
xlim([0.7 1.3])
ylim([0.7 1.3])
set(gca,'YTick',[0.8, 1.0, 1.2])
set(gca,'XTick',[0.8, 1.0, 1.2])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Water-scaled metabolites  (RCref_S)
% % (metabolite signal S) vs water/fscale
for jj = 1:length(rlt.refi)
    fCR_sings(:,jj) = rlt.meto(:,rlt.refi(jj)); %single metabolite
    fCR_allbuts(:,jj) = 1./rlt.meto_factor_R(:,rlt.refi(jj)); %combined metabolites
end
fCR_allbuts(:,jj+1) = 1./rlt.meto_factor_R(:,all_refs_metabolite); %all reference metabolites

%water-scaled that it is compared with:
fWS= rlt.mwsig./rlt.fscale;

%don't control PMA:
mtab = RvW(fCR_sings,fCR_allbuts,fWS,rlt,'no_cntrl_PA',1);
tab_file = 'Table_4.xlsx';  %also is Table_S7_columns_ABCD
outfile = fullfile('Results','Tables',tab_file);
delete(outfile);
writetable(mtab,outfile);

%control PMA:
mtab = RvW(fCR_sings,fCR_allbuts,fWS,rlt,'cntrl_PA',2);
tab_file = 'Table_S7_columns_EFGH.xlsx';
outfile = fullfile('Results','Tables',tab_file);
delete(outfile);
writetable(mtab,outfile);
print -dtiff -r600 'Figure5.tif'
movefile(fullfile(pwd,'Figure5.tif'),fullfile('Results','Figures'))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mtab = RvW(fCR_sings,fCR_allbuts,fWS,rlt,condition,subplot_no)

mtab = table;
mtab.ref = cell(rlt.Nmets,1);
mtab.r_all_but = NaN*ones(rlt.Nmets,1);
mtab.cv_all_but = NaN*ones(rlt.Nmets,1);
mtab.r_sing = NaN*ones(rlt.Nmets,1);
mtab.cv_sing = NaN*ones(rlt.Nmets,1);
mtab.N = NaN*ones(rlt.Nmets,1);
mtab.N_subs = NaN*ones(rlt.Nmets,1);
for jj = 1:length(rlt.refi)
    mtab.ref(jj) = rlt.met_names(rlt.refi(jj));
    
    %use metabolite signal
    fCR_sing = fCR_sings(:,jj);
    fCR_allbut = fCR_allbuts(:,jj);
    
    goodi =  find(and(and(and(~isnan(fWS),~isnan(fCR_sing)),~isnan(fCR_allbut)),~isnan(rlt.GA)));
    
    fWSg = fWS(goodi);
    fCR_sing_g = fCR_sing(goodi);
    fCR_allbut_g = fCR_allbut(goodi);
    GA = rlt.GA(goodi);
    
    %     optional: remove some variance
    if strcmp(condition,'cntrl_PA')
        fCR_sing_g = remove_var(fCR_sing_g,GA)+mean(fCR_sing_g);%remove variability from GA
        fCR_allbut_g = remove_var(fCR_allbut_g,GA)+mean(fCR_allbut_g);%remove variability from GA
        fWSg = remove_var(fWSg,GA)+mean(fWSg);%remove variability from GA
    end
    
    [r,p] = corr(fWSg,fCR_allbut_g);
    mtab.r_all_but(jj) = round(r,2);
    mtab.cv_all_but(jj) = round(std(fCR_allbut_g./fWSg)/mean(fCR_allbut_g./fWSg),3);
    
    [r,p] = corr(fWSg,fCR_sing_g);
    mtab.r_sing(jj) = round(r,2);
    mtab.cv_sing(jj) = round(std(fCR_sing_g./fWSg)/mean(fCR_sing_g./fWSg),3);
    mtab.N(jj) = length(goodi);
    
    %from how many subjects?
    mtab.Nsubs(jj) = length(unique(rlt.subnum(goodi)));
end

%The final row is calculated with all reference metabolites.
mtab.ref{length(rlt.refi)+1} = 'all';
fCR_allbut = fCR_allbuts(:,length(rlt.refi)+1);
goodi =  find(and(~isnan(fWS),~isnan(fCR_allbut)));
fWSg = fWS(goodi);
fCR_allbut_g = fCR_allbut(goodi);
GA = rlt.GA(goodi);

%control for PA, if required.
if strcmp(condition,'cntrl_PA')
    fCR_allbut_g = remove_var(fCR_allbut_g,GA)+mean(fCR_allbut_g);%remove variability from GA
    fWSg = remove_var(fWSg,GA)+mean(fWSg);%remove variability from GA
end

[r,p] = corr(fWSg,fCR_allbut_g);
mtab.r_all_but(length(rlt.refi)+1) = round(r,2);
mtab.cv_all_but(length(rlt.refi)+1) = round(std(fCR_allbut_g./fWSg)/mean(fCR_allbut_g./fWSg),3);
mtab.N(length(rlt.refi)+1) = length(goodi);
mtab.Nsubs(length(rlt.refi)+1) = length(unique(rlt.subnum(goodi)));

mtab = [mtab(size(mtab,1),:); mtab(1:(size(mtab,1)-1),:)];
mtab.r_sing(1) = NaN;
mtab.cv_sing(1) = NaN;
figure(1)
subplot(2,2,subplot_no)

plot(fWSg/nanmean(fWSg),fCR_allbut_g/nanmean(fCR_allbut_g),'ks','linewidth',1);
set(gca,'YMinorTick','on')
set(gca,'XMinorTick','on')
hold on;
plot([0.5:.01:1.6],[0.5:.01:1.6],'k-','linewidth',1.5)
xlim([0.5 1.6])
ylim([0.5 1.6])

set(gca,'YTick',[0.6, 0.8, 1.0, 1.2, 1.4])
set(gca,'XTick',[0.6, 0.8, 1.0, 1.2, 1.4])

set(gca,'TickLength',[0.03 0.03]);
set(gca,'Fontsize',11,'linewidth',1.5);

end

