%%
clear all
close all
clc

%%
current_path = pwd;
cd ..
addpath([pwd, filesep, 'IQA metric analysis'])
cd(current_path)

%% MaxPol-1
load('validPic.mat');
load('kernel_sheets.mat');

% Alpha = [.7: .1: 3];
% Beta = [.8: .1: 2];
cutoff_index = 13; %[2:6:26]; 13 (first kernel), 2 (second kernle)
beta_index = 7; %[1:4:13]; % 7 (first kernel), 13 (second kernel)
alpha_index = 11; %[1:6:24]; % 11 (first kernel), 7 (second kernel)
selected_sheets(1) = squeeze(kernel_sheets(beta_index, alpha_index, cutoff_index));

params.kernel_sheets = selected_sheets(:);
params.moment = 6; %[2:2:10]; % 6 (first kernel), 10 (second kernel)


%% MaxPol-2
load('validPic.mat');
load('kernel_sheets.mat');
cutoff_index = 13; %[2:6:26]; 13 (first kernel), 2 (second kernle)
beta_index = 7; %[1:4:13]; % 7 (first kernel), 13 (second kernel)
alpha_index = 11; %[1:6:24]; % 11 (first kernel), 7 (second kernel)
selected_sheets(1) = squeeze(kernel_sheets(beta_index, alpha_index, cutoff_index));
cutoff_index = 26; %[2:6:26]; 13 (first kernel), 26 (second kernle)
beta_index = 1; %[1:4:13]; % 7 (first kernel), 1 (second kernel)
alpha_index = 1; %[1:6:24]; % 11 (first kernel), 1 (second kernel)
selected_sheets(2) = squeeze(kernel_sheets(beta_index, alpha_index, cutoff_index));

params.kernel_sheets = selected_sheets(:);
params.moment = [6, 2]; %[2:2:10]; % 6 (first kernel), 2 (second kernel)

%%
for iteration = 1:size(validPic,2)
    fprintf(['iteration = ', num2str(iteration), '\n'])
    picPath = [char(validPic{3,iteration})];
    %image_call = ['/home/zach/Documents/database/CID2013', picPath(end-7:end), filesep, char(strcat(validPic{1,iteration},'.jpg'))];
    %image_call = ['E:\research2018\Focus Quality Documents for Zach\database\CID2013', picPath(end-7:end), filesep, char(strcat(validPic{1,iteration},'.jpg'))];
    % image_call = ['F:\Dropbox\UofT Dropbox Data\Journal Publications\data\CID2013', picPath(end-7:end), filesep, char(strcat(validPic{1,iteration},'.jpg'))];
     image_call = ['C:\Users\mhosseini\Dropbox\UofT Dropbox Data\Journal Publications\data\CID2013', picPath(end-7:end), filesep, char(strcat(validPic{1,iteration},'.jpg'))];
    image_scan = imread(image_call);
    
    image_scan = rgb2gray(image_scan);
    image_scan = im2single(image_scan);
    
    input_data.data = image_scan;
    input_data.blockSize = size(image_scan);
    score(iteration, :) = HVS_focus_scoring(input_data, params);
end


%% Compute Result
load('CIDSub.mat');
score(404, :) = [];
dataNew(404) = [];
score = double(score);

%%
% alpha = findAlpha(score, -dataNew(:));
[plcc, srcc, krcc, rmse, y_hat] = IQA_measure(score(:, 1), -dataNew);

do_export = false;
compression_factor = '-q120';

% Make scatter plot
x = score;
plot(-dataNew, x, 'o', 'Color', [.9 .3 0])
hold on
[x_sort, indx_sort] = sort(x);
plot(y_hat(indx_sort), x_sort, 'k')

box on
xlabel('Subjective Score')
ylabel('Objective Score')
set(gca, 'YScale', 'linear', 'FontSize', 13)
axis tight
axis square
if do_export
    export_fig([pwd, filesep, 'CID2013_Score_Plot_MaxPol_1kernel.pdf'], ...
        compression_factor, '-transparent')
end
%%
weights = [0.3874; 4.0865];
% computational_complexity = sum(elapsed_time)/sum(size_image)
[plcc, srcc, krcc, rmse, y_hat] = IQA_measure(score * weights, -dataNew);

do_export = true;
compression_factor = '-q120';

% Make scatter plot
x = score * weights;
plot(-dataNew, x, 'o', 'Color', [.9 .3 0])
hold on
[x_sort, indx_sort] = sort(x);
plot(y_hat(indx_sort), x_sort, 'k')

box on
xlabel('Subjective Score')
ylabel('Objective Score')
set(gca, 'YScale', 'linear', 'FontSize', 13)
axis tight
axis square
if do_export
    export_fig([pwd, filesep, 'CID2013_Score_Plot_MaxPol_2kernel.pdf'], ...
        compression_factor, '-transparent')
end



