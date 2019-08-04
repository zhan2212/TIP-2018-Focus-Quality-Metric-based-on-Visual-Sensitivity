%%
clear all
close all
clc

%%
load('validPic.mat');
load('kernel_sheets.mat');
params.kernel_sheets = kernel_sheets;
X_score_CID_june9 = zeros(474,2,26);

%%
for iteration = 400:size(validPic,2)
    fprintf(['iteration = ', num2str(iteration), '\n'])
    picPath = [char(validPic{3,iteration})];
    % image_call = ['/home/zach/Documents/database/CID2013', picPath(end-7:end), filesep, char(strcat(validPic{1,iteration},'.jpg'))];
    %image_call = ['E:\research2018\Focus Quality Documents for Zach\database\CID2013', picPath(end-7:end), filesep, char(strcat(validPic{1,iteration},'.jpg'))];
    image_call = ['F:\Dropbox\UofT Dropbox Data\Journal Publications\data\CID2013', picPath(end-7:end), filesep, char(strcat(validPic{1,iteration},'.jpg'))];
    %image_call = ['D:\Research 2018\database\CID2013', picPath(end-7:end), filesep, char(strcat(validPic{1,iteration},'.jpg'))];
    image_scan = imread(image_call);
    
    image_scan = rgb2gray(image_scan);
    image_scan = im2single(image_scan);
    
    input_data.data = image_scan;
    input_data.blockSize = size(image_scan);
    score = MaxPol_subband_focus_score_5(input_data, params);
    
    if iteration/100 == floor(iteration/100)
        save('X_score_CID_june9.mat','X_score_CID_june9');
    end
    
    X_score_CID_june9(iteration,:,:,:) = score; 
end
if true
    save('X_score_CID_june9.mat','X_score_CID_june9');
end

%% Compute Result
load('X2.mat');
load('CIDSub.mat');

X2(404, :, :, :, :) = [];
dataNew(404) = [];

plccScore2 = zeros(13, 12, 12, 9);
srccScore2 = zeros(13, 12, 12, 9);
krccScore2  = zeros(13, 12, 12, 9);
rmseScore2 = zeros(13, 12, 12, 9);
for cutoff_iter = 1:13 %1:2:26
    for beta_iter = 1:12 %1:12
        disp(beta_iter)
        for alpha_iter = 1:12 %1:2:24
            for momt_iter = 1:9
                if sum(X2(:, cutoff_iter, beta_iter, alpha_iter,momt_iter)) == 120*474
                    continue;
                    disp('120!');
                end
                if sum(isnan(X2(:, cutoff_iter, beta_iter, alpha_iter,momt_iter))) ~= 0
                    continue;
                    disp('Nan!');
                end
                [plcc, srcc, krcc, rmse] = IQA_measure(X2(:, cutoff_iter, beta_iter, alpha_iter,momt_iter),-dataNew);
                plccScore2(cutoff_iter,beta_iter,alpha_iter,momt_iter) = plcc;
                srccScore2(cutoff_iter,beta_iter,alpha_iter,momt_iter) = srcc;
                krccScore2(cutoff_iter,beta_iter,alpha_iter,momt_iter) = krcc;
                rmseScore2(cutoff_iter,beta_iter,alpha_iter,momt_iter) = rmse;
            end
        end
    end
end
save('plccScore2.mat','plccScore2');
save('srccScore2.mat','srccScore2');
save('krccScore2.mat','krccScore2');
save('rmseScore2.mat','rmseScore2');

%% Load Result

load('plccScore2.mat');
load('srccScore2.mat');
load('krccScore2.mat');
load('rmseScore2.mat');

%% Display Result of plcc
cut_off_val = [1,4,10,15,20];
beta_val = [3,6,9,13];
alpha_val = [4,9,14,19,29];

