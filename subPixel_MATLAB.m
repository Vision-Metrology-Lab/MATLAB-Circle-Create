%% MATLAB Canny 边缘提取兼容入口
clear; clc; close all;
root_dir = fileparts(mfilename('fullpath'));
addpath(fullfile(root_dir, 'src'));
config = circle_config();
run_canny_experiment( ...
    fullfile(root_dir, 'standard_circle.bmp'), ...
    fullfile(root_dir, 'cannyEdgePoints.txt'), config);
