# InfantCRefAnalysis

AUTHOR : Ryan Larsen
Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

This code can be used to analyze Magnetic Resonance Spectroscopy data acquired from 181 typically-developing infants, ages two weeks to 4 months, acquired at Boston Children's Hospital.  The complete dataset is available at: https://doi.org/10.13012/B2IDB-3548139_V1

The dataset is described in the following publication: "Quantification of Magnetic Resonance Spectroscopy data using a combined reference: Application in typically developing infants" in NMR in Biomedicine by Larsen RJ, et al, 2021.

This code can be used to reproduce the data figures and tables in the publication. 

This code can also be used to create a file, "App_data.mat" that is used by an app that allows the interactive exploration of the dataset, and the comparison of user-provided data with the infants in the dataset.  A compiled form of the app is available at the Illinois Databank (https://doi.org/10.13012/B2IDB-3548139_V1) and the source code of the app is available at https://github.com/rylarsen/InfantCRefLibrary.
  
A demonstration video of the app can be found here: https://mediaspace.illinois.edu/media/t/1_sl2kjnkk


Instructions for running scripts:

All tables and figures can be created by running the "run_all_scripts". First, open the Matlab project, InfantCRefAnalysis.prj. Within the "run_all_scripts.m" script, assign the variable "pathnames.MRS_data_fol" as the directory that contains the "Individual_Data" directory from the Illinois Data Bank. Then specify the variable "pathnames.Subject_data_fol" as the directory that contains the "Combined_Data" directory from the Illinois Data Bank. The active directory of Matlab should be the project directory, InfantCRefAnalysis, where "run_all_scripts.m" resides.

When "run_all_scripts.m" is run, the script extracts the data from the data bank files, and reproduces all calculations in the paper.  The figures and tables from the paper, and from the supporting materials, are outputed to the "Results" directory within the project directory, InfantCRefAnalysis.

These scripts have been tested for Windows 10, Matlab 2020a.  