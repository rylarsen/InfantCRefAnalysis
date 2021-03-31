% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

function plot_CV_vs_R(qmets,marker,color)
%read in offsets of the text markers
zoff = choose_zoff_SIG(qmets);
for jj = 1:length(qmets.names)
    plot(qmets.CV(jj),qmets.r(jj),marker,'markersize',7,'linewidth',1.2)
    set(gca,'YMinorTick','on')
    set(gca,'XMinorTick','on')
    hold on;    
    if strcmp(color,'k')
        text(qmets.CV(jj)-0.001,qmets.r(jj)-0.035-zoff(jj),strcat('\uparrow',qmets.names{jj}),'fontsize',13,'color',color);
    end
end

ylim([0.3 1.05])
xlim([0.04 0.17])
set(gca,'TickLength',[0.03 0.03])
set(gca,'Fontsize',11,'linewidth',2)

xlabel('${CV_{C\_WSc\_D}}$','fontsize',18,'interpreter','latex')
ylabel('${R_{D}}$','fontsize',18,'interpreter','latex')
end