% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

%calculate PMA-dependence of water-scaled metabolites

clear

load('rlt.mat');

rlt.metwE = NaN*ones(rlt.Nsess,rlt.Nmets);


%%%%%%%%%%%%%%
%the polynomial fitting is better when we zscore the x data, using the
%parameter mu.
%the parameter mu will be the same for all calculations
[r,~,~] = find(~isnan(rlt.fscale(:)).*~isnan(rlt.GA(:))); %only include those with valid fscale and PMA values
rlt.mu(1) = mean(rlt.GA(r));
rlt.mu(2) = std(rlt.GA(r));

%     %this is what you should get:
% mu =
%  338.3658   44.9490
if abs(rlt.mu(1) - 338.3658)>0.001
    error('check mu values')
end
if abs(rlt.mu(2) - 44.9490)>0.001
    error('check mu values')
end

for jj = 1:rlt.Nmets
    [r,~,~] = find(~isnan(rlt.metw(:,jj)).*~isnan(rlt.GA(:))); %get rid of NaNs
    [ps] = polyfit((rlt.GA(r)-rlt.mu(1))/rlt.mu(2),rlt.metw(r,jj),2);
     
    N_scan_sessions = length(r);    
    N_u_subs = length(unique(rlt.subnum(r)));
    
    rlt.metw_ps(jj,:) = ps;
end

%calculate expected values for all metabolites
for jj = 1:rlt.Nmets
    for subjectindex = 1:rlt.Nsess
        rlt.metwE(subjectindex,jj) = polyval(rlt.metw_ps(jj,:),rlt.GA(subjectindex),[],rlt.mu);
    end
end

rlt.metwD = rlt.metw - rlt.metwE; %deviation from expected
rlt.metwSD = nanstd(rlt.metwD); %PMA-corrected SDs
rlt.metwMEAN = nanmean(rlt.metw); %mean
rlt.metwSIG = nanstd(rlt.metw); %non-PMA-corrected SDs
rlt.metwZ  = rlt.metwD./nanstd(rlt.metwD); %Z-score
rlt.metwCVs = rlt.metwSD./rlt.metwMEAN; %CVs

save('rlt','rlt')
clear