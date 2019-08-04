%%
clear all;
close all;
clc;

%%
for slide = 1:9
    disp(slide);
    for strip = 1:2
        % original
        fileName = 'Slide0'+string(slide)+'_Strip0'+string(strip-1);
        filePath = ['shift result',filesep,char(fileName+'.mat')];
        load(filePath);
        boxplot(shiftedProfile);
        lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
        set(lines, 'Color', 'r');
        axis tight;
        axis square;
        xlabel('Z-Stack');
        ylabel('Objective Focus Score');
        title('Slide0'+string(slide)+'Strip0'+string(strip-1));
        saveas(gcf,'shift box plot result/'+fileName+'.png');
        % export_fig(['box plot result/'+fileName+'.pdf']...
        %     ,'-q120', '-transparent');
        
        % pathology version
        fileName = 'Slide0'+string(slide)+'_Strip0'+string(strip-1)+'_pathology';
        filePath = ['shift result',filesep,char(fileName+'.mat')];
        load(filePath);
        boxplot(shiftedProfile);
        lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
        set(lines, 'Color', 'r');
        axis tight;
        axis square;
        xlabel('Z-Stack');
        ylabel('Objective Focus Score');
        title('Slide0'+string(slide)+'Strip0'+string(strip-1));
        saveas(gcf,'shift box plot result/'+fileName+'.png');
        % export_fig(['box plot result/'+fileName+'.pdf']...
        %     ,'-q120', '-transparent');
    end
end