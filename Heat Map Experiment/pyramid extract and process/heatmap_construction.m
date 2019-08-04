%%
clear all;
close all;
clc;
%%
load('pyramid result\015\HVS_scores.mat');
load('pyramid result\015\size.mat');

%%
heatMap = zeros(size(I));
heatMap_projected = zeros(size(I));
maximum = 5.5805;

for i = 1:size(HVS_scores,1)
    x_Indx = double(HVS_scores(i,1));
    y_Indx = double(HVS_scores(i,2));
    score = HVS_scores(i,4);
    projectedScore = inverse_gaussian_projection(maximum - score); 
    if x_Indx ~= 0 && y_Indx ~= 0
        heatMap(x_Indx,y_Indx) = double(score);
        heatMap_projected(x_Indx, y_Indx) = double(projectedScore);
    end
end

%%
% heatMap(heatMap==0) = nan;
% imagesc(heatMap, [0,5]);

figure();
heatMap_projected(heatMap_projected==0) = nan;
imagesc(heatMap_projected, [0,5]);
axis image
colorbar


