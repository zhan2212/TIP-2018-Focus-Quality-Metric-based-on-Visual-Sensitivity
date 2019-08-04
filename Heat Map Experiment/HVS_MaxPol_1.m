function [score] = HVS_MaxPol_1(input_image, params)

if strcmp(params.type,'natural') == 1
    momt = 6;
    selected_kernel = params.kernel_sheets{1};
elseif strcmp(params.type,'synthetic') == 1
    momt = 10;
    selected_kernel = params.kernel_sheets{2};
else
    disp('Unknown blur type!')
end

iB = input_image > .05; 

if sum(iB(:)) > 0 % background check

    % MaxPol variational decomposition
    i_BP_v = imfilter(input_image, selected_kernel{:}, 'symmetric', 'conv');
    i_BP_h = imfilter(input_image, selected_kernel{:}', 'symmetric', 'conv');

    % Rectified Linear Unit operation
    mask = iB & (i_BP_v>0) & (i_BP_h>0);
    v = [abs(i_BP_v(mask)), abs(i_BP_h(mask))];

    [pdf, x] = hist(v(:), 50);
    cdf = cumsum(pdf)/sum(pdf);
    % find sigma approximate
    threshold = .95;
    min_val = min(cdf);
    max_val = max(cdf);
    rng_val = max_val - min_val;
    indx = cdf < min_val + threshold*rng_val;
    sigma_apprx = x(sum(indx))/max(x);
    c = (1-tanh(60*(sigma_apprx-.095)))/4 + 0.09;

    p_norm = 1/2;
    feature_map = (abs(v(:, 1)).^p_norm + abs(v(:, 2)).^p_norm).^(1/p_norm);

    %%
    number_of_pixels = round(c*numel(feature_map));
    feature_map = sort(feature_map(:), 'descend');
    feature_map = feature_map(1: number_of_pixels);

    %% iterate moments
    val = moment(feature_map, momt);
    val = abs(val);
    val = -log10(val);
    if val == (-inf)
        val = 0;
    elseif val == inf
        val = 120;
    end
    score = val;
    
else
    score = 120;
end