clear all
close all
clc

load score_subjective;
load score_objective;

[plcc, srcc, krcc, rmse] = IQA_measure(score_objective, score_subjective)
