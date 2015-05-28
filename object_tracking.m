
image=imread('gaurav.jpg');
figure;
% imshow(image);
title('this is image');




target=imread('gaurav.jpg');
figure;
% imshow(target);
title('this is target image');
boxImage= rgb2gray(target);
sceneImage= rgb2gray(image);
boxPoints = detectSURFFeatures(boxImage);
scenePoints = detectSURFFeatures(sceneImage);

figure;
% imshow(boxImage);
title('100 Strongest Feature Points from Box Image');
hold on;
plot(selectStrongest(boxPoints, 300));


figure;
% imshow(sceneImage);
title('300 Strongest Feature Points from Scene Image');
hold on;
plot(selectStrongest(scenePoints, 100));

[boxFeatures, boxPoints] = extractFeatures(boxImage, boxPoints);
[sceneFeatures, scenePoints] = extractFeatures(sceneImage, scenePoints);


boxPairs = matchFeatures(boxFeatures, sceneFeatures,'MaxRatio',0.9);


[tform, inlierBoxPoints, inlierScenePoints] =estimateGeometricTransform(matchedBoxPoints, matchedScenePoints, 'affine');

figure;
showMatchedFeatures(boxImage, sceneImage, inlierBoxPoints,inlierScenePoints, 'montage');
title('Matched Points (Inliers Only)');

boxPolygon = [1, 1;...                           % top-left
        size(boxImage, 2), 1;...                 % top-right
        size(boxImage, 2), size(boxImage, 1);... % bottom-right
        1, size(boxImage, 1);...                 % bottom-left
        1, 1];                   % top-left again to close the polygon
    
    newBoxPolygon = transformPointsForward(tform, boxPolygon);
    figure;
imshow(sceneImage);
hold on;
line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'y');
title('Detected Box');