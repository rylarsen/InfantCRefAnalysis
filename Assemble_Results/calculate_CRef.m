%This script calculates the R_CRef and C_CREF

clearvars -except ref_metabolites use_SD_SIG
load('rlt') %structure containing data

%% Define matrices used for CRef calculations 

rlt.my_refs = ismember(rlt.met_names,ref_metabolites);
rlt.refi = find(rlt.my_refs); %indices of reference metabolites

%this is a matrix of reference metabolites; each row give the reference
%metabolites for that metabolite.
rlt.mat_refs = NaN*ones(rlt.Nmets,rlt.Nmets);
for jj = 1:rlt.Nmets
    %calculat a metabolite-specific mask
    rlt.mat_refs(jj,:) = rlt.my_refs;
    rlt.mat_refs(jj,jj) = 0; %no self-referencing    
    if strcmp(rlt.met_names{jj},'Glu') %we don't want to use Glx to reference Glu
        rlt.mat_refs(jj,strcmp(rlt.met_names,'Glx')) = 0;
    end
    if strcmp(rlt.met_names{jj},'NAA') %we don't want to use tNAA to reference NAA
        rlt.mat_refs(jj,strcmp(rlt.met_names,'tNAA')) = 0;
    end
end

%calculate weighting factors:
rlt.metw_wn = NaN*ones(rlt.Nmets,rlt.Nmets);
rlt.meto_wn = NaN*ones(rlt.Nmets,rlt.Nmets);
for jj = 1:rlt.Nmets     
    msk = logical(rlt.mat_refs(jj,:));    
    if strcmp(use_SD_SIG,'SIG')
        har_mean = 1/mean(1./rlt.metwSIG(msk));
        rlt.metw_wn(jj,msk) = har_mean./rlt.metwSIG(msk)/nnz(msk);
        har_mean = 1/mean(1./rlt.metoSIG(msk));
        rlt.meto_wn(jj,msk) = har_mean./rlt.metoSIG(msk)/nnz(msk);
    elseif strcmp(use_SD_SIG,'SD')
        har_mean = 1/mean(1./rlt.metwSD(msk));
        rlt.metw_wn(jj,msk) = har_mean./rlt.metwSD(msk)/nnz(msk);
        har_mean = 1/mean(1./rlt.metoSD(msk));
        rlt.meto_wn(jj,msk) = har_mean./rlt.metoSD(msk)/nnz(msk);
    else
        error('how to normalize metabolite signal?');
    end  
end


%How many CRef measurements will we have?
ref_mat = rlt.metw(:,find(rlt.my_refs));
nnz(sum(~isnan(ref_mat),2)==7);  %water-scaled

refo_mat = rlt.meto(:,find(rlt.my_refs));
nnz(sum(~isnan(refo_mat),2)==7); %non-water-scaled

%% Calculate water-scaled CRef

rlt.metw_CRef_R = NaN*ones(rlt.Nsess,rlt.Nmets);
rlt.metw_factor_R = NaN*ones(rlt.Nsess,rlt.Nmets);

for jj = 1:rlt.Nmets
    %calculat a metabolite-specific mask
    msk = logical(rlt.mat_refs(jj,:));
    for subjectindex = 1:rlt.Nsess
        %R_CREF:
        rlt.metw_CRef_R(subjectindex,jj) = rlt.metw(subjectindex,jj)/sum(rlt.metw_wn(jj,msk).*rlt.metw(subjectindex,msk));
        %inverse of the reference signal:
        rlt.metw_factor_R(subjectindex,jj) = 1/sum(rlt.metw_wn(jj,msk).*rlt.metw(subjectindex,msk));
        %C_CREF:
        rlt.metw_CRef(subjectindex,jj) = rlt.metw_CRef_R(subjectindex,jj).*sum(rlt.metw_wn(jj,msk).*rlt.metfwE(subjectindex,msk));
    end
end

%calculate expectation values and related stats for C_CRef
expectation_C_CRef

%calculate expectation values and related stats for R_CRef
expectation_R_CRef

%% Calculate non-water-scaled CRef
rlt.meto_CRef_R = NaN*ones(rlt.Nsess,rlt.Nmets);
rlt.meto_factor_R= NaN*ones(rlt.Nsess,rlt.Nmets);

for jj = 1:rlt.Nmets
    %calculat a metabolite-specific mask
    msk = logical(rlt.mat_refs(jj,:));
    for subjectindex = 1:rlt.Nsess        
        rlt.meto_CRef_R(subjectindex,jj) = rlt.meto(subjectindex,jj)/sum(rlt.meto_wn(jj,msk).*rlt.meto(subjectindex,msk));
        rlt.meto_factor_R(subjectindex,jj) = 1/sum(rlt.meto_wn(jj,msk).*rlt.meto(subjectindex,msk)); %inverse reference
    end
end

clearvars -except ref_metabolites use_SD_SIG rlt

















