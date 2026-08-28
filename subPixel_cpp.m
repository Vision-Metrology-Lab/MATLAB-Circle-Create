%% Canny 与 Zernike 亚像素边缘对比兼容入口
clear; clc; close all;
root_dir = fileparts(mfilename('fullpath'));
addpath(fullfile(root_dir, 'src'));
config = circle_config();
report = compare_edge_methods( ...
    fullfile(root_dir, 'standard_circle.bmp'), ...
    fullfile(root_dir, 'zernikeEdgePoints.txt'), config);
fprintf('像素级平均绝对误差: %.6f\n', report.pixel_mae);
fprintf('亚像素平均绝对误差: %.6f\n', report.subpixel_mae);
