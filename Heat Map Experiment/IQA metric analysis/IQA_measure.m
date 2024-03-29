function [plcc, srcc, krcc, rmse, y_hat] = IQA_measure(score_objective, score_subjective)

%   y = score_subjective
[delta,beta,y_hat,x,diff]=findrmse5(score_objective, score_subjective,'','Proposed Method', ...
    'DMOS',1,[50  80  70]/255,'',1.5:0.5:5,1.5:0.5:5,'.');
CID_cc(01,:)=[...
    corr(x,y_hat),...
    corr(x,y_hat,'type','spearman'),...
    corr(x,y_hat,'type','kendall'),...
    (mean(diff.^2))^0.5];
plcc=CID_cc(1);
srcc=CID_cc(2);
krcc=CID_cc(3);
rmse=CID_cc(4);