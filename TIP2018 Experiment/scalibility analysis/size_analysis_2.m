%%
clear all;
close all;
clc;

% load('HVS_MaxPol_1_score30.mat');
% load('HVS_MaxPol_2_score30.mat');
% load('GPC_score30.mat');
load('MLV_score30.mat');
% load('SPARISH_score30.mat');
% load('RISE_score30.mat')
% load('ARISM_score30.mat');
% load('MaxPol_score30');
% load('S3_score30');

load('sub_score30.mat');

%%
% for i=1:2592
%     if MaxPol_score30(i) == Inf
%         MaxPol_score30(i) =120;
%     end
% end

%%
% kernelM1 = zeros(50,10);
% kernelM2= zeros(50,10);
% RISEM = zeros(50,10);
% SPARISHM = zeros(50,10);
% GPCM = zeros(50,10);
MLVM = zeros(50,10);
% subM = zeros(50,10);
% ARISMM = zeros(50,10);
% MaxPolM = zeros(50,10);
% S3M = zeros(50,10);
j = 0;
for rate = [.1 .2 .3 .4 .5 .6 .7 .8 .9 1]
    j = j + 1;
    disp(j);
    for iteration = 1:50
        indx = randperm(2592,floor(rate * 2592));
        subS = sub_score30(indx);
        %         ARISMS = ARISM_score30(indx);
%         [plcc, srcc, krcc, rmse] = IQA_measure(ARISMS, abs(subS));
%         ARISMM(iteration,j) = plcc;

        
%         kernelS1 = HVS_MaxPol_1_score30(indx);
%         [plcc, srcc, krcc, rmse] = IQA_measure(double(kernelS1), abs(subS));
%         kernelM1(iteration,j) = plcc;
%         
%         kernelS2 = HVS_MaxPol_2_score30(indx,:);
%         weights = [0.3341; -0.1195];
%         [plcc, srcc, krcc, rmse] = IQA_measure(double(kernelS2) * weights, abs(subS));
%         kernelM2(iteration,j) = plcc;
        
        
        %GPCS = GPC_score30(indx);
        %[plcc, srcc, krcc, rmse] = IQA_measure(GPCS, abs(subS));
        %GPCM(iteration,j) = plcc;
        
        MLVS = MLV_score30(indx);
        [plcc, srcc, krcc, rmse] = IQA_measure(MLVS, abs(subS));
        MLVM(iteration,j) = plcc;
        
        %SPARISHS = SPARISH_score30(indx);
        %[plcc, srcc, krcc, rmse] = IQA_measure(SPARISHS, abs(subS));
        %SPARISHM(iteration,j) = plcc;
        
        %RISES = RISE_score30(indx);
        %[plcc, srcc, krcc, rmse] = IQA_measure(RISES, abs(subS));
        %RISEM(iteration,j) = plcc;      
        
%         MaxPolS = double(MaxPol_score30(indx));
%         [plcc, srcc, krcc, rmse] = IQA_measure(MaxPolS, abs(subS));
%         MaxPolM(iteration,j) = plcc; 
%         
%         S3S = MaxPol_score30(indx);
%         [plcc, srcc, krcc, rmse] = IQA_measure(S3S, abs(subS));
%         S3M(iteration,j) = plcc; 
    end
    
    
end

%%
% save('kernelM1.mat','kernelM1');
% save('kernelM2.mat','kernelM2');
% save('GPCM.mat','GPCM');
save('MLVM.mat','MLVM');
% save('SPARISHM.mat','SPARISHM');
% save('RISEM.mat','RISEM');
% save('ARISMM.mat','ARISMM');
% save('MaxPolM,mat','MaxPolM');
% save('S3M.mat','S3M');

%%
% load('kernelM1.mat');
% load('kernelM2.mat');
% load('GPCM.mat');
load('MLVM.mat');
% load('SPARISHM.mat');
% load('RISEM.mat');
% load('ARISMM.mat');
% load('MaxPolM,mat');
% load('S3M.mat');

%% MaxPol
x = [259 518 778 1037 1296 1555 1814 2074 2333 2592];
figure();
boxplot(MaxPolM,x, 'Colors','k');
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'r');
axis([0 10 0.2 0.9]);
axis square;

xtickangle(45);
xlabel('# of images from FocusPath')
ylabel('plcc')
set(gca,'Xscale','linear','YScale', 'linear', 'FontSize', 12);

