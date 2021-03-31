% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

%calculate PMA dependence of corrected water-scaled metabolites, export supporting table S6  

clear

load('rlt.mat');

rlt.metfwE = NaN*ones(rlt.Nsess,rlt.Nmets); %expected values of metfw (water-scaled corrected)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%characterize change in average metabolite value as a function of age:
colm(1,1) = cellstr('Metabolite');
colm(1,2) = cellstr('N_sessions');
colm(1,3) = cellstr('N_subs');
colm(1,4) = cellstr('C_0');
colm(1,5) = cellstr('C_1');
colm(1,6) = cellstr('C_2');
colm(1,7) = cellstr('sigma');

for jj = 1:rlt.Nmets
    [r,~,~] = find(~isnan(rlt.metfw(:,jj)).*~isnan(rlt.GA(:))); %get rid of NaNs
    [ps] = polyfit((rlt.GA(r)-rlt.mu(1))/rlt.mu(2),rlt.metfw(r,jj),2);
    
    N_scan_sessions = length(r);

    N_u_subs = length(unique(rlt.subnum(r)));
    
    rlt.metfw_ps(jj,:) = ps;

    %should normalize by mean value
    colm(jj+1,1) = cellstr(rlt.met_names{jj});
    colm(jj+1,2) = num2cell(size(rlt.metfw(r,jj),1));
    colm(jj+1,3) = num2cell(N_u_subs);
    colm(jj+1,4) = num2cell(round(ps(3),2));
    colm(jj+1,5) = num2cell(round(ps(2),2));
    colm(jj+1,6) = num2cell(round(ps(1),3));
end

%calculate expected values for all metabolites
for jj = 1:rlt.Nmets
    for subjectindex = 1:rlt.Nsess
        %calculate expected concentration values:
        rlt.metfwE(subjectindex,jj) = polyval(rlt.metfw_ps(jj,:),rlt.GA(subjectindex),[],rlt.mu);
    end
end

rlt.metfwD = rlt.metfw - rlt.metfwE; %deviation from expected
rlt.metfwSD = nanstd(rlt.metfwD); %PMA-corrected SD values
rlt.metfwSIG = nanstd(rlt.metfw); %non-PMA-corrected SD values
rlt.metfwMEAN = nanmean(rlt.metfw); %mean of metfw values
rlt.metfwZ  = rlt.metfwD./nanstd(rlt.metfwD); %Z score of PMA-corrected values
rlt.metfwCVs = rlt.metfwSD./rlt.metfwMEAN;  %CV

% %now put the standard deviation values into the table:
for jj = 1:rlt.Nmets
    colm(jj+1,7) = num2cell(round(rlt.metfwSD(jj),3));
end

filename = 'TableS6.xlsx';
fol = fullfile('Results','Tables');
delete(fullfile(fol,filename));
xlswrite(fullfile(fol,filename),colm);

save('rlt','rlt')
clear

