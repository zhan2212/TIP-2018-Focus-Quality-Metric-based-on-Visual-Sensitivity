function [check,background_ratio] = BackGroundCheck(input_image, bacground_threshold)

check = true;
threshold = [235, 235, 235];
r_mask = input_image(:,:,1) > threshold(1);
g_mask = input_image(:,:,2) > threshold(2);
b_mask = input_image(:,:,3) > threshold(3);
rgb_mask = r_mask & g_mask & b_mask;
background_ratio = sum(rgb_mask(:));
background_ratio = background_ratio/ (size(input_image,1)*size(input_image,2));

if background_ratio > bacground_threshold
    check = false;
else

end