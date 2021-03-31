% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

function zoff = choose_xoff_cramer(qmets)
for jj = 1:length(qmets.names)
switch qmets.names{jj} 
    case 'GABA'
        zoff(jj) = 0.01;
    case 'tNAA'
        zoff(jj) = 0.02;
    case 'NAA'
        zoff(jj) = 0;
    case 'tCr'
        zoff(jj) = 0;
    case 'Cho'
        zoff(jj) =  0.03;
    case 'Ins'
       zoff(jj) = 0;
    case 'Glx'
        zoff(jj) = 0.03;
    case 'Glu'
        zoff(jj) = 0;
    case 'GSH'
        zoff(jj) = 0.035;
    case 'Tau'
        zoff(jj) = 0;
end
end
end
