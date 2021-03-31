% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

% removes outliers 

function [dat_a,eliminated_a,niter_a,num_elim_a] = outlier_elim_iter(dat_a)

eliminated_a = cell(1,size(dat_a,2));
niter_a = zeros(1,size(dat_a,2));
num_elim_a = zeros(1,size(dat_a,2));
for kk = 1:size(dat_a,2)    
    flag = 0;
    eliminated = [];
    niter = 0; %number of iterations
    datv = dat_a(:,kk);
    while flag == 0

        %matlab function:
        TG= isoutlier(datv,'quartiles');
        datv(TG) = NaN;
        too_far = find(TG);
        eliminated = [eliminated; too_far];        
        niter=niter+1;
        flag = isempty(too_far);
    end    
    dat_a(:,kk) = datv;
    eliminated_a{kk} = eliminated;
    niter_a(kk) = niter;
    num_elim_a(kk) = length(eliminated);
end

end

