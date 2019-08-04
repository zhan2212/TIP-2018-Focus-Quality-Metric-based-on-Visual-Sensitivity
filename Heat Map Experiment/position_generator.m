%%
clear all;
close all;
clc;

%%
seed = 0;
Dirname = 'F:\Pathology Database\Customer_slides';
Positions = cell(9,2,200);

for i = 1:9 % Slide
    slideNum = char('slide'+string(i));
    Dirname2 = [Dirname, filesep, slideNum]; 
    files = dir(Dirname2);
    
    for j = 3:4 % 2 strips
        filename = files(j).name;
        I = imread([Dirname2,filesep,filename]);
        
        for k=1:200 % 200 different postions
            xDim = size(I,1)-1024;
            yDim = size(I,2)-1024;
            
            rng(seed);
            x1= int32(rand(1) * xDim)+1;
            x2 = x1 + 1023;
            y1 = int32(rand(1) * yDim)+1;
            y2 = y1 + 1023;
            
            seed2 = seed+540;
            while BackGroundCheck(I(x1:x2,y1:y2,:), 0.5) == false
                rng(seed2);
                x1= int32(rand(1) * xDim)+1;
                x2 = x1 + 1023;
                y1 = int32(rand(1) * yDim)+1;
                y2 = y1 + 1023;
                seed2 = seed2 + 540;
            end   
            
            disp(seed)
            Positions{i,j-2,k} = [x1,x2,y1,y2];
            seed = seed + 1;
        end
        
    end
        
     
end
save('Positions.mat','Positions');