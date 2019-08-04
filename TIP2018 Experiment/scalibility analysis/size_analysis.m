%%
clear all;
close all;
clc;

load('score_1kernel.mat');
load('score_4kernels.mat');
load('GPC_score.mat');
load('MLV_score.mat');
load('sub_score.mat');

%%
kernelM1 = zeros(20,13);
kernelM4 = zeros(20,13);
GPCM = zeros(20,13);
MLVM = zeros(20,13);
subM = zeros(20,13);
j = 0;
for rate = [.01 .02 .05 .1 .2 .3 .4 .5 .6 .7 .8 .9 1]
    j = j + 1;
    disp(j);
    for iteration = 1:20
        indx = randperm(8640,floor(rate * 8640));
        subS = sub_score(indx);
        
        kernelS1 = score_1kernel(indx);
        [plcc, srcc, krcc, rmse] = IQA_measure(kernelS1, abs(subS));
        kernelM1(iteration,j) = plcc;
        
        kernelS4 = score_4kernels(indx,:);
        alpha = findAlpha(kernelS4, abs(subS));
        [plcc, srcc, krcc, rmse] = IQA_measure(kernelS4 * alpha, abs(subS));
        kernelM4(iteration,j) = plcc;
        
        
        GPCS = GPC_score(indx);
        [plcc, srcc, krcc, rmse] = IQA_measure(GPCS, abs(subS));
        GPCM(iteration,j) = plcc;
        
        MLVS = MLV_score(indx);
        [plcc, srcc, krcc, rmse] = IQA_measure(MLVS, abs(subS));
        MLVM(iteration,j) = plcc;
        
    end
    
    
end

%%
save('kernelM1.mat','kernelM1');
save('kernelM4.mat','kernelM4');
save('GPCM.mat','GPCM');
save('MLVM.mat','MLVM');

%%
kernelCurve1 = sum(kernelM1,1)/20;
kernelCurve4 = sum(kernelM4,1)/20;
GPCCurve = sum(GPCM,1)/20;
MLVCurve = sum(MLVM,1)/20;
x = [.01 .02 .05 .1 .2 .3 .4 .5 .6 .7 .8 .9 1];

plot(x,kernelCurve4,'-x');
hold on;
plot(x,kernelCurve1,'-o');
plot(x,GPCCurve,'-s');
plot(x,MLVCurve,'-d');
legend('4-kernel','1-kernel','GPC','MLV');
box on;







