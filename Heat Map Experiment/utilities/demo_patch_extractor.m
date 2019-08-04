clear all
close all
clc

%%
addpath([pwd, filesep, 'utilities'])

%%  paramter initialization
blockSize = [1088, 1088];

%%
pyramid_path = 'H:\Pyramids\001';
patch_export = 'E:\database\pyramid_WSI\pyramid 001\patches_299x299';
if ~exist(patch_export,'dir')
    mkdir(patch_export)
end
pyramid_list = dir(pyramid_path); pyramid_list = pyramid_list(3: end);
image_info = imfinfo([pyramid_path, filesep, pyramid_list(1). name]);

%%
grid_step = 1088;
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
        image_patch = imresize(image_patch, [299, 299]);
        imwrite(image_patch, [patch_export, filesep, 'index_', num2str(iteration_pos), '.tif'], 'TIFF', 'compression', 'none')
    end
end

