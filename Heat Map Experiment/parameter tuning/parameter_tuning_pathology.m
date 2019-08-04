%%
clear all
close all
clc

%%

% Dirname = 'E:\database\FocusPath';
% filename = 'E:\database\FocusPath\DatabaseInfo.xlsx';
% Dirname = 'E:\research2018\Focus Quality Documents for Zach\database\FocusPath';
% filename = 'E:\research2018\Focus Quality Documents for Zach\database\DatabaseInfo.xlsx';
Dirname = 'D:\Research 2018\database\FocusPath\FocusPath';
filename = 'D:\Research 2018\database\FocusPath\DatabaseInfo.xlsx';
[trim2,txt2,raw2] = xlsread(filename,'Sheet1');

load('X_score_FocusPath5.mat');

%% subjective score
subScore = zeros(864,1);
for i =1:864
    subScore(i) = abs(raw2{i+1,6});
end


%%
for kernel_index = 1:9
    kernel_index
    for moment = 1
        score = X_score_FocusPath5(:,kernel_index,moment);
        if sum(score) == 0 || sum(score) == 103680
            continue;
        end
        [plcc, srcc, krcc, rmse, y_hat] = IQA_measure(score,abs(subScore));
        plccS(kernel_index,moment) = plcc;
        srccS(kernel_index,moment) = srcc;
    end
end
