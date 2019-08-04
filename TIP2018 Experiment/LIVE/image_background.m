function [iB] = image_background(input_image)


% [pdf, x] = hist(input_image(:), 50);
% [max_val, max_indx] = max(pdf);
% 
% if max_indx < 3
%     cdf = cumsum(pdf) / sum(pdf);
%     
%     
%     
%     threshold_value = 10*median(pdf);
%     possible_index = pdf > threshold_value;
%     excluding_index = find(abs(diff(possible_index)));
%     if isempty(excluding_index)
%         iB = input_image>=0;
%     else
%         excluding_index = excluding_index(1);
%         threshold_gray = x(excluding_index);
%         iB = input_image>threshold_gray;
%     end
% else
%     iB = input_image>=0;
%     threshold_value = 1;
% end
iB = input_image > .05;
if false
    figure(1)
%     subplot(1,3,1)
%     plot(x, pdf)
%     hold on
%     plot([min(x), max(x)], [threshold_value, threshold_value])
    subplot(1,3,2)
    img(input_image)
    
    subplot(1,3,3)
    img(iB)
    pause
end