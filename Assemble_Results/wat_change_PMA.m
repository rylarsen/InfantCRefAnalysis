% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

%fit the PMA dependence of the water signal.

clear
load('rlt')

[r,~,~] = find(~isnan(rlt.mwsig).*~isnan(rlt.GA(:))); %get rid of NaNs
[ps] = polyfit((rlt.GA(r)-rlt.mu(1))/rlt.mu(2),rlt.mwsig(r),2);

rlt.mwsig_N_sessions = length(r);
rlt.mwsig_N_subjs = length(unique(rlt.subnum(r)));
rlt.mwsig_ps = ps;

%calculate expected values for all metabolites
rlt.mwsigE = polyval(rlt.mwsig_ps,rlt.GA,[],rlt.mu);
rlt.mwsigD = rlt.mwsig- rlt.mwsigE;
rlt.mwsigSD = nanstd(rlt.mwsigD);
rlt.mwsigMEAN = nanmean(rlt.mwsig);
rlt.mwsigZ  = rlt.mwsigD./rlt.mwsigSD;
rlt.mwsigCVs = rlt.mwsigSD./rlt.mwsigMEAN;

save('rlt','rlt')