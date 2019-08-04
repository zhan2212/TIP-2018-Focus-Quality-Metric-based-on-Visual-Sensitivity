%%
clear all;
close all;
clc;

%%
% Dirname = 'E:\research2018\Focus Quality Documents for Zach\database\FocusPath';
% filename = 'E:\research2018\Focus Quality Documents for Zach\database\DatabaseInfo.xlsx';
Dirname = 'E:\database\FocusPath\FocusPath';
filename = 'E:\database\FocusPath\DatabaseInfo.xlsx';

%%
current_cd = pwd;
cd ..
addpath([pwd, filesep, 'IQA metric analysis'])
cd(current_cd)
%%
load('kernel_sheets.mat');

% Alpha = [.7: .1: 3];
% Beta = [.8: .1: 2];
cutoff_index = [2:6:26]; %13
beta_index = [1:4:13]; %7
alpha_index = [1:6:24]; %11
selected_sheets = squeeze(kernel_sheets(beta_index, alpha_index, cutoff_index));
params.kernel_sheets = selected_sheets(:);
params.moment = [2:2:10]; %6

%%

[trim,txt,raw] = xlsread(filename,'Sheet1');
sub_values = raw(:,6);

%%
files = dir(Dirname);

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
    
    X_score_FocusPath_june9(iteration,:,:) = HVS_focus_scoring(input_data, params);
  
end
score = double(X_score_FocusPath_june9);
% save('X_score_june9_FocusPath_second_kernel_study.mat'); 