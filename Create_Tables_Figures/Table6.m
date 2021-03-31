% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

%Create Table 6 from Larsen et al, NMR in Biomedicine

clear
close all

%Stats on PMA vs. C_WSc

load('rlt.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%characterize change in average metabolite value as a function of age:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

colm(1,1) = cellstr('Metabolite');
colm(1,2) = cellstr('R');
colm(1,3) = cellstr('p');
colm(1,4) = cellstr('percent change');

for jj = 1:rlt.Nmets
        
    %use metfw data:
    met0 = polyval(rlt.metfw_ps(jj,:),280,[],rlt.mu);
    met90 = polyval(rlt.metfw_ps(jj,:),280+90,[],rlt.mu); 

    met0s(jj) = met0;
    met90s(jj) = met90;    

    p_increase = (met90-met0)/met0*100;

    [r,~,~] = find(~isnan(rlt.metfw(:,jj)).*~isnan(rlt.GA(:))); %get rid of NaNs    
    N_subjects = length(unique(rlt.subnum(r)));
      
    [Rv1,pv1] = corrcoef(rlt.GA(r) ,rlt.metfw(r,jj));

    colm(jj+1,1) = cellstr(rlt.met_names{jj});
    colm(jj+1,2) = num2cell(round(Rv1(1,2),2));
    colm(jj+1,3) = num2cell(pv1(1,2));
    colm(jj+1,4) = num2cell(round(p_increase,0));
  
end

%write the spreadsheet with the stats:
floc = fullfile('Results','Tables');
filename = 'Table6.xlsx'
delete(fullfile(floc,filename));
xlswrite(fullfile(floc,filename),colm);

