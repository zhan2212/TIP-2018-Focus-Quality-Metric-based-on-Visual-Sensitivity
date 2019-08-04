%%
clear all
close all
clc

%%
current_path = pwd;
cd ..
addpath([pwd, filesep, 'IQA metric analysis'])
cd(current_path)

%%
load('validPic.mat');
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
% xlsPath = 'E:\research2018\Focus Quality Documents for Zach\database\BID\DatabaseGrades.xlsx';
xlsPath = 'F:\Dropbox\UofT Dropbox Data\Journal Publications\data\BID\DatabaseGrades.xlsx';
[trim,txt,raw] = xlsread(xlsPath,'Plan1');
Indx = zeros(586,1);
for i = 1:586
    Indx(i) = raw{i+1,1};
end

%%
for iteration = 1:586
    fprintf(['iteration = ', num2str(iteration), '\n'])
    
    path = "F:\Dropbox\UofT Dropbox Data\Journal Publications\data\BID\DatabaseImage0";
    % path = "D:\Research 2018\database\BID\DatabaseImage0";
    if Indx(iteration) < 10
        picPath = char(path + "00" + string(Indx(iteration)) + ".JPG");
    elseif 100 > Indx(iteration) && Indx(iteration) >= 10
        picPath = char(path + "0" + string(Indx(iteration)) + ".JPG");
    else
        picPath = char(path + string(Indx(iteration)) + ".JPG");
    end
    image_scan = imread(picPath);

    siz = size(image_scan);
    size_image(iteration) = siz(1)*siz(2);
    image_scan = rgb2gray(image_scan);
    image_scan = im2double(image_scan);
     
     
    input_data.data = image_scan;
    input_data.blockSize = size(image_scan);

    X_score_BID_june9(iteration,:,:) = HVS_focus_scoring(input_data, params);
end
score = double(X_score_BID_june9);
save('X_score_june9_BID_second_kernel_study.mat'); 
