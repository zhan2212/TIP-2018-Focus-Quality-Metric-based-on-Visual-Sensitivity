%%
clear all;
close all;
clc;

%%
Dirname = 'F:\Pathology Database\Customer_slides';
load('Positions.mat');

%%
for slide = 1:9
    disp(slide);
    for strip = 1:2
        for k = 1
            position = Positions{slide,strip,k};
            x1 = position(1);
            x2 = position(2);
            y1 = position(3);
            y2 = position(4);
            
            % original
            fileName = 'Slide0'+string(slide)+'_Strip0'+string(strip-1);
            filePath = ['result',filesep,char(fileName+'.mat')];
            load(filePath);
            avgScore = double(sum(Profile))/200;
            indexV = 1:16;
            score_ind = [avgScore;indexV]';
            score_ind_sorted = sortrows(score_ind);
        end        
    end
end