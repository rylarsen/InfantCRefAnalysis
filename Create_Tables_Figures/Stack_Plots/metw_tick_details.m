% AUTHOR : Ryan Larsen
% Copyright (c) 2021, University of Illinois at Urbana-Champaign. All rights reserved.


switch my_met_name
    
    case 'GABA'
        %ylim([1 1.8])
        set(gca,'YTick',[0.7 0.9])
    case 'tNAA'
        %ylim([3.2 7.8])
        set(gca,'YTick',[3 4])
    case 'NAA'
        %ylim([1.7 6.3])
        set(gca,'YTick',[2 3 4])
    case 'tCr'
        %ylim([3.2 5])
        set(gca,'YTick',[2.5 3.0])
    case 'PCr'
        %ylim([1 4])
        set(gca,'YTick',[2 3])
    case 'Cho'
        %ylim([1.2 2.1])
        set(gca,'YTick',[1 1.2])
    case 'Ins'
        %ylim([3 9])
        set(gca,'YTick',[3 4 5])
    case 'Glx'
        %ylim([3 8])
        set(gca,'YTick',[2 3])
    case 'Glu'
        %ylim([1.5 5])
        set(gca,'YTick',[2 3])
    case 'GSH'
        %ylim([1 2.2])
        %set(gca,'YTick',[1.5 2])
    case 'Tau'
        %ylim([1 3.2])
        set(gca,'YTick',[0.5 1 1.5])
        
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