function [up_sampled_image] = maxpol_upsample(scan_image, scale, h_upsampling, h_downsampling)

%%
if scale < 1
    warning('down-sampling scale should be higher than one, returning the same input image')
    return
end

N_upsample = ceil(log2(scale));
up_sampled_image = scan_image;
for iteration = 1: N_upsample
    [m,n,q] = size(up_sampled_image);
    %
    frame = gpuArray(zeros(2*m, 2*n, q));
    W = gpuArray(zeros(2*m, 2*n, q));
    frame = double(zeros(2*m, 2*n, q));
    W = double(zeros(2*m, 2*n, q));
    frame(1: 2: 2*m, 1: 2: 2*n, :) = up_sampled_image;
    W(1: 2: 2*m, 1: 2: 2*n, :) = 1;
    %
    frame = imfilter(frame, h_upsampling(:), 'conv', 'symmetric');
    frame = imfilter(frame, h_upsampling(:)', 'conv', 'symmetric');
    %
    W = imfilter(W, h_upsampling(:), 'conv', 'symmetric');
    W = imfilter(W, h_upsampling(:)', 'conv', 'symmetric');
    %
    up_sampled_image = frame./W;
    %
    up_sampled_image(up_sampled_image>255) = 255;
    up_sampled_image(up_sampled_image<0) = 0;
end

%%
if scale/2^N_upsample < 1
    [up_sampled_image] = maxpol_downsample(up_sampled_image, scale/2^N_upsample, h_downsampling(:));
elseif 2^N_upsample/scale == 1
else
    warning('Oops!!!')
end