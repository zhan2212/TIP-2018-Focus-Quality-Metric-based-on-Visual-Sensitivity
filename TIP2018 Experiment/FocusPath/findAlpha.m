
function [alpha] = findAlpha(iqa,mos)
x = iqa;
y = mos;

beta0 = ones(5,1); % initial value
alpha = ones(size(x,2), 1);
beta_bar = [beta0;alpha]; % alpha(1*4)

maxiter = 100000;

% opts = statset('nlinfit');
% opts.RobustWgtFun = 'logistic';
% opts.Robust = 'ON';
% opts.MaxIter = 10000;


[beta ehat J] = nlinfit(x,y,@zachfunn,beta_bar,maxiter);
alpha = real(beta(6:numel(beta)));
