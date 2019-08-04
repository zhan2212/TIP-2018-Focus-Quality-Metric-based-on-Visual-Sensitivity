%%
clear all
close all
clc

%%
path_data = ['E:\research2018\Focus Quality Documents for Zach\database\TID2013'];

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
    mos_score(iteration) = str2num(mos_info{iteration}(1:7));
    image_ID(iteration) = str2num(mos_info{iteration}(10:11));
    blur_ID(iteration) = str2num(mos_info{iteration}(13:14));
    blur_type(iteration) = str2num(mos_info{iteration}(16));
end
blur_indx = find(blur_ID==8);
image_ID = image_ID(blur_indx);
blur_type = blur_type(blur_indx);
subjective_score = mos_score(blur_indx);

%% 
load('kernel_sheets_odd.mat');
% Alpha = [.7: .1: 3];
% Beta = [.8: .1: 2];
cutoff_index = [2:4:26]; %13
beta_index = [1:3:13]; %7
alpha_index = [1:4:24]; %11
selected_sheets = squeeze(kernel_sheets_odd(beta_index, alpha_index, cutoff_index));
params.kernel_sheets = selected_sheets(:);
params.moment = [2:2:20]; %6

%%
for iteration = 1: numel(dir_data)
    fprintf(['iteration = ', num2str(iteration), '\n'])
    image_call = [path_data, filesep, 'distorted_images', ...
        filesep, dir_data(iteration).name];
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
    score_TID2013(iteration, :,:) = HVS_focus_scoring(input_data, params);
end
save('score_TID2013.mat','score_TID2013');