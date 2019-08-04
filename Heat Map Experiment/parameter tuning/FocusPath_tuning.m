%%
clear all;
close all;
clc;

%%
% Dirname = 'E:\research2018\Focus Quality Documents for Zach\database\FocusPath\FocusPath';
% filename = 'E:\research2018\Focus Quality Documents for Zach\database\FocusPath\DatabaseInfo.xlsx';
% Dirname = 'E:\database\FocusPath\FocusPath';
% filename = 'E:\database\FocusPath\DatabaseInfo.xlsx';
Dirname = 'D:\Research 2018\database\FocusPath\FocusPath';
filename = 'D:\Research 2018\database\FocusPath\DatabaseInfo.xlsx';

%% MaxPol-1
load('kernel_sheets.mat');

cutoff_index = 25; %26; 
beta_index = 1; %1; 
alpha_index =  13; %16; 
params.kernel_sheets = squeeze(kernel_sheets(beta_index, alpha_index, cutoff_index));
params.moment = 2; %2 

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
 
%     iB = image_scan(:,:,1)<.95 & image_scan(:,:,2)<.95 & image_scan(:,:,3)<.95;
    image_scan = rgb2gray(image_scan);
    image_scan = im2single(image_scan);
    
    input_data.data = image_scan;
    
    score(iteration,:) = double(HVS_MaxPol_1_pathology(input_data, params));
    
%     if iteration/50 == floor(iteration/50)
%         save('X_score_FocusPath5.mat','X_score_FocusPath5');
%     end
        
   
end

% X_score_FocusPath5 = double(X_score_FocusPath5);
% save('X_score_FocusPath5.mat','X_score_FocusPath5');
