function [resized_image] = maxpol_image_resize(scan_image, scale, h_upsampling, h_downsampling)


if scale < 1
    [resized_image] = maxpol_downsample(scan_image, scale, h_downsampling(:));
elseif scale > 1
    [resized_image] = maxpol_upsample(scan_image, scale, h_upsampling(:), h_downsampling(:));
else
    resized_image = scan_image;
end