% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

%Create Figure 6A from Larsen et al, NMR in Biomedicine

clear
load('rlt')
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%average percent cramer rao

average_cr = nanmean(rlt.sd,1); %average cramer-rao 
figure(24)
plot(rlt.metfwCVs,average_cr,'ks','markersize',9,'linewidth',2)
set(gca,'YMinorTick','on')
set(gca,'XMinorTick','on')
hold on;
zoff = [0.01 0.02 0 0 0.03 0 0.03 0 0.035 0];
for jj = 1:rlt.Nmets
    text(rlt.metfwCVs(jj)-0.002,average_cr(jj)-0.6-zoff(jj)*20,strcat('\uparrow',rlt.met_names{jj}),'fontsize',13,'color','k') 
end

ylim([0.01 14])
xlim([0.04 0.17])
set(gca,'TickLength',[0.03 0.03])
set(gca,'Fontsize',11,'linewidth',2)
xlabel('${CV_{C\_WSc\_D}}$','fontsize',18,'interpreter','latex')
ylabel('average percent Cramer-Rao','fontsize',18,'interpreter','latex')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%print figure
script_fol = pwd;
cd(fullfile('Results','Figures'))
print -dtiff -r600 Figure6B
cd(script_fol)
