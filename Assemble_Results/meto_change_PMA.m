% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

% calculated PMA-dependence of raw metabolite values.

clear

load('rlt.mat');

rlt.metoE = NaN*ones(rlt.Nsess,rlt.Nmets); %expected values of raw signals (meto)

for jj = 1:rlt.Nmets
    [r,~,~] = find(~isnan(rlt.meto(:,jj)).*~isnan(rlt.GA(:))); 
    [ps] = polyfit((rlt.GA(r)-rlt.mu(1))/rlt.mu(2),rlt.meto(r,jj),2);
    
    N_scan_sessions = length(r);
    N_u_subs = length(unique(rlt.subnum(r))); 
    
    rlt.meto_ps(jj,:) = ps;
end

%calculate expected values for all metabolites
for jj = 1:rlt.Nmets
    for subjectindex = 1:rlt.Nsess
        %calculate expected concentration values:
        rlt.metoE(subjectindex,jj) = polyval(rlt.meto_ps(jj,:),rlt.GA(subjectindex),[],rlt.mu);
    end
end

rlt.metoD = rlt.meto - rlt.metoE; %deviations from expected
rlt.metoSD = nanstd(rlt.metoD); %PMA-corrected SD values
rlt.metoMEAN = nanmean(rlt.meto); %mean raw signal values
rlt.metoSIG = nanstd(rlt.meto); %non-PMA-corrected SD values
rlt.metoZ  = rlt.metoD./nanstd(rlt.metoD); %Z-scored
rlt.metoCVs = rlt.metoSD./rlt.metoMEAN; %CVs

save('rlt','rlt')
clear
