%%
clear all
close all
clc

%%
path_data = ['E:\research2018\Focus Quality Documents for Zach\database\TID2008'];
% path_data = ['D:\Research 2018\database\TID2008'];

%%
dir_data = dir([path_data, filesep, 'distorted_images']); dir_data = dir_data(3:end);
for iteration = 1: numel(dir_data)
    dist_idx(iteration) = str2num(dir_data(iteration).name(5:6));
end
blur_indx = find(dist_idx==8);
dir_data = dir_data(blur_indx);
%
mos_info = importdata([path_data, filesep, 'mos_with_names.txt']);
%
for iteration = 1: numel(mos_info)
    mos_score(iteration) = str2num(mos_info{iteration}(1:6));
    image_ID(iteration) = str2num(mos_info{iteration}(9:10));
    blur_ID(iteration) = str2num(mos_info{iteration}(12:13));
    blur_type(iteration) = str2num(mos_info{iteration}(15));
end
blur_indx = find(blur_ID==8);
image_ID = image_ID(blur_indx);
blur_type = blur_type(blur_indx);
subjective_score = mos_score(blur_indx);

%% MaxPol-1
load('kernel_sheets.mat');

cutoff_index = 19;
beta_index = 1;
alpha_index = 1;
params.kernel_sheets = squeeze(kernel_sheets(beta_index, alpha_index, cutoff_index));
params.moment = 10;

%% MaxPol-2
load('kernel_sheets.mat');
cutoff_index = 19; %[2:6:26]; 13 (first kernel), 2 (second kernle)
beta_index = 1; %[1:4:13]; % 7 (first kernel), 13 (second kernel)
alpha_index = 1; %[1:6:24]; % 11 (first kernel), 7 (second kernel)
selected_sheets(1) = squeeze(kernel_sheets(beta_index, alpha_index, cutoff_index));
cutoff_index = 21; %[2:6:26]; 13 (first kernel), 26 (second kernle)
beta_index = 2; %[1:4:13]; % 7 (first kernel), 1 (second kernel)
alpha_index = 1; %[1:6:24]; % 11 (first kernel), 1 (second kernel)
selected_sheets(2) = squeeze(kernel_sheets(beta_index, alpha_index, cutoff_index));

params.kernel_sheets = selected_sheets(:);
params.moment = [10, 6]; %[2:2:10]; % 6 (first kernel), 2 (second kernel)

%%
for iteration = 1: numel(dir_data)
    fprintf(['iteration = ', num2str(iteration), '\n'])
    image_call = [path_data, filesep, 'distorted_images', ...
        filesep, dir_data(iteration).name];
    image_scan = imread(image_call);
    siz = size(image_scan);
    size_image(iteration) = siz(1)*siz(2);
    image_scan = rgb2gray(image_scan);
    %     image_scan = double(image_scan);
    image_scan = im2double(image_scan);
    
    input_data.data = image_scan;
    input_data.blockSize = size(image_scan);
    %
    tic;
    score(iteration, :) = HVS_focus_scoring(input_data, params);
    elapsed_time(iteration) = toc;
end

%% 1 Kernel
computational_complexity = sum(elapsed_time)/sum(size_image)
[plcc, srcc, krcc, rmse, y_hat] = IQA_measure(score(:, 1), subjective_score(:));

do_export = true;
compression_factor = '-q120';

% Make scatter plot
x = score(:, 1);
plot(-subjective_score(:), x, 'o', 'Color', [.9 .3 0]);
hold on
[x_sort, indx_sort] = sort(x);
plot(-y_hat(indx_sort), x_sort, 'k');

box on
xlabel('Subjective Score')
ylabel('Objective Score')
set(gca, 'YScale', 'linear', 'FontSize', 13)
axis tight
axis square
if do_export
    export_fig([pwd, filesep, 'TID2008_Score_Plot_MaxPol_1Kernel.pdf'], ...
        compression_factor, '-transparent')
end

%% MaxPol-2 Result
weights = [0.3341; -0.1195];
computational_complexity = sum(elapsed_time)/sum(size_image)
[plcc, srcc, krcc, rmse, y_hat] = IQA_measure(score * weights, subjective_score(:));

do_export = true;
compression_factor = '-q120';

% Make scatter plot
x = score*weights;
plot(-subjective_score(:), x, 'o', 'Color', [.9 .3 0]);
hold on
[x_sort, indx_sort] = sort(x);
plot(-y_hat(indx_sort), x_sort, 'k');

box on
xlabel('Subjective Score')
ylabel('Objective Score')
set(gca, 'YScale', 'linear', 'FontSize', 13)
axis tight
axis square
if do_export
    export_fig([pwd, filesep, 'TID2008_Score_Plot_MaxPol_2Kernel.pdf'], ...
        compression_factor, '-transparent')
end