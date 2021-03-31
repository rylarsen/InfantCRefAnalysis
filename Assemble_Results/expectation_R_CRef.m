%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calcaulte rlt.metw_CRef_R_E
colm(1,1) = cellstr('Metabolite');
colm(1,2) = cellstr('N_sessions');
colm(1,3) = cellstr('N_subjects');
colm(1,4) = cellstr('C_0');
colm(1,5) = cellstr('C_1');
colm(1,6) = cellstr('C_2');
colm(1,7) = cellstr('sigma');

for jj = 1:rlt.Nmets
    [r,~,~] = find(~isnan(rlt.metw_CRef_R(:,jj)).*~isnan(rlt.GA(:))); %get rid of NaNs

    [ps] = polyfit((rlt.GA(r)-rlt.mu(1))/rlt.mu(2),rlt.metw_CRef_R(r,jj),2);
    
    N_scan_sessions = length(r);
    N_u_subs = length(unique(rlt.subnum(r)));
    
    rlt.metw_CRef_R_ps(jj,:) = ps;
    
    %should normalize by mean value
    colm(jj+1,1) = cellstr(rlt.met_names{jj});
    colm(jj+1,2) = num2cell(N_scan_sessions);
    colm(jj+1,3) = num2cell(N_u_subs);
    colm(jj+1,4) = num2cell(round(ps(3),2));
    colm(jj+1,5) = num2cell(round(ps(2),2));
    colm(jj+1,6) = num2cell(round(ps(1),3));
end

%calculate expected values for all metabolites
rlt.metw_CRef_R_E = NaN*ones(rlt.Nsess,rlt.Nmets);
for jj = 1:rlt.Nmets
    for subjectindex = 1:rlt.Nsess
        rlt.metw_CRef_R_E(subjectindex,jj) = polyval(rlt.metw_CRef_R_ps(jj,:),rlt.GA(subjectindex),[],rlt.mu);
    end
end

%calculate devation values from the expected value
rlt.metw_CRef_R_D = rlt.metw_CRef_R - rlt.metw_CRef_R_E;
rlt.metw_CRef_R_Z = rlt.metw_CRef_R_D./nanstd(rlt.metw_CRef_R_D);

%calculate basic stats for the CRef_R data
rlt.metw_CRef_R_SD = nanstd(rlt.metw_CRef_R_D);
rlt.metw_CRef_R_MEAN = nanmean(rlt.metw_CRef_R);
rlt.CRef_R_CVs = rlt.metw_CRef_R_SD./rlt.metw_CRef_R_MEAN;

%now put the standard deviation values into the table:
clear Y ind
for jj = 1:rlt.Nmets
    colm(jj+1,7) = num2cell(round(rlt.metw_CRef_R_SD(jj),3));
end