% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

%read FWHM and SNR data
%called by create_lcm

head_lines = 46;
importfile_table(fullfile(spectroscopy_data_path,ag(1).name),head_lines);
flag_snr = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This is the part that reads in the parameters of interest:
for pt = 8:head_lines
    if iscell(mydat)
        ab = mydat(pt);
    else
        if iscell(mydat.textdata)
            ab = mydat.textdata(pt);
        end
    end
    %ab = mydat.textdata(pt)
    ab2 = ab{1};
    if size(ab2,2) ~= 0
        A = strread(ab2,'%s');
        if strncmp(A{1},'FWHM',4) == 1
            mynum_f = pt;
            fwhm = str2num(A{3});
            for pgh = 2:size(A,1)
                if strncmp(A{pgh},'S/N',3) == 1
                    snr = str2num(A{pgh+2});
                    flag_snr = 1;
                    continue
                end
            end
        end
        if flag_snr == 1
            break
        end
    end
end

clear mydat
function importfile_table(fileToRead1,HEADERLINES)
%IMPORTFILE(FILETOREAD1)
%  Imports data from the specified file
%  FILETOREAD1:  file to read

%  Auto-generated by MATLAB on 19-Nov-2012 11:03:45

DELIMITER = ' ';
%HEADERLINES = 50;
%HEADERLINES = 45;
% Import the file
rawData1 = importdata(fileToRead1, DELIMITER, HEADERLINES);

% For some simple files (such as a CSV or JPEG files), IMPORTDATA might
% return a simple array.  If so, generate a structure so that the output
% matches that from the Import Wizard.
[~,name] = fileparts(fileToRead1);
newData1.(genvarname(name)) = rawData1;

% Create new variables in the base workspace from those fields.
vars = fieldnames(newData1);
%vars = {'mydat'}
for i = 1:length(vars)
    assignin('base', 'mydat', newData1.(vars{i}));
end

end