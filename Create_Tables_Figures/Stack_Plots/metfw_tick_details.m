% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.


switch my_met_name
    
    case 'GABA'
        %ylim([1 1.8])
        set(gca,'YTick',[1.1 1.4])
    case 'tNAA'
        %ylim([3.2 7.8])
        set(gca,'YTick',[4 5 6 7])
    case 'NAA'
        %ylim([1.7 6.3])
        set(gca,'YTick',[3 4 5])
    case 'NAAG'
        %ylim([0.6 1.7])
        set(gca,'YTick',[1.0 1.5])
    case 'tCr'
        %ylim([3.2 5])
        set(gca,'YTick',[4.0 4.5])
    case 'PCr'
        %ylim([1 4])
        set(gca,'YTick',[2 3])
    case 'Cho'
        %ylim([1.2 2.1])
        set(gca,'YTick',[1.5 1.8])
    case 'Ins'
        %ylim([3 9.3])
        set(gca,'YTick',[6 8])
    case 'Glx'
        %ylim([1.8 6.2])
        set(gca,'YTick',[3 4 5])
    case 'Glu'
        %ylim([1.5 5])
        set(gca,'YTick',[2 3 4])
    case 'GSH'
        %ylim([1 2.2])
        set(gca,'YTick',[1.5 2])
    case 'Tau'
        ylim([0.5 3])
        set(gca,'YTick',[1.5 2.5])
end

%  set(gca,'YTick',[0, 500, 1000,  1500])
%  set(gca,'XTick',[1 2 3])
%  set(gca,'XTickLabel',{'Light';'Heavy';'Light'})