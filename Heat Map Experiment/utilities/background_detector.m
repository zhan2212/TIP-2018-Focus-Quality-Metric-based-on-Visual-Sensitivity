function [do_process] = background_detector(image_patch)

blockSize = size(image_patch);
blockSize = blockSize(1:2);

%%
threshold = [180, 180, 180];
r_mask = image_patch(:,:,1) > threshold(1);
g_mask = image_patch(:,:,2) > threshold(2);
b_mask = image_patch(:,:,3) > threshold(3);
rgb_mask = r_mask & g_mask & b_mask;
background_ratio = sum(rgb_mask(:))/prod(blockSize);

%%
image_patch = single(image_patch);
diff_channel = 0;
diff_channel = diff_channel + abs(image_patch(:,:,1) - image_patch(:,:,2));
diff_channel = diff_channel + abs(image_patch(:,:,1) - image_patch(:,:,3));
diff_channel = diff_channel + abs(image_patch(:,:,2) - image_patch(:,:,3));
diff_channel = diff_channel/3;
diff_channel = mean(diff_channel(:));

%%
min_channel_difference = 15;
background_threshold = .3;
if diff_channel > min_channel_difference
    do_process = true;
else
    if background_ratio > background_threshold
        do_process = false;
    else
        do_process = true;
    end
end
