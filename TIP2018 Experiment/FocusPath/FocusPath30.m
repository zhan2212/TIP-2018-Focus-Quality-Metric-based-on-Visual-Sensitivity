%%
clear all;
close all;
clc;

%%
% Dirname = 'G:\Pathology Database\FocusPath_full';
% filename = 'G:\Pathology Database\DatabaseInfo.xlsx';
Dirname = 'G:\Pathology Database\FocusPath_full\full database';
filename = 'G:\Pathology Database\FocusPath_full\DatabaseInfo.xlsx';
[trim,txt,raw] = xlsread(filename,'Sheet1');
% sub_values = raw(:,7);
load('indx.mat');

% %% MaxPol-1
% load('kernel_sheets.mat');
% 
% cutoff_index = 19;
% beta_index = 1;
% alpha_index = 1;
% params.kernel_sheets = squeeze(kernel_sheets(beta_index, alpha_index, cutoff_index));
% params.moment = 10;
% 
% %% MaxPol-2
% load('kernel_sheets.mat');
% cutoff_index = 19; %[2:6:26]; 13 (first kernel), 2 (second kernle)
% beta_index = 1; %[1:4:13]; % 7 (first kernel), 13 (second kernel)
% alpha_index = 1; %[1:6:24]; % 11 (first kernel), 7 (second kernel)
% selected_sheets(1) = squeeze(kernel_sheets(beta_index, alpha_index, cutoff_index));
% cutoff_index = 21; %[2:6:26]; 13 (first kernel), 26 (second kernle)
% beta_index = 2; %[1:4:13]; % 7 (first kernel), 1 (second kernel)
% alpha_index = 1; %[1:6:24]; % 11 (first kernel), 1 (second kernel)
% selected_sheets(2) = squeeze(kernel_sheets(beta_index, alpha_index, cutoff_index));
% 
% params.kernel_sheets = selected_sheets(:);
% params.moment = [10, 6]; %[2:2:10]; % 6 (first kernel), 2 (second kernel)

%% MLV
current_path = pwd;
cd ..
cd ..
cd ..
MLV_path = [pwd, filesep, 'third party codes', filesep, ...
    'MaximumLocalVariation', filesep, 'MaximumLocalVariationCode'];

%%
files = dir(Dirname);
score = zeros(numel(files)-2,1);
sub_score = zeros(numel(files)-2, 1);

iteration = 0;
for i = indx 
    iteration = iteration + 1;
    disp(iteration);
    fileName = files(i+2).name;
    splitName = strsplit(fileName,'_');
    
%     slideNum = str2double(splitName{1}(6:7)); % out of 9
%     stripNum = str2double((splitName{2}(6:7)))+1; % out of 2
%     sliceNum = str2double(splitName{3}(6:7)); % out of 16
%     positionNum = str2double(splitName{4}(9:10));
    
    image_scan = imread([Dirname,filesep,fileName]);
    image_scan = im2double(rgb2gray(image_scan));
%     input_data.data = image_scan;
    
    MLV_score30(iteration) = MLVSharpnessMeasure(image_scan);
%     HVS_MaxPol_2_score30(iteration,:) = HVS_focus_scoring(input_data, params);
%     HVS_MaxPol_1_score30(iteration,:) = HVS_focus_scoring(input_data, params);
    
end

% save('HVS_MaxPol_1_score30.mat','HVS_MaxPol_1_score30');
save('MLV_score30.mat','MLV_score30');