export_fig([pwd, filesep, 'result/MaxPol_scalability.pdf'],'-q120', '-transparent');

%% S3
x = [259 518 778 1037 1296 1555 1814 2074 2333 2592];
figure();
boxplot(S3M,x, 'Colors','k');
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'r');
axis([0 10 0.2 0.9]);
axis square;

xtickangle(45);
xlabel('# of images from FocusPath')
ylabel('plcc')
set(gca,'Xscale','linear','YScale', 'linear', 'FontSize', 12);

export_fig([pwd, filesep, 'result/S3_scalability.pdf'],'-q120', '-transparent');

%% 1-kernel
x = [259 518 778 1037 1296 1555 1814 2074 2333 2592];
figure();
boxplot(kernelM1,x, 'Colors','k');
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'r');
axis([0 10 0.2 0.9]);
axis square;

xtickangle(45);
xlabel('# of images from FocusPath')
ylabel('plcc')
%title('HVS MaxPol-1 Scalability')
set(gca,'Xscale','linear','YScale', 'linear', 'FontSize', 12);

export_fig([pwd, filesep, 'result/HVS_MaxPol_1_scalability.pdf'],'-q120', '-transparent');
%% 2-kernel
x = [259 518 778 1037 1296 1555 1814 2074 2333 2592];
figure();
boxplot(kernelM2,x, 'Colors','k');
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'r');
axis([0 10 0.2 0.9]);
axis square;

xtickangle(45);
xlabel('# of images from FocusPath')
ylabel('plcc')
%title('HVS MaxPol-2 Scalability')
set(gca,'Xscale','linear','YScale', 'linear', 'FontSize', 12);

export_fig([pwd, filesep, 'result/HVS_MaxPol_2_scalability.pdf'],'-q120', '-transparent');

%% GPC
x = [259 518 778 1037 1296 1555 1814 2074 2333 2592];
figure();
boxplot(GPCM,x, 'Colors','k');
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'r');
axis([0 10 0.2 0.9]);
axis square;

xtickangle(45);
xlabel('# of images from FocusPath')
ylabel('plcc')
set(gca,'Xscale','linear','YScale', 'linear', 'FontSize', 12);

export_fig([pwd, filesep, 'result/GPC_scalability.pdf'],'-q120', '-transparent');


%% MLV
x = [259 518 778 1037 1296 1555 1814 2074 2333 2592];
figure();
boxplot(MLVM,x, 'Colors','k');
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'r');
axis([0 10 0.2 0.9]);
axis square;

xtickangle(45);
xlabel('# of images from FocusPath')
ylabel('plcc')
set(gca,'Xscale','linear','YScale', 'linear', 'FontSize', 12);

export_fig([pwd, filesep, 'result/MLV_scalability.pdf'],'-q120', '-transparent');


%% RISE
x = [259 518 778 1037 1296 1555 1814 2074 2333 2592];
figure();
boxplot(RISEM,x, 'Colors','k');
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'r');
axis([0 10 0.2 0.9]);
axis square;

xtickangle(45);
xlabel('# of images from FocusPath')
ylabel('plcc')
set(gca,'Xscale','linear','YScale', 'linear', 'FontSize', 12);

export_fig([pwd, filesep, 'result/RISE_scalability.pdf'],'-q120', '-transparent');

%% ARISM
x = [259 518 778 1037 1296 1555 1814 2074 2333 2592];
figure();
boxplot(ARISMM,x, 'Colors','k');
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'r');
axis([0 10 0.2 0.9]);
axis square;

xtickangle(45);
xlabel('# of images from FocusPath')
ylabel('plcc')
set(gca,'Xscale','linear','YScale', 'linear', 'FontSize', 12);

export_fig([pwd, filesep, 'result/ARISM_scalability.pdf'],'-q120', '-transparent');

%% SPARISH
x = [259 518 778 1037 1296 1555 1814 2074 2333 2592];
figure();
boxplot(SPARISHM,x, 'Colors','k');
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'r');
axis([0 10 0.2 0.9]);
axis square;

xtickangle(45);
xlabel('# of images from FocusPath')
ylabel('plcc')
set(gca,'Xscale','linear','YScale', 'linear', 'FontSize', 12);

export_fig([pwd, filesep, 'result/SPARISH_scalability.pdf'],'-q120', '-transparent');







