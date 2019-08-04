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

% xlsPath = 'F:\Dropbox\UofT Dropbox Data\Journal Publications\data\BID\DatabaseGrades.xlsx';
xlsPath = 'E:\research2018\Focus Quality Documents for Zach\database\BID\DatabaseGrades.xlsx';
% xlsPath = 'D:\Research 2018\database\BID\DatabaseGrades.xlsx';

[trim,txt,raw] = xlsread(xlsPath,'Plan1');

for i =1:586
    sub_score(i) = abs(raw{i+1,2});
end

%%

[trim,txt,raw] = xlsread(xlsPath,'Plan1');
Indx = zeros(586,1);
for i = 1:586
    Indx(i) = raw{i+1,1};
end

%% MaxPol-1

% Alpha = [.7: .1: 3];
% Beta = [.8: .1: 2];
cutoff_index =  13; %[2:6:26]; %13
beta_index = 7; %[1:4:13]; %7
alpha_index = 11; %[1:6:24]; %11
selected_sheets = squeeze(kernel_sheets(beta_index, alpha_index, cutoff_index));
params.kernel_sheets = selected_sheets(:);
params.moment = 6; %[2:2:10]; %6

%% MaxPol-2
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
for iteration = 1:586
    fprintf(['iteration = ', num2str(iteration), '\n'])
    
    % path = "F:\Dropbox\UofT Dropbox Data\Journal Publications\data\BID\DatabaseImage0";
    path = "E:\research2018\Focus Quality Documents for Zach\database\BID\DatabaseImage0";
%     path= "D:\Research 2018\database\BID\DatabaseImage0";
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

    score(iteration,:) = double(HVS_focus_scoring(input_data, params));
end

%% MaxPol-1 Result
[plcc, srcc, krcc, rmse, y_hat] = IQA_measure(score, abs(sub_score'));

do_export = true;
compression_factor = '-q120';

% Make scatter plot
x = score;
plot(-abs(sub_score'), x, 'o', 'Color', [.9 .3 0])
hold on
[x_sort, indx_sort] = sort(x);
plot(-y_hat(indx_sort), x_sort, 'k')

box on
xlabel('Subjective Score')
ylabel('Objective Score')
set(gca, 'YScale', 'linear', 'FontSize', 13)
axis tight
axis square
if do_export
    export_fig([pwd, filesep, 'BID_Score_Plot_MaxPol_1kernel.pdf'], ...
        compression_factor, '-transparent')
end

%% MaxPol-2 Result
weights = [0.3874; 4.0865];
[plcc, srcc, krcc, rmse, y_hat] = IQA_measure(score * weights, abs(sub_score'));

do_export = true;

% Make scatter plot
x = score * weights;
plot(-abs(sub_score'), x, 'o', 'Color', [.9 .3 0])
hold on
[x_sort, indx_sort] = sort(x);
plot(-y_hat(indx_sort), x_sort, 'k')

box on
xlabel('Subjective Score')
ylabel('Objective Score')
set(gca, 'YScale', 'linear', 'FontSize', 13)
axis tight
axis square
if do_export
    export_fig([pwd, filesep, 'BID_Score_Plot_MaxPol_2kernel.pdf'], ...
        '-q120', '-transparent')
end