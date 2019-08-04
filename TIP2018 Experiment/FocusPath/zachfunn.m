function F = zachfunn(beta,x)

alpha = beta(6:numel(beta));
beta = beta(1:5);
Ma = x*alpha;

F = beta(1)*(0.5-1./(1+exp(beta(2)*(Ma-beta(3)))))+beta(4)*Ma+beta(5);

