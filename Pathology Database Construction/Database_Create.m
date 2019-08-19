% this script is to create the database

current_path = pwd;
Dirname = [current_path, filesep, 'Customer_slides'];
load('Positions.mat');

for i = 1:9
    slideNum = char('slide'+string(i));
    Dirname2 = [Dirname, filesep, slideNum]; 
    files = dir(Dirname2);
    
    for j = 3:size(files,1)
        filename = files(j).name;
        I = imread([Dirname2,filesep,filename]);
        
        splitName = strsplit(filename,'_');
        
        slideIndx = 'Slide' + string(splitName{3}(2:3)); % out of 9
        stripIndx = 'Strip' + string(splitName{7}(1:2)); % out of 2
        if strcmp(stripIndx,'Strip02')
            continue
        end
        sliceIndx = string(splitName{5}); % out of 16
        
        for k = 1:30
            stripNum = str2double(splitName{7}(1:2)) + 1;
            position = Positions{i,stripNum,k};
            x1 = position(1);
            x2 = position(2);
            y1 = position(3);
            y2 = position(4);
            croppedImg = I(x1:x2,y1:y2,:); % dimension of 1024*1024
            
            positionIndx = 'Position' + string(k); % out of 30
            if size(char(positionIndx),2) == 9
                positionIndx = char(positionIndx);
                NewIndx = positionIndx(1:8) + '0' + positionIndx(9);
                positionIndx = NewIndx;
            end
            croppedName = string(slideIndx) + '_' + string(stripIndx) ...
                + '_' + string(sliceIndx) + '_' + string(positionIndx) + '.tif';
            croppedPath = ['CroppedDatabase',filesep,char(croppedName)];
            
            disp(size(croppedImg))
            imwrite(croppedImg,croppedPath)
            
        end
    end
          
end