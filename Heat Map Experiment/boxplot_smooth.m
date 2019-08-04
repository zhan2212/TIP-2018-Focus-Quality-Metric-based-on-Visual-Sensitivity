%%
clear all;
close all;
clc;

%%
path = 'result';
files = dir(path);

for fileIndx = 3:numel(files)
    fileName = files(fileIndx).name;
    load('result/'+string(fileName));
    
    shiftedProfile = zeros(200,16);
    for position = 1:200
        data = Profile(position,:);
        [minValue,minIndx] = min(smooth(data)); 
        shiftedProfile(position,:) = circshift(data,8-minIndx);
    end
    save('shift result/'+string(fileName),'shiftedProfile');
end
