%% 标准圆生成兼容入口
clear; clc; close all;
root_dir = fileparts(mfilename('fullpath'));
addpath(fullfile(root_dir, 'src'));
config = circle_config();
gray_image = generate_standard_circle(config);
imwrite(gray_image, fullfile(root_dir, 'standard_circle.bmp'));
imshow(gray_image, []); colormap gray; axis image;
title('标准圆形'); xlabel('u-方向'); ylabel('v-方向');
