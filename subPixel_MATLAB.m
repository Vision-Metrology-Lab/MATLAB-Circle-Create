%% 生成 MATLAB 计算的亚像素（连续）
% 生成标准圆并使用 canny 法进行边缘检测，得到标准圆边缘点坐标
% 存储在 cannyEdgePoints.txt 中

%% 清空命令窗口和工作区
clc, clear;
close all;

%% 参数设置
imageWidth = 512;      % 图像宽度
imageHeight = 512;     % 图像高度
circleCenterX = 256.3; % 圆心 x 坐标（亚像素位置）
circleCenterY = 256.7; % 圆心 y 坐标（亚像素位置）
circleRadius = 100.5;  % 圆半径（亚像素级别）
edgeWidth = 3;         % 过渡边缘宽度（像素）
superSamplingFactor = 4; % 超采样倍数（建议 2 - 4）

%% 代码主要功能
% 生成超采样网格
[superSampledX, superSampledY] = generateSuperSampledGrid(imageWidth, imageHeight, superSamplingFactor);

% 计算符号距离函数
signedDistanceFunction = computeSignedDistanceFunction(superSampledX, superSampledY, circleCenterX, circleCenterY, circleRadius);

% 创建平滑过渡
alpha = createSmoothTransition(signedDistanceFunction, edgeWidth);

% 下采样到原始分辨率
downSampledAlpha = downSampleToOriginalResolution(alpha, superSamplingFactor, imageWidth, imageHeight);

% 设置中心区域为纯白
downSampledAlpha(downSampledAlpha > 0.999) = 1;

% 生成灰度图像
grayImage = generateGrayImage(downSampledAlpha);

% 显示生成的灰度圆
displayGrayCircle(grayImage, circleCenterX, circleCenterY, circleRadius);

% 边缘检测并标记边缘像素
[edgeCols, edgeRows] = markEdgePixels(grayImage);

%% 储存边缘点信息
points = [edgeRows, edgeCols];
filename = './Data/cannyEdgePoints.txt';
% 使用 dlmwrite 函数将矩阵保存到文本文件中，用空格分隔
writematrix(points, filename, 'delimiter', ' ');


%% 后续处理参数设置
templateSize = 32;             % 模板尺寸
gaussianSigma = 2;             % 高斯滤波参数
cannyThreshold = [0.4, 0.5];   % Canny 阈值
effectiveEdgeThreshold = 0.5;  % 有效边缘阈值

%% 辅助函数

% 生成超采样网格的函数
function [X, Y] = generateSuperSampledGrid(width, height, samplingFactor)
    [X, Y] = meshgrid(linspace(0.5, width + 0.5, width * samplingFactor + 1));
    X = X(1:end-1, 1:end-1) + 0.5 / samplingFactor;
    Y = Y(1:end-1, 1:end-1) + 0.5 / samplingFactor;
end

% 计算符号距离函数的函数
function sdf = computeSignedDistanceFunction(X, Y, centerX, centerY, radius)
    sdf = sqrt((X - centerX).^2 + (Y - centerY).^2) - radius;
end

% 创建平滑过渡的函数
function alpha = createSmoothTransition(sdf, edgeWidth)
    t = clamp(sdf / edgeWidth + 0.5, 0, 1); % 归一化到 [0, 1]
    alpha = 6 * t.^5 - 15 * t.^4 + 10 * t.^3; % 五次平滑曲线
end

% 下采样到原始分辨率的函数
function downSampledAlpha = downSampleToOriginalResolution(alpha, samplingFactor, width, height)
    downSampledAlpha = mean(im2col(alpha, [samplingFactor, samplingFactor], 'distinct'), 1);
    downSampledAlpha = reshape(downSampledAlpha, width, height)';
end

% 生成灰度图像的函数
function grayImage = generateGrayImage(alpha)
    grayImage = uint8(255 * alpha);
    grayImage = uint8(abs(double(grayImage) - 255.0));
end

% 显示灰度圆并绘制理论圆形轮廓的函数
function displayGrayCircle(grayImage, centerX, centerY, radius)
    imshow(grayImage, []);
    colormap(gray); % 设置为灰度色图
    xlabel('u - 方向');
    ylabel('v - 方向');
    axis on;
    axis image;
    title('标准圆形');
    hold on;
    viscircles([centerX, centerY], radius, 'Color', 'r');
end

% 边缘检测并标记边缘像素的函数
function [edgeCols, edgeRows] = markEdgePixels(grayImage)
    edgeImage = edge(grayImage, 'canny');
    [edgeRows, edgeCols] = find(edgeImage == 1);
    plot(edgeCols, edgeRows, 'og');
end

% 辅助函数：将值限制在指定区间内
function y = clamp(x, a, b)
    y = max(a, min(x, b));
end