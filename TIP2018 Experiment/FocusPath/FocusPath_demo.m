%%
clear all;
close all;
clc;

%%
% Dirname = 'E:\research2018\Focus Quality Documents for Zach\database\FocusPath\FocusPath';
% filename = 'E:\research2018\Focus Quality Documents for Zach\database\FocusPath\DatabaseInfo.xlsx';
Dirname = 'E:\database\FocusPath\FocusPath';
filename = 'E:\database\FocusPath\DatabaseInfo.xlsx';
% Dirname = 'D:\Research 2018\database\FocusPath\FocusPath';
% filename = 'D:\Research 2018\database\FocusPath\DatabaseInfo.xlsx';

%%
current_cd = pwd;
cd ..
addpath([pwd, filesep, 'IQA metric analysis'])
cd(current_cd)

%%
load('kernel_sheets.mat');

[trim,txt,raw] = xlsread(filename,'Sheet1');
sub_values = raw(:,6);

%% MaxPol-1
load('kernel_sheets.mat');

cutoff_index = 13;
beta_index = 7;
alpha_index = 11;
params.kernel_sheets = squeeze(kernel_sheets(beta_index, alpha_index, cutoff_index));
params.moment = 6;

%% MaxPol-2
load('kernel_sheets.mat');
cutoff_index = 13; %[2:6:26]; 13 (first kernel), 2 (second kernle)
beta_index = 7; %[1:4:13]; % 7 (first kernel), 13 (second kernel)
alpha_index = 11; %[1:6:24]; % 11 (first kernel), 7 (second kernel)
selected_sheets(1) = squeeze(kernel_sheets(beta_index, alpha_index, cutoff_index));

cutoff_index = 26; %[2:6:26]; 13 (first kernel), 26 (second kernle)
beta_index = 1; %[1:4:13]; % 7 (first kernel), 1 (second kernel)
alpha_index = 11; %[1:6:24]; % 11 (first kernel), 1 (second kernel)
selected_sheets(2) = squeeze(kernel_sheets(beta_index, alpha_index, cutoff_index));

params.kernel_sheets = selected_sheets(:);
params.moment = [6, 2]; %[2:2:10]; % 6 (first kernel), 2 (second kernel)

%%
files = dir(Dirname);
sub_score = zeros(numel(files)-2, 1);

for iteration = 1:numel(files)-2
    disp(iteration);
    fileName = files(iteration+2).name;
    splitName = strsplit(fileName,'_');
    % disp(fileName);
    
    slideNum = str2double(splitName{1}(6:7)); % out of 16
    stripNum = str2double((splitName{2}(6:7)))+1; % out of 2
    sliceNum = str2double(splitName{3}(6:7)); % out of 16
    positionNum = str2double(splitName{4}(9:10));
    
    image_scan = imread([Dirname,filesep,fileName]);
    siz = size(image_scan);
    size_image(iteration) = siz(1)*siz(2);
    image_scan = rgb2gray(image_scan);
    image_scan = im2single(image_scan);
    
    input_data.data = image_scan;
    input_data.blockSize = size(image_scan);
    
    tic;
    score(iteration,:) = HVS_focus_scoring(input_data, params);
    elapsed_time(iteration) = toc;
    sub_score(iteration,:) = double(sub_values{iteration+1});    
end
score = double(score);

if false
    %save('X_score_june10_FocusPath_second_kernel_study.mat');
    %save('X_score_june10_FocusPath_first_kernel_study.mat');
end

%% MaxPol-1
computational_complexity = sum(elapsed_time)/sum(size_image)
[plcc, srcc, krcc, rmse, y_hat] = IQA_measure(score, abs(sub_score));

do_export = false;
compression_factor = '-q120';

% Make scatter plot
x = score;
plot(abs(sub_score), x, 'o', 'Color', [.9 .3 0])
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
    export_fig([pwd, filesep, 'FocusPath_Score_Plot_MaxPol_1kernel.pdf'], ...
        compression_factor, '-transparent')
end


%% MaxPol-2
weights = [0.3874; 4.0865];
computational_complexity = sum(elapsed_time)/sum(size_image)
[plcc, srcc, krcc, rmse, y_hat] = IQA_measure(score * weights, abs(sub_score));

do_export = false;
compression_factor = '-q120';

% Make scatter plot
x = score * weights;
plot(abs(sub_score), x, 'o', 'Color', [.9 .3 0])
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
    export_fig([pwd, filesep, 'FocusPath_Score_Plot_MaxPol_2kernel.pdf'], ...
        compression_factor, '-transparent')
end

