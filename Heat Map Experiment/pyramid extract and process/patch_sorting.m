%%
clear all;
close all;
clc;

%%
load('HVS_score.mat'); % [i_start, i_end, j_start, j_end, iteration_pos, score, projectedScore];

%% show 10 image patches
sortedScore = sortrows(HVS_scores,6);
for i = 1:10 
    indx = floor(size(sortedScore,1)*i/10);
    iteration_pos = sortedScore(indx,5);
    patchName = 'index_'+ num2str(iteration_pos)+ '.tif';
    disp(patchName);
end