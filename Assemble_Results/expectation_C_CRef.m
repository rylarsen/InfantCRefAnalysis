%Fit PMA-dependence
for jj = 1:rlt.Nmets
    [r,~,~] = find(~isnan(rlt.metw_CRef(:,jj)).*~isnan(rlt.GA(:))); %get rid of NaNs
    rlt.metw_CRef_ps(jj,:) = polyfit((rlt.GA(r)-rlt.mu(1))/rlt.mu(2),rlt.metw_CRef(r,jj),2);   
end

%Calculate expected values for all metabolites
rlt.metw_CRef_E = NaN*ones(rlt.Nsess,rlt.Nmets);
for jj = 1:rlt.Nmets
    for subjectindex = 1:rlt.Nsess
        rlt.metw_CRef_E(subjectindex,jj) = polyval(rlt.metw_CRef_ps(jj,:),rlt.GA(subjectindex),[],rlt.mu);
    end
end

%calculate devation values from the expected value
rlt.metw_CRef_D = rlt.metw_CRef - rlt.metw_CRef_E;
rlt.metw_CRef_Z = rlt.metw_CRef_D./nanstd(rlt.metw_CRef_D);

%calculate basic stats for the C_CRef data
rlt.metw_CRef_SD = nanstd(rlt.metw_CRef_D);
rlt.metw_CRef_MEAN = nanmean(rlt.metw_CRef);
rlt.CRef_CVs = rlt.metw_CRef_SD./rlt.metw_CRef_MEAN;



