
% Copyright: © 2019 Qiao-Le He 
% See the license note at the end of the file.

obj = jsonDecode(fileread('config.json'));
% % Switch debug mode
% obj.enableDebug = true;
% 
% % Assign name of the file to be processed
% obj.fname = 'IMG_8209.JPG';
% 
% % Manually set the crop dimension
% obj.crop_x_min = 940;
% obj.crop_x_max = 1200;
% obj.crop_y_min = 1200;
% obj.crop_y_max = 1450;
% 
% % Focus on the RGB intervals of the studied object
% obj.rgb_min = 20;
% obj.rgb_max = 100;



imageLoad = imread(obj.fname);
if obj.enableDebug
    figure; imshow(imageLoad);
    title('The original image');
end

imageCrop = imageLoad(obj.crop_x_min:obj.crop_x_max, obj.crop_y_min:obj.crop_y_max);

imageCrop(imageCrop < obj.rgb_min) = 0;
imageCrop(imageCrop > obj.rgb_max) = 0;

if obj.enableDebug
    figure; imshow(imageCrop);
    title('The cropped image');
else
    h = figure('visible', 'off');
    imshow(imageCrop);
    title('The cropped image');
    saveas(h, '1_crop', 'jpg');
end

[~, threshold] = edge(imageCrop, 'sobel');
fudgeFactor = 0.5;
BinaryWhite = edge(imageCrop, 'sobel', threshold*fudgeFactor);

se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
BinaryWhiteLine = imdilate(BinaryWhite, [se90 se0]);

BinaryWhiteFill = imfill(BinaryWhiteLine, 'holes');
if obj.enableDebug
    figure; imshow(BinaryWhiteFill);
    title('The binary image');
else
    h = figure('visible', 'off');
    imshow(BinaryWhiteFill);
    title('The binary image that lines are dilated and holes are filled');
    saveas(h, '2_binary', 'jpg');
end

seD = strel('diamond', 1);
BinaryWhiteErode = imerode(BinaryWhiteFill, seD);
BinaryWhiteFinal = imerode(BinaryWhiteFill, seD);
if obj.enableDebug
    figure; imshow(BinaryWhiteFinal);
    title('The blurred image');
else
    h = figure('visible', 'off');
    imshow(BinaryWhiteFinal);
    title('The blurred image');
    saveas(h, '3_blurred', 'jpg');
end

BinaryWhiteOutline = bwperim(BinaryWhiteFinal);
Segout = imageCrop;
Segout(BinaryWhiteOutline) = 255;
if obj.enableDebug
    figure; imshow(Segout);
    title('The edge is depicted');
else
    h = figure('visible', 'off');
    imshow(Segout);
    title('The edge is depicted');
    saveas(h, '4_edge', 'jpg');
end

[R, C, ~] = size(imageLoad);
BinaryWhiteRemap = zeros(R, C);
BinaryWhiteRemap(obj.crop_x_min:obj.crop_x_max, obj.crop_y_min:obj.crop_y_max) = BinaryWhiteFinal;
imageLoadOutput =  zeros(R, C, 3);
imageLoadOutput = uint8(imageLoadOutput);

for i = 1:R
    for j = 1:C
        if(BinaryWhiteRemap(i,j) == 1)
            imageLoadOutput(i,j,1:3) = imageLoad(i,j, 1:3);
        end
    end
end

if obj.enableDebug
    figure; imshow(imageLoadOutput);
    title('The final cropped image');
else
    h = figure('visible', 'off');
    imshow(imageLoadOutput);
    title('The final cropped image');
    saveas(h, '5_final', 'jpg');
end

save('imageCrop.mat', 'imageLoadOutput');

% =============================================================================
%  All rights reserved. This program and the accompanying materials
%  are made available under the terms of the GNU Public License v3.0 (or, at
%  your option, any later version) which accompanies this distribution, and
%  is available at http://www.gnu.org/licenses/gpl.html
% =============================================================================
