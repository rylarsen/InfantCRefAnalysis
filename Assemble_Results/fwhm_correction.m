% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

%performs statistical correction for metabolite signal dependence on FWHM,
%called by create_rlt


function newmet = fwhm_correction(oldmet,fwhm,met_names,fwhm_corr)
newmet = oldmet; %columns of metabolites that will be corrected aren't going to change.
for jj = 1:length(fwhm_corr) %loop through the metabolites that you are correcting
    meti = find(strcmp(met_names,fwhm_corr{jj}));
    
    mets_uc = oldmet(:,meti);
    fwhm2 = fwhm;
    fwhm2(isnan(mets_uc)) = NaN;
    
    to_include = ~isnan(mets_uc);
    mets_uc = mets_uc(to_include);
    fwhm2 = fwhm2(to_include);    
    
    fwhm_cont = fwhm2;
    fwhm_cat = categorical(fwhm2);
    
    ftab = table;
    ftab.mets_uc = mets_uc;
    ftab.fwhm_cat = fwhm_cat;
    ftab.fwhm_cont = fwhm_cont;
    mdl_cat = fitlm(ftab,'mets_uc~fwhm_cat');
    mdl_cont = fitlm(ftab,'mets_uc~fwhm_cont');
    
    met_pred = feval(mdl_cont,ftab);
    mets_c = mets_uc - met_pred+nanmean(mets_uc);
        
    faxis =table;
    faxis.fwhm_cat= categories(fwhm_cat);
    faxis.fwhm_cont = unique(fwhm_cont);
    met_pred_cat = feval(mdl_cat,faxis);
    met_pred_cont = feval(mdl_cont,faxis);  
    
    newmet(to_include,meti) = mets_c;
end
end