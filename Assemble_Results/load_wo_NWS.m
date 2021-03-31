% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

%this is called by create_lcm.
%It loads the results of lcmodel that were generated without water-scaling

for subjectindex = 1:Nsess
    
    session_fol = fns_fam{subjectindex};
    subnum = session_fol(1:6);
    lcm.subnum{subjectindex,1} = subnum;
    lcm.session(subjectindex,1) = str2double(session_fol(8));
    lcm.session_fol{subjectindex,1} = session_fol;
    
    % I don't know why analysis for this subject failed in lcmodel.
    % It doesn't really matter because the water-scaling scan is not
    % available.
    if subjectindex ==98 && strcmp(session_fol,'FAM117_2')  
        continue
    end
    
    %%%%%%%%%% load difference spectrum
    spectroscopy_data_path=fullfile(pathnames.MRS_data_fol,session_fol,'LCmodel_Results_Non_Water_Scaled','Difference');
    ag = dir(fullfile(spectroscopy_data_path,'t*'));
    info_dif = mrs_readLcmodelTABLE(fullfile(spectroscopy_data_path,ag(1).name));
    
    %QA information
    read_fwhm_bch
    lcm.fwhm_o(subjectindex,1) = fwhm;
    lcm.snr_o(subjectindex,1) = snr;
    
    %load off res spectrum
    spectroscopy_data_path=fullfile(pathnames.MRS_data_fol,session_fol,'LCmodel_Results_Non_Water_Scaled','Off_Resonance');
    ag = dir(fullfile(spectroscopy_data_path,'t*'));
    info = mrs_readLcmodelTABLE(fullfile(spectroscopy_data_path,ag(1).name));
    
    %QA information
    read_fwhm_bch
    lcm.fwhm_o(subjectindex,2) = fwhm;
    lcm.snr_o(subjectindex,2) = snr;
    
    %%%metabolite information into the lcm structure
    ii=1;
    lcm.meto(subjectindex,ii)= diff_raw_scale*info_dif.concentration(strcmp(info_dif.name,labels(ii)));
    lcm.sdo(subjectindex,ii)= info_dif.SDpct(strcmp(info_dif.name,labels(ii)));    
    for ii = 2:size(met_names,2)  %loop through the metabolites.
        lcm.meto(subjectindex,ii)= off_raw_scale*info.concentration(strcmp(info.name,labels(ii)));
        lcm.sdo(subjectindex,ii)= info.SDpct(strcmp(info.name,labels(ii)));
    end   

end


