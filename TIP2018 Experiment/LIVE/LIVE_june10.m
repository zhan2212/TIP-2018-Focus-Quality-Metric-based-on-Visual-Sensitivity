%%
clear all
close all
clc

%%
path_data = ['F:\Dropbox\UofT Dropbox Data\Journal Publications\data\LIVE', filesep, 'gblur'];

%%
dir_data = dir([path_data, filesep, 'data']); dir_data = dir_data(3:end);
for iteration = 1: numel(dir_data)
    image_name = dir_data(iteration).name;
    image_ID(iteration) = str2num(image_name(4:end-4));
end
[~, sorting_index] = sort(image_ID, 'ascend');
dir_data = dir_data(sorting_index);
%
mos_info = importdata([path_data, filesep, 'info.txt']);
for iteration = 1: numel(mos_info.data)
    mos_ID(iteration) = str2num(mos_info.textdata{iteration,2}(4:end-4));
end
[~, sorting_index] = sort(mos_ID, 'ascend');
%
mos_info.data = mos_info.data(sorting_index);
mos_info.textdata = mos_info.textdata(sorting_index, :);

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
for iteration = 1: 145
    fprintf(['iteration = ', num2str(iteration), '\n'])
    image_call = [path_data, filesep, 'data', filesep, dir_data(iteration).name];
    image_scan = imread(image_call);
    siz = size(image_scan);
    size_image(iteration) = siz(1)*siz(2);
    image_scan = rgb2gray(image_scan);
    %image_scan = double(image_scan);
    image_scan = im2double(image_scan);
    
    input_data.data = image_scan;
    input_data.blockSize = size(image_scan);
    %
    score_LIVE(iteration, :,:) = HVS_focus_scoring(input_data, params);
end
save('score_LIVE.mat','score_LIVE');