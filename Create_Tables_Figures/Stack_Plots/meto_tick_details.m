% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.


switch my_met_name
    
    case 'GABA'
        %ylim([1 1.8])
        set(gca,'YTick',[3 4 5])
    case 'tNAA'
        %ylim([3.2 7.8])
        set(gca,'YTick',[2 3])
    case 'NAA'
        %ylim([1.7 6.3])
        set(gca,'YTick',[1.5 2.5])
    case 'tCr'
        %ylim([3.2 5])
        set(gca,'YTick',[1.5 2.5])
    case 'Cho'
        %ylim([1.2 2.1])
        set(gca,'YTick',[0.4 0.6 0.8])
    case 'Ins'
        %ylim([3 9])
        set(gca,'YTick',[1 2 3])
    case 'Glx'
        %ylim([3 8])
        set(gca,'YTick',[1 2])
    case 'Glu'
        %ylim([1.5 5])
        set(gca,'YTick',[1 2])
    case 'GSH'
        %ylim([1 2.2])
        set(gca,'YTick',[0.4 0.6 0.8])
    case 'Tau'
        %ylim([1 3.2])
        set(gca,'YTick',[0.6 0.8 1])
        
%     case 'ML09'
%         ylim([1 10])
%         set(gca,'YTick',[4 7])
%         
%     case 'ML13'
%         ylim([0 20])
%         set(gca,'YTick',[5 15])
%     case 'ML20'
%         ylim([1 8])
%         set(gca,'YTick',[3 6])
%         %
end

%  set(gca,'YTick',[0, 500, 1000,  1500])
%  set(gca,'XTick',[1 2 3])
%  set(gca,'XTickLabel',{'Light';'Heavy';'Light'})