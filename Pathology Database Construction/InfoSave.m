% This script is used to save the information of the database in the mat
% file

%%
clear all;
load('DataScore.mat');
load('Zi.mat');
current_path = pwd;
Dirname = [current_path, filesep, 'FocusPa'];
files = dir(Dirname);

Info = cell(865,7);
% Info = cell(8641,7);
Info(1,:) = {'Name','Slide #','Strip #','Slice #','Position #','Objective Score','Subjective Score'};
    

for i = 2 :865 % 8641
    if i/100 == floor(i/100)
        disp(i);
    end
    filename = files(i+1).name;
    splitName = strsplit(filename,'_');
    
    slideIndx = str2double(splitName{1}(6:7)); % out of 9
    stripIndx = str2double(splitName{2}(6:7))+1; % out of 2
    sliceIndx = str2double(splitName{3}(6:7)); % out of 16
    positionIndx = str2double(splitName{4}(9:10)); % out of 30
    
    Subscore = sliceIndx - Zi(slideIndx,stripIndx,positionIndx);
    Obscore = DataScore(slideIndx,stripIndx,sliceIndx,positionIndx); 
    
    Info{i,1} = filename;
    Info{i,2} = slideIndx;
    Info{i,3} = stripIndx-1;
    Info{i,4} = sliceIndx;
    Info{i,5} = positionIndx;
    Info{i,6} = Obscore;
    Info{i,7} = Subscore;

end
xlswrite('DatabaseInfo2.xlsx',Info);