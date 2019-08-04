function score2 = inverse_gaussian_projection(score1)
a1 = 3; %2.025;
b1 = 0.1914; %0.3592;
c1 = 4.632; %4.528;

% if score1>a1
%     score1 = a1;
% end

score2 = c1 *( (-log(score1/a1))^(1/2) )+ b1;        

end
