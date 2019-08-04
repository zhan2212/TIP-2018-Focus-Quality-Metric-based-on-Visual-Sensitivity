
function [delta,beta,yhat,mos,diff] = findrmse5(iqa,mos,str,str2,str3,num,beg,strx,xxx,yyy,zzz)
ord = find(isnan(iqa)==1);
iqa(ord) = [];
mos(ord) = [];

x = iqa;
y = mos;

% temp = corrcoef(x,y);
% if (temp(1,2)>0)
% beta0(3) = mean(x);
% beta0(1) = -abs(max(y) - min(y));
% beta0(4) = mean(y);
% beta0(2) = 1/std(x);
% beta0(5) = 1;%0;%1;
% else
beta0(3) = mean(x);
beta0(1) = -abs(max(y) - min(y));
beta0(4) = mean(y);
beta0(2) = 1/std(x);
beta0(5) = 1;%0;%1;
%end

maxiter = 1000000;
[beta ehat J] = nlinfit(x,y,@myfunn3,beta0,maxiter);
[yhat delta] = nlpredci(@myfunn3,real(x),real(beta),real(ehat),real(J));
diff = abs(y - yhat);
[xx ord] = sort(x);

%%
switch num
    case 1
        srt4 = 'bd';
        str5 = str2;
    case 2
        srt4 = 'bs';
        str5 = [str2(1:4) '  '];
    case 3
        srt4 = 'b<';
        str5 = [str2(1:4) '  '];
    case 4
        srt4 = 'b>';
        str5 = str2;
        str2 = [str2(end-3:end) str2(1)];
end

% g = figure;hold on;
% h = plot(yhat,mos,zzz,'Color',[0.1 0.2 0.9],'Markersize',18,'LineWidth',1.5);
% box on;

% xx = xxx(1):0.01:xxx(end);%������ߵ�����?
% h = plot(xx,xx,'-.','color',[0 0 0]/255,'markersize',6);set(h,'LineWidth',1.5);
% 
% set(gca,'fontsize',16,'LineWidth',1.5);%������ʾ��ʽ�Լ�����ʶ�Ĵ�С
% % % LIVE
% xlim([xxx(1) xxx(end)]);
% ylim([yyy(1) yyy(end)]);
% set(gca,'XTick',xxx);
% set(gca,'YTick',yyy);
% set(gca,'ygrid','on');
%set(gca,'LineWidth',0.5);%

% % TID
% xlim([1 7]);
% ylim([1 7])
% set(gca,'XTick',1:7);
% set(gca,'YTick',1:7);
% set(gca,'ygrid','on');
% set(gca,'LineWidth',2);

% % CSIQ
% xlim([0 1.2]);
% ylim([0 1.2])
% set(gca,'XTick',0:0.2:1.2);
% set(gca,'YTick',0:0.2:1.2);
% set(gca,'ygrid','on');
% set(gca,'LineWidth',2);

% % TIDx
% xlim([1 7]);
% ylim([1 7])
% set(gca,'XTick',1:7);
% set(gca,'YTick',1:7);
% set(gca,'ygrid','on');
% set(gca,'LineWidth',2);

% grid on;
% grid minor;
% shading interp;
% set(gca,'xtick',-inf:inf:inf);
% set(gca,'ytick',-inf:inf:inf);
% saveas(g,[str str2],'jpg');
% close all
