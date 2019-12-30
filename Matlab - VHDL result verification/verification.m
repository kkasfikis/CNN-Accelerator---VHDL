IMAGE = imread('C:\Users\User\Desktop\111.png');
RIMAGE = imread('C:\Users\User\Desktop\rrr.jpg'); 
MPRIMAGE = imread('C:\Users\User\Desktop\mmm.jpg');
APRIMAGE = imread('C:\Users\User\Desktop\aaa.jpg');


subplot(4,3,4);
imshow(IMAGE);
title('Original Image');

subplot(4,3,2);
imshow(RIMAGE);
title('Sytem Result');

subplot(4,3,5);
imshow(MPRIMAGE);
title({'System Max','Pooling Result'});

subplot(4,3,8);
imshow(APRIMAGE);
title({'System Avg','Pooling Result'});


RIMAGE = int32(RIMAGE);
MPRIMAGE = int32(MPRIMAGE);
APRIMAGE = int32(APRIMAGE);
IMAGE = int32(IMAGE);

stride = 1;

FILTER = zeros(3,3,3);
FILTER = int32(FILTER);
FILTER(:,:,1) = [1 0 -1; 0 0 0; -1 0 1];
FILTER(:,:,2) = [1 0 -1; 0 0 0; -1 0 1];
FILTER(:,:,3) = [1 0 -1; 0 0 0; -1 0 1];

[imageHeight,imageWidth,imageChannels] = size(IMAGE);
filterDim = size(FILTER,1);

RESULT = zeros(((imageHeight-filterDim)/stride) + 1 , ((imageWidth - filterDim)/stride) + 1);
[resultHeight,resultWidth] = size(RESULT);

result_y = 0;
start_y = 0;
for iy = 1 : 1 : resultHeight
    start_y = start_y + stride;
    result_y = result_y + 1;
    start_x =0; 
    result_x = 0;
    for ix = 1 : 1 : resultWidth
        start_x = start_x + stride;
        result_x = result_x + 1;
        imageRegion = IMAGE(start_y : (start_y + filterDim - 1) , start_x : start_x + filterDim - 1 , 1 : imageChannels);
        prod = (imageRegion.*FILTER);
        RESULT(result_y,result_x) =  sum(prod(:));
    end
end

RESULT(RESULT<0) = 0;
RESULT(RESULT>255) = 255;

subplot(4,3,3);
imshow(RESULT,[0 255])
title('Matlab Result');

count = 0;
for y=1:resultHeight
    for x=1:resultWidth
        if(RESULT(y,x) == RIMAGE(y,x))
          count = count +1;  
        end
    end
end

result_percentage = 100 * (count/(resultWidth*resultHeight));

poolSize = 2;
result_y = 0;

MaxRESULT = zeros( (((resultHeight-poolSize)/poolSize) + 1) , (((resultWidth-poolSize)/poolSize) + 1) );
AvgRESULT = zeros( (((resultHeight-poolSize)/poolSize) + 1) , (((resultWidth-poolSize)/poolSize) + 1) );
[poolHeight,poolWidth] = size(MaxRESULT);

for py = 1 : poolSize : (resultHeight-poolSize+1)
    result_y = result_y + 1;
    result_x = 0;
    for px = 1 : poolSize : (resultWidth-poolSize+1)
        result_x = result_x + 1;
        resultRegion = RESULT(py : (py + poolSize -1), px : (px + poolSize - 1));
        MaxRESULT(result_y,result_x) = max(resultRegion(:));
        AvgRESULT(result_y,result_x) = int32(fix(sum(resultRegion(:))/(poolSize * poolSize)));
    end
end

subplot(4,3,6);
imshow(MaxRESULT,[0 255]);
title({'Matlab Max','Pooling Result'});

count = 0;
for y=1:poolHeight
    for x=1:poolWidth
        if(MaxRESULT(y,x) == MPRIMAGE(y,x))
          count = count +1;  
        end
   end
end
max_percentage = 100 * (count/(poolWidth*poolHeight));


subplot(4,3,9)
imshow(AvgRESULT, [0 255]);
title({'Matlab Avg','Pooling Result'});

count = 0;
for y=1:poolHeight
    for x=1:poolWidth
        if(AvgRESULT(y,x) == APRIMAGE(y,x))
         count = count +1;
        end
    end
end


avg_percentage = 100 * (count/(poolWidth*poolHeight));


subplot(4,3,10:12)
c = categorical({'result','max','average'});
title({'Comparison between','System and Matlab results'});
per = [result_percentage max_percentage avg_percentage]
b = bar(c,per);
b.FaceColor = 'y';
b.LineWidth = 1.5;
b.BarWidth = 0.4;
ylim([0 110])