for cutoff_iter =  1:5 %[1,4,10,15,20]
    for beta_iter = 1:4 %[3,6,9,13]
        for alpha_iter = 1:5 %[4,9,14,19,29]
            x = 1:10;
            y = reshape(plccScore(cutoff_iter,beta_iter,alpha_iter,:),[1,10]);
            if sum(plccScore(cutoff_iter,beta_iter,alpha_iter,:)) ~= 0
                figure();
                plot(x,y);
                title(['cutoff:', char(string(cut_off_val(cutoff_iter))), ' beta:', ...
                    char(string(beta_val(beta_iter))), ' alpha:', char(string(alpha_val(alpha_iter)))]);
            end
        end
    end
end

%% Display Result of srcc
for cutoff_iter =  1:5 %[1,4,10,15,20]
    for beta_iter = 1:4 %[3,6,9,13]
        for alpha_iter = 1:5 %[4,9,14,19,29]
            x = 1:30;
            y = reshape(srccScore(cutoff_iter,beta_iter,alpha_iter,:),[1,30]);
            if sum(srccScore(cutoff_iter,beta_iter,alpha_iter,:)) ~= 0
                figure();
                plot(x,y);
                title(['cutoff:', char(string(cut_off_val(cutoff_iter))), ' beta:', ...
                    char(string(beta_val(beta_iter))), ' alpha:', char(string(alpha_val(alpha_iter)))]);
            end
        end
    end
end

%% Display Result of krcc
cut_off_val = [1,4,10,15,20];
beta_val = [3,6,9,13];
alpha_val = [4,9,14,19,29];

for cutoff_iter =  1:5 %[1,4,10,15,20]
    for beta_iter = 1:4 %[3,6,9,13]
        for alpha_iter = 1:5 %[4,9,14,19,29]
            x = 1:30;
            y = reshape(krccScore(cutoff_iter,beta_iter,alpha_iter,:),[1,30]);
            if sum(krccScore(cutoff_iter,beta_iter,alpha_iter,:)) ~= 0
                figure();
                plot(x,y);
                title(['cutoff:', char(string(cut_off_val(cutoff_iter))), ' beta:', ...
                    char(string(beta_val(beta_iter))), ' alpha:', char(string(alpha_val(alpha_iter)))]);
            end
        end
    end
end

%% Display Result of rmse
cut_off_val = [1,4,10,15,20];
beta_val = [3,6,9,13];
alpha_val = [4,9,14,19,29];

for cutoff_iter =  1:5 %[1,4,10,15,20]
    for beta_iter = 1:4 %[3,6,9,13]
        for alpha_iter = 1:5 %[4,9,14,19,29]
            x = 1:30;
            y = reshape(rmseScore(cutoff_iter,beta_iter,alpha_iter,:),[1,30]);
            if sum(rmseScore(cutoff_iter,beta_iter,alpha_iter,:)) ~= 0
                figure();
                plot(x,y);
                title(['cutoff:', char(string(cut_off_val(cutoff_iter))), ' beta:', ...
                    char(string(beta_val(beta_iter))), ' alpha:', char(string(alpha_val(alpha_iter)))]);
            end
        end
    end
end
        
%% Alpha

load('X.mat');
load('CIDSub.mat');
dataNew(404) = [];
selected_index = [2:8]; %[5:10]

plccS = zeros(100,1);
srccS = zeros(100,1);
krccS = zeros(100,1);
rmseS = zeros(100,1);

iter = 0;

for cutoff_iter = 1:5  %[1,4,10,15,20]
    for beta_iter = 1:4 %[3,6,9,13]
        for alpha_iter = 1:5 %[4,9,14,19,24]
            iter = iter + 1;
            x = reshape(X(:,cutoff_iter,beta_iter,alpha_iter,selected_index),[474,size(selected_index,2)]);
            x(404,:) = [];
            alpha = findAlpha(x,-dataNew); %compute the alpha value
            [plcc, srcc, krcc, rmse] = IQA_measure(x*alpha,-dataNew); % compute plcc, srcc,...
            plccS(iter) = plcc;
%             srccS(iter) = srcc;
%             krccS(iter) = krcc;
%             rmseS(iter) = rmse;
            disp(plcc);
%             disp(srcc);
%             disp(krcc);
%             disp(rmse);
        end
    end
end



