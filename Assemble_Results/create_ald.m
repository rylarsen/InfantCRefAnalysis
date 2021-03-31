clear
close all

ref_metabolites = {'GABA','tNAA','tCr','Cho','Ins','Glx','GSH'};
use_SD_SIG = 'SD';
calculate_CRef;

load('pathnames')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ald.met_names = rlt.met_names;
ald.metwSD = rlt.metwSD;
ald.metfwSD = rlt.metfwSD;
ald.metfw_ps = rlt.metfw_ps;
ald.mu = rlt.mu;
ald.T2_brn = rlt.T2_brn;
session_fol = rlt.session_fol;

%track the accuracy of CRef:
for jj = 1:size(rlt.metfwZ,1)
    offset(jj,1) =   mean(rlt.metw_CRef_Z(jj,:) - rlt.metfwZ(jj,:));  %mean deviation
    offset_abs(jj,1) =   abs(mean(rlt.metw_CRef_Z(jj,:) - rlt.metfwZ(jj,:))); %absolute value of the means
    mresid_crf(jj,1) = mean(abs(rlt.metw_CRef_Z(jj,:) - rlt.metfwZ(jj,:))); %means of the absolute values.
end

figure(15)
negpoints = find(offset>=0);
pospoints = find(offset<0);
plot(mresid_crf(pospoints),offset_abs(pospoints),'bs','linewidth',2)
set(gca,'YMinorTick','on')
set(gca,'XMinorTick','on')
hold on;
plot(mresid_crf(negpoints),offset_abs(negpoints),'rs','linewidth',2)

set(gca,'TickLength',[0.03 0.03]);
set(gca,'Fontsize',18,'linewidth',2);
set(gca,'color','w');
xlabel('mean of absolute values of residuals','fontsize',16)
ylabel('absolute values of means of residuals','fontsize',16)

[r,p] = corrcoef(mresid_crf,offset_abs,'rows','complete')
title(strcat('R=',num2str(round(r(1,2),2)),' p=',num2str(round(p(1,2),3))),'fontsize',16)

%estimate the error associated with T2 measurements
jan = load(fullfile(pathnames.Subject_data_fol,'T2_combined_data.mat'));
for pt = 1:length(session_fol)
    max_r_brn(pt) = jan.mresid_csfs(pt);
end

%try to relate error of T2 measurements with poorness of CRef accuracy, no
%relaxationship.
figure(79);plot(mresid_crf,max_r_brn,'k.')
[r,p] = corrcoef(mresid_crf,max_r_brn,'rows','complete')


%show that the signal from the T2 measurements is highly correlated with
%the water signal used for scaling the metabolties.
%(Despite the fact that different coil combinations were used, and it was a
%different sequence).
figure(81)
plot(jan.sigs_abs(jan.throw_out==0,2),rlt.mwsig(jan.throw_out==0),'ks')
[r,p] = corrcoef(jan.sigs_abs(jan.throw_out==0,2),rlt.mwsig(jan.throw_out==0),'rows','complete')

%rearrange the order so that good datasets are first:
ald.metfwE = rlt.metfwE;
ald.metfw = rlt.metfw;
ald.metw = rlt.metw;
ald.PMA = rlt.GA;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

naa = isnan(ald.metw(:,2));
[Y ind1] = sort(naa);
 
Nsubs = nnz(Y==0); % 183 subjects that have all but gaba

ald.metfwE = ald.metfwE(ind1,:);
ald.metfw = ald.metfw(ind1,:);
ald.metw = ald.metw(ind1,:);
ald.PMA = ald.PMA(ind1);
ald.mresid_crf = mresid_crf(ind1);
session_fol = session_fol(ind1);

%remove infants with no data 
ald.metfwE = ald.metfwE(1:Nsubs,:);
ald.metfw = ald.metfw(1:Nsubs,:);
ald.metw = ald.metw(1:Nsubs,:);
ald.PMA = ald.PMA(1:Nsubs);
ald.mresid_crf = ald.mresid_crf(1:Nsubs);
session_fol = session_fol(1:Nsubs);

%reorder again, the two without GABA go at the end
gaba = isnan(ald.metw(:,1));
[Y ind1] = sort(gaba)

ald.metfwE = ald.metfwE(ind1,:);
ald.metfw = ald.metfw(ind1,:);
ald.metw = ald.metw(ind1,:);
ald.PMA = ald.PMA(ind1);
ald.mresid_crf = ald.mresid_crf(ind1);
session_fol = session_fol(ind1);

%reorder again; subjects with true concentration measurements go first
[Y ind1] = sort(ald.mresid_crf);

ald.metfwE = ald.metfwE(ind1,:);
ald.metfw = ald.metfw(ind1,:);
ald.metw = ald.metw(ind1,:);
ald.PMA = ald.PMA(ind1);
ald.mresid_crf = ald.mresid_crf(ind1);
session_fol = session_fol(ind1);

ctbl = table;
ctbl.nums = [1:183]';
ctbl.session_fol = session_fol;
ctbl.Properties.VariableNames = {'App number';'scan_session'}
delete('app_codes.xlsx')
writetable(ctbl,'app_codes.xlsx')

save('wld','ald')


