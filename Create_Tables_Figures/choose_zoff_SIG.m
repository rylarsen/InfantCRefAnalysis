% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.

function zoff = choose_xoff_SIG(qmets)
for jj = 1:length(qmets.names)
switch qmets.names{jj} 
    case 'GABA'
        zoff(jj) = 0.03;
    case 'tNAA'
        zoff(jj) = 0.045;
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
        zoff(jj) = 0.025;
    case 'Tau'
        zoff(jj) = 0;
end
end
end
