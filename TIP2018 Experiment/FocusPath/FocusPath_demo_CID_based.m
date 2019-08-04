%%
clear all;
close all;
clc;

%%
% Dirname = 'E:\research2018\Focus Quality Documents for Zach\database\FocusPath2';
% filename = 'E:\research2018\Focus Quality Documents for Zach\database\DatabaseInfo2.xlsx';
Dirname = 'E:\database\FocusPath\FocusPath';
filename = 'E:\database\FocusPath\DatabaseInfo.xlsx';

%%
current_cd = pwd;
cd ..
addpath([pwd, filesep, 'IQA metric analysis'])
cd(current_cd)

%%
load('kernel_sheets.mat');

[trim,txt,raw] = xlsread(filename,'Sheet1');
sub_values = raw(:,6);

%%
% Alpha = [.7: .1: 3];
% Beta = [.8: .1: 2];
cutoff_index = 13; %[2:6:26]; 13 (first kernel), 2 (second kernle)
beta_index = 7; %[1:4:13]; % 7 (first kernel), 13 (second kernel)
alpha_index = 11; %[1:6:24]; % 11 (first kernel), 7 (second kernel)
selected_sheets(1) = squeeze(kernel_sheets(beta_index, alpha_index, cutoff_index));
cutoff_index = 2; %[2:6:26]; 13 (first kernel), 2 (second kernle)
beta_index = 13; %[1:4:13]; % 7 (first kernel), 13 (second kernel)
alpha_index = 7; %[1:6:24]; % 11 (first kernel), 7 (second kernel)
selected_sheets(2) = squeeze(kernel_sheets(beta_index, alpha_index, cutoff_index));

params.kernel_sheets = selected_sheets(:);
params.moment = [6, 10]; %[2:2:10]; % 6 (first kernel), 10 (second kernel)

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
    score(iteration,:) = HVS_focus_scoring_June_9(input_data, params);
    elapsed_time(iteration) = toc;
    sub_score(iteration,:) = double(sub_values{iteration+1});    
end
score = double(score);

%% 
alpha = [65.5667;   -7.3913];
[plcc, srcc, krcc, rmse] = IQA_measure(score * alpha, abs(sub_score))



