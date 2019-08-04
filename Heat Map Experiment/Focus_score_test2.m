% this script is to score the image
%%
clear all;
close all;
clc;

%%
Dirname = 'F:\Pathology Database\Customer_slides';
load('Positions.mat');

%% MaxPol-1
load('kernel_sheets.mat');

cutoff_index = 25; %26; 
beta_index = 1; %1; 
alpha_index =  13; %16; 
params.kernel_sheets = squeeze(kernel_sheets(beta_index, alpha_index, cutoff_index));
params.moment = 2; %2 

%%

for i = 1
    slideNum = char('slide'+string(i));
    Dirname2 = [Dirname, filesep, slideNum]; 
    files = dir(Dirname2);
    
    for j = 3:size(files,1)
        disp(j);
        filename = files(j).name;
        I = imread([Dirname2,filesep,filename]);

        Profiles = zeros(200,16);
        
        splitName = strsplit(filename,'_');
        
        slideIndx = 'Slide' + string(splitName{3}(2:3)); % out of 9
        stripIndx = 'Strip' + string(splitName{7}(1:2)); % out of 2
        if strcmp(stripIndx,'Strip02') || strcmp(stripIndx,'Strip00')
            continue
        end
        sliceIndx = string(splitName{5}); % out of 16
      
        for k = 1:200
            stripNum = str2double(splitName{7}(1:2)) + 1;
            position = Positions{i,stripNum,k};
            x1 = position(1);
            x2 = position(2);
            y1 = position(3);
            y2 = position(4);
            croppedImg = I(x1:x2,y1:y2,:); % dimension of 1024*1024
            
            input_image = im2single(rgb2gray(croppedImg));
            % Score image
            
            score = double(HVS_MaxPol_1_pathology(input_image, params));
            scoreMap(x1:x2,y1:y2) = score;
            
            Profile(k, str2num(splitName{5}(6:7))) = score;
        end 
    end      
    Name = string(slideIndx) + '_Strip01_pathology' + '.mat';
    savePath = ['result',filesep,char(Name)];
    save(savePath,'Profile');
    
end