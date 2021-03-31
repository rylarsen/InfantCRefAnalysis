% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.


Nstack = length(stackmet);
ycrd = stycrd + heightw*[0:(Nstack-1)];
for jj = 1:Nstack
    
    m = axes('units','inches');
    set(m,'position',[stxcrd ycrd(jj) widthw heightw]);
    
    plot(rlt.GA*12/365.25,rlt.metw_CRef_R(:,stackmet(jj)),'kv','markersize',2.0)
    set(gca,'YMinorTick','on')
    set(gca,'XMinorTick','on')
    hold on;
        
    %plot expected values from CRef_R:
    ys= polyval(rlt.metw_CRef_R_ps(stackmet(jj),:),xs,[],rlt.mu);
    plot(xs*12/365.25,ys,'k--','linewidth',1);
    
    set(gca,'TickLength',[0.03 0.03])
    set(gca,'Fontsize',10,'linewidth',1.2)
    if jj == 1
        xlabel('PMA (months)','fontsize',11)
    else
        set(gca,'xticklabel',{' '}); %get rid of axis labels on x axis.
    end
    ylabel(strcat(rlt.met_names{stackmet(jj)}),'fontsize',11)
    xlim([260 440]*12/365.25)
    set(gca,'color','w');
    
    my_met_name = rlt.met_names{stackmet(jj)};
    R_CRef_tick_details    
end