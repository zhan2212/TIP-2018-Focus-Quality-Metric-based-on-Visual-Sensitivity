%%
clear all
close all
clc

%%
load('validPic.mat');
load('kernel_sheets.mat');

%%
cutoff_index = [3, 11, 19, 21]; % 13;
beta_index = 7;
alpha_index =11;
params.kernel_sheets = squeeze(kernel_sheets(beta_index, alpha_index, cutoff_index));
params.moment = 6;


%%
for iteration = 1: size(Indx,1)-1
    if iteration == 193
        [score(iteration,1)] = 120;
        continue;
    end
    fprintf(['iteration = ', num2str(iteration), '\n'])

    picPath = char(validPic{3,iteration});
    image_scan = imread(picPath);

    siz = size(image_scan);
    size_image(iteration) = siz(1)*siz(2);
    image_scan = rgb2gray(image_scan);
    image_scan = im2double(image_scan);
     
    if false
        sigma = 0.03;
        randn('seed',0);
        image_scan = image_scan + sigma*randn(size(image_scan));
    end
     
    input_data.data = image_scan;
    input_data.blockSize = size(image_scan);
    %
    tic;
    [score(iteration, 1)] = MaxPol_subband_focus_score_huristic_analysis(input_data, params);
    %score(iteration, 1) = MaxPol_subband_focus_score_4(input_data, params);
    %score(iteration, 1) = MLVSharpnessMeasure(image_scan);
    %score(iteration, 1) = s_index(image_scan);
    %score(iteration, :) = ARISMC(image_scan);
    %score(iteration, :) = SPARISH(image_scan,Dic);
    %score(iteration, :) = s3_map(image_scan);
    %score(iteration, :) = RISE(image_scan, 3);
    elapsed_time(iteration) = toc;
end
IQA_measure(double(score), reshape(cell2mat(validPic(2,:)),[586,1]));
%%
for i=1:size(score,1)
    for j=1:size(score,2)
        for k=1:size(score,3)
            if isinf(score(i,j,k))
                score(i,j,k) = 120;
            end
        end
    end
end
%%

 
for index_m_1 = 1: size(score, 3)
    for index_m_3 = 1: size(score, 3)
        [index_m_1, index_m_3]
        score_vector = score(:, 1, index_m_1) + score(:, 2, index_m_3);
        [acc(index_m_1, index_m_3, 1), ...
            acc(index_m_1, index_m_3, 2), ...
            acc(index_m_1, index_m_3, 3), ...
            acc(index_m_1, index_m_3, 4)] = IQA_measure(score_vector, reshape(cell2mat(validPic(2,:)),[586,1]));
    end
end
 
%
if false
    save('result_BID_score.mat', 'score','elapsed_time','acc')
end
save('result_BID_score.mat', 'score','elapsed_time','acc')
%%
    data = reshape( cell2mat(validPic(2,:)),[586,1] );

    % make plot
    scatter(data,score_vector);
    xlabel('subjective score')
    ylabel('objective score')
    
    
%%

do_export = false;
compression_factor = '-q120';

selected_colormap = 'jet';
font_size = 14;

figure('rend','painters','pos', [50, 100, 400, 300]);
n_1_moments = 2:2:100;
n_2_moments = 2:2:100;
imagesc(n_2_moments, n_1_moments, acc(:,:,1))
axis image
set(gca,'Ydir','normal','FontSize',font_size)
xlabel('3rd-Derivative moments - m_3')
ylabel('1st-Derivative moments - m_1')
colormap(selected_colormap)
colorbar
if do_export
    export_fig([dir_export, filesep, 'SRCC_CID_Central_Moment_Analysis.pdf'], ...
        compression_factor, '-transparent')
end




    