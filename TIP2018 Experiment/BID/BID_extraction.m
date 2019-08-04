% BID¡ªBlurred Image Database [Online]. Available: http://www.lps.ufrj.br/profs/eduardo/ImageDatabase.htm
%% Download
% for i=190:590
%     name = string(i);
%     z = '0000';
%     l = 4 - length(char(name));
%     name = strcat(z(1:l),name,'.JPG');
%     name = strcat('DatabaseImage',name);
%     disp(name)
%     url = ['http://www02.smt.ufrj.br/~eduardo/ImageDatabase/',char(name)];
%     filename = ['BID',filesep,char(name)];
%     outfilename = websave(filename,url);
% end

%% extract data
load('Classes.mat');
% load excel file
filename = 'E:\research2018\Focus Quality Documents for Zach\database\BID\DatabaseGrades.xlsx';
[trim,txt,raw] = xlsread(filename,'Plan1');
subScore = raw(:,22);
validPic = cell(3,numel(subScore)-1); % store name, MOS, path

for i = 2 : numel(subScore)
    disp(i);
    indx = Classes(i-1);
    value = subScore{i};
    validPic{1,i-1} = indx;
    validPic{2,i-1} = value;
    name = string(indx);
    z = '0000';
    l = 4 - length(char(name));
    name = strcat(z(1:l),name,'.JPG');
    name = strcat('DatabaseImage',name);
    path = ['E:\research2018\Focus Quality Documents for Zach\database\BID',filesep,char(name)];
    validPic{3,i-1} = path;
end
save('validPic.mat','validPic');