clear all;
close all;
clc;

%% plot inverse gaussian result

a1 = 3; %2.025;
b1 = 0.1914; %0.3592;
c1 = 4.632; %4.528;

path = 'shift result';
files = dir(path);

for fileIndx = 3+16:numel(files)-1
    fileName = files(fileIndx).name;
    load('shift result/'+string(fileName));
    figure();
    maximum = 5.5805;
    for indx = 1:200
        y = shiftedProfile(indx,:);
        z = maximum -y; %max(y)-y;
        
        for i = 1:16
%             if z(i)>a1
%                 z(i) = a1;
%             end
            if i<=8
                x_hat(i) = -c1 *( (-log(z(i)/a1))^(1/2) )+ b1;
            else
                x_hat(i) = c1 *( (-log(z(i)/a1))^(1/2) )+ b1;
            end
        end
        
        plot([-7:8],abs(x_hat), 'Color', [.9 .3 0]);
        hold on;
        if sum(abs(imag(x_hat))>0) > 0
            debug
        end
        
    end
    axis([-8 8 0 10]);
    fplot(@(x) abs(x),'Linewidth',1.5,'Color','k');
    ylabel('Inverse Gaussian Projection (x)');
    xlabel('Z-Stack')
    saveas(gcf,'inverse gaussian result/'+string(fileName)+'.png');
    close figure 1;
end

disp(x_hat)