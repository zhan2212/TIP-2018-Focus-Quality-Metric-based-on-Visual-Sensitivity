function [score] = HVS_focus_scoring_June_9(input_block, params)

input_image = input_block.data;
[iB] = image_background(input_image);

if sum(iB(:)) > 0 % background check
    % load kernel
    for iteration_kernel = 1: numel(params.kernel_sheets)
        % do convolution
        i_BP_v = imfilter(input_image, params.kernel_sheets{iteration_kernel}(:), 'symmetric', 'conv');
        i_BP_h = imfilter(input_image, params.kernel_sheets{iteration_kernel}(:)', 'symmetric', 'conv');
        mask = iB & (i_BP_v>0) & (i_BP_h>0);
        %mask = iB;
        %
        v = [abs(i_BP_v(mask)), abs(i_BP_h(mask))];
        p_norm = 1/2;
        feature_map = (abs(v(:, 1)).^p_norm + abs(v(:, 2)).^p_norm).^(1/p_norm);
        
        %%
        feature_map = sort(feature_map(:), 'descend');
        feature_map = feature_map(1: number_of_pixels);
        
        %% iterate moments
        %         for iteration_moment = 1: numel(params.moment)
        %             val = moment(feature_map, params.moment(iteration_moment));
        %             val = abs(val);
        %             val = -log10(val);
        %             if val == (-inf)
        %                 val = 0;
        %             elseif val == inf
        %                 val = 120;
        %             end
        %             score(iteration_kernel, iteration_moment) = val;
        %         end
        val = moment(feature_map, params.moment(iteration_kernel));
        val = abs(val);
        val = -log10(val);
        if val == (-inf)
            val = 0;
        elseif val == inf
            val = 120;
        end
        score(iteration_kernel) = val;
    end
else
    score = zeros(1, numel(params.kernel_sheets))*120;
end