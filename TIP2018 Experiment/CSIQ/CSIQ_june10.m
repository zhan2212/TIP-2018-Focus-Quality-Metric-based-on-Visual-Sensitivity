%%
clear all
close all
clc

%%
% path_data = ['E:\research2018\Focus Quality Documents for Zach\database\CSIQ'];
path_data = ['F:\Dropbox\UofT Dropbox Data\Journal Publications\data\CSIQ'];

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
    score_CSIQ(iteration, :,:) = HVS_focus_scoring(input_data, params);
end
save('score_CSIQ.mat','score_CSIQ');