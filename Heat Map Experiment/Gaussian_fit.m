%%
clear all;
close all;
clc;

%% load  centralized result
path = 'shift result';
files = dir(path);
profiles = [];
indx = 0;

for fileIndx = 3+16:numel(files)-1
    fileName = files(fileIndx).name;
    load('shift result/'+string(fileName));
    profiles = [profiles; shiftedProfile];
end

%% find best fit gaussian

y = mean(profiles);
x = [-7:8];
maximum = max(profiles(:));
z = maximum - y; %max(y)-y;
f = fit(x.',z.','gauss1');
plot(f);
hold on;
plot(x,z.','*');
legend('fitted curve','mean profile');

%%
a1 = 2.025;
b1 = 0.3592;
c1 = 4.528;

for i = 1:16
    x_hat(i) = c1 *( (-log(z(i)/a1))^(1/2) )+ b1;
%     if i<=8
%         x_hat(i) = -c1 *( (-log(z(i)/a1))^(1/2) )+ b1;
%     else
%         x_hat(i) = c1 *( (-log(z(i)/a1))^(1/2) )+ b1;
%     end
end

plot([-7:8],real(x_hat),'*')
hold on;
fplot(@(x) abs(x));
 


