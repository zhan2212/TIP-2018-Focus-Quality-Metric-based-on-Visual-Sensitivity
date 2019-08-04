function [score] = HVS_focus_scoring_May_24_2018(input_block, params)

input_image = input_block.data;
% load kernel
for iteration_kernel = 1: numel(params.kernel_sheets)
    % do convolution
    i_BP_v  = imfilter(input_image, params.kernel_sheets{iteration_kernel}(:), 'symmetric', 'conv');
    i_BP_h  = imfilter(input_image, params.kernel_sheets{iteration_kernel}(:)', 'symmetric', 'conv');
    %
    index_v_p = i_BP_v>0;
    index_h_p = i_BP_h>0;
    %
    index_pp = and(index_h_p, index_v_p);
    index_pn = and(index_h_p, ~index_v_p);
    index_np = and(~index_h_p, index_v_p);
    index_nn = and(~index_h_p, ~index_v_p);
    %
    [c_np] = score_coefficient(i_BP_v, i_BP_h, index_np);
    [c_pn] = score_coefficient(i_BP_v, i_BP_h, index_pn);
    
    %
    moment_np = moment(c_np, params.moment);
    moment_np = abs(moment_np);
    moment_np = -log10(moment_np);
    %
    moment_pn = moment(c_pn, params.moment);
    moment_pn = abs(moment_pn);
    moment_pn = -log10(moment_pn);
    %
    score = (moment_np + moment_pn)/2;
end
