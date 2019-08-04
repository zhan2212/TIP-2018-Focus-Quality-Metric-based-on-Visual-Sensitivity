clear all
close all
clc

%% MaxPol-1
load('kernel_sheets.mat');

cutoff_index = 25; %26; 
beta_index = 1; %1; 
alpha_index =  13; %16; 
params.kernel_sheets = squeeze(kernel_sheets(beta_index, alpha_index, cutoff_index));
params.moment = 2; %2 


%%  paramter initialization
blockSize = [1024, 1024];

%%
pyramid_path = 'F:\Pyramids\023';
patch_export = 'E:\research2018\pyramid\processed\';
if ~exist(patch_export,'dir')
    mkdir(patch_export)
end
pyramid_list = dir(pyramid_path); pyramid_list = pyramid_list(3: end);
image_info = imfinfo([pyramid_path, filesep, pyramid_list(1). name]);


%%
grid_step = 1024;
pyramid_size = [image_info(1).Height, image_info(1).Width];
[J, I] = meshgrid([floor((blockSize(2)-1)/2)+1: grid_step: image_info(1).Width - ceil((blockSize(2)-1)/2)], ...
    [floor((blockSize(1)-1)/2)+1: grid_step: image_info(1).Height - ceil((blockSize(1)-1)/2)]);

%%
patch_size = blockSize;
for iteration_pos = 1: numel(J(:))
    fprintf([num2str(iteration_pos), ' out of ', num2str(numel(J(:))), '\n'])
    pos = [I(iteration_pos), J(iteration_pos)];
    %
    i_start = pos(1) - floor((blockSize(2)-1)/2);
    i_end = pos(1) + ceil((blockSize(1)-1)/2);
    j_start = pos(2) - floor((blockSize(1)-1)/2);
    j_end = pos(2) + ceil((blockSize(2)-1)/2);
    
    %%
    preview_layer = 1;
    pyramid_call = [pyramid_path, filesep, pyramid_list(1). name];
    image_patch = imread(pyramid_call, 'PixelRegion', ...
        {[i_start, i_end], [j_start, j_end]}, 'Index', preview_layer);
    
    %%
    [do_process] = background_detector(image_patch);
    
    %%
    [i_index, j_index] = ind2sub(size(J), iteration_pos);
    if do_process
        input_image = im2single(rgb2gray(image_patch));
        score = HVS_MaxPol_1_pathology(input_image, params); % HVS score
        [x_Indx,y_Indx] = ind2sub(size(J),iteration_pos);
        HVS_scores(iteration_pos,:) = [x_Indx,y_Indx,iteration_pos, score]; 
        % save image patches
        %image_patch = imresize(image_patch, [299, 299]);
        %imwrite(image_patch, [patch_export, filesep, 'index_', num2str(iteration_pos), '.tif'], 'TIFF', 'compression', 'none')
    end
end
save('pyramid result\023\HVS_scores.mat','HVS_scores');
save('pyramid result\023\size.mat','I')