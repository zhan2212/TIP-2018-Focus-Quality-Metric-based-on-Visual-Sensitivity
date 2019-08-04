clear all
close all
clc

%%
load('CIDSub.mat');
dataNew(404) = [];

%%
load('X_score_june9_CID2013_second_kernel_study.mat');
score(404, :, :) = [];
score_second_kernel = double(score);

load('X_score_june9_CID2013_first_kernel_study.mat');
score(404, :, :) = [];
score_first_kernel = double(score);

%%
for iteration_1 = 1: size(score_second_kernel, 2)
    for iteration_2 = 1: size(score_second_kernel, 3)
        [iteration_1, iteration_2]
        score = [score_first_kernel(:), score_second_kernel(:, iteration_1, iteration_2)];
        alpha = findAlpha(score, -dataNew(:));
        [plcc(iteration_1, iteration_2), ...
            srcc(iteration_1, iteration_2), ...
            krcc(iteration_1, iteration_2), ...
            rmse(iteration_1, iteration_2)] = IQA_measure(score * alpha, -dataNew(:));
    end
end