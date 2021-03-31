% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

% removes outliers iteratively. called by create_rlt

function [dat_a,eliminated_a,niter] = outlier_elim_by_visit_iter(dat_a,session_no)

eliminated_a = cell(1,size(dat_a,2));
nit1 = NaN*ones(1,size(dat_a,2));
nit2 = NaN*ones(1,size(dat_a,2));
niter = NaN*ones(1,size(dat_a,2));
for kk = 1:size(dat_a,2)
    
    sess1 = dat_a(:,kk);
    sess1(session_no==2) = NaN; %all numbers from the other session set to NaN
    [sess1,el_1,nit1(kk),~] = outlier_elim_iter(sess1);
    
    sess2 = dat_a(:,kk);
    sess2(session_no==1) = NaN; %all numbers from the other session set to NaN
    [sess2,el_2,nit2(kk),~] = outlier_elim_iter(sess2);
    
    comb = NaN*ones(size(session_no));
    comb(session_no==1) = sess1(session_no==1);
    comb(session_no==2) = sess2(session_no==2);
    
    dat_a(:,kk) = comb;
    eliminated_a{kk} = [el_1{1}; el_2{1}];
    niter(kk)= nit1(kk)+nit2(kk);

end
end

