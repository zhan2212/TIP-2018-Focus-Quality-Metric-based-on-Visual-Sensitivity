%%
clear all
close all
clc

%%
path_data = ['E:\research2018\Focus Quality Documents for Zach\database\CSIQ'];
% path_data = ['D:\Research 2018\database\CSIQ'];

%%
dir_data = dir([path_data, filesep, 'blur']); dir_data = dir_data(3:end);
for iteration = 1: numel(dir_data)
    data_info{iteration, 1} = dir_data(iteration).name(1:end-11);
    data_info{iteration, 2} = dir_data(iteration).name(end-4);
end
%
mos_info = importdata([path_data, filesep, 'csiqDMOS.xlsx']);
blur_indexes = find(mos_info.data.all_by_image(:, 2) == 5);
subjective_level = mos_info.data.all_by_image(blur_indexes, 4);
subjective_score = mos_info.data.all_by_image(blur_indexes, 6);
subjective_name = mos_info.textdata.all_by_image(blur_indexes,1);
%  artificialy genereate 1600 names
for iteration = 1: 5
    subjective_name{iteration} = num2str(1600);
end

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
for iteration = 1: numel(subjective_name)
    fprintf(['iteration = ', num2str(iteration), '\n'])
    image_call = [path_data, filesep, 'blur', filesep, dir_data(iteration).name];
    image_scan = imread(image_call);
    siz = size(image_scan);
    size_image(iteration) = siz(1)*siz(2);
    image_scan = rgb2gray(image_scan);
    %image_scan = double(image_scan);
    image_scan = im2double(image_scan);
    
    if false
        sigma = 0.03;
        randn('seed',0);
        image_scan = image_scan + sigma*randn(size(image_scan));
    end
    
    input_data.data = image_scan;
    input_data.blockSize = size(image_scan);
    %
    tic;
    score(iteration, :) = HVS_focus_scoring(input_data, params);
    elapsed_time(iteration) = toc;
end

%% 1 Kernel
computational_complexity = sum(elapsed_time)/sum(size_image)
[plcc, srcc, krcc, rmse, y_hat] = IQA_measure(score, subjective_score);

do_export = true;
compression_factor = '-q120';

% Make scatter plot
x = score;
plot(subjective_score, x, 'o', 'Color', [.9 .3 0])
hold on
[x_sort, indx_sort] = sort(x);
plot(y_hat(indx_sort), x_sort, 'k')

box on
xlabel('Subjective Score')
ylabel('Objective Score')
set(gca, 'YScale', 'linear', 'FontSize', 13)
axis square
if do_export
    export_fig([pwd, filesep, 'CSIQ_Score_Plot_MaxPol_1kernel.pdf'], ...
        compression_factor, '-transparent')
end

%% MaxPol-2 Result
weights = [0.3341; -0.1195];
computational_complexity = sum(elapsed_time)/sum(size_image)
[plcc, srcc, krcc, rmse, y_hat] = IQA_measure(score * weights, subjective_score);

do_export = true;
compression_factor = '-q120';

% Make scatter plot
x = score * weights;
plot(subjective_score, x, 'o', 'Color', [.9 .3 0])
hold on
[x_sort, indx_sort] = sort(x);
plot(y_hat(indx_sort), x_sort, 'k')

box on
xlabel('Subjective Score')
ylabel('Objective Score')
set(gca, 'YScale', 'linear', 'FontSize', 13)
axis square
if do_export
    export_fig([pwd, filesep, 'CSIQ_Score_Plot_MaxPol_2kernel.pdf'], ...
        compression_factor, '-transparent')
end
