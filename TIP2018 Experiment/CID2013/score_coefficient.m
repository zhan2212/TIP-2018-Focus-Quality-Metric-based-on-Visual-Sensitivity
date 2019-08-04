function [c_pp] = score_coefficient(i_BP_v, i_BP_h, index_pp)

c_pp = [i_BP_v(index_pp), i_BP_h(index_pp)];
p_norm = 1/2;
c_pp = (abs(c_pp(:, 1)).^p_norm + abs(c_pp(:, 2)).^p_norm).^(1/p_norm);
[threshold_pp] = significant_threshold(c_pp(:));
c_pp = c_pp(c_pp >= threshold_pp);