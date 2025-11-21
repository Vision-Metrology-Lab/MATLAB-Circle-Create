%% subPixel_cpp.m
% 通过与标准圆、canny边缘检测得到的边缘的对比
% 验证 DectBase.cpp 文件 Zernike 函数输出的亚像素级边缘是否正确
% 数据读取
%   1.cannyEdgePoints.txt: canny 法检测标准圆得到的边缘点坐标
%   2.zernikeEdgePoints.txt: zernike 法检测标准圆得到的边缘点坐标

%% 清空工作区
clc, clear;
close all;

%% 参数设置
widths = 512;          % 图像宽度
heights = 512;         % 图像高度
cx = 256.3;            % 圆心x坐标（亚像素位置）
cy = 256.7;            % 圆心y坐标（亚像素位置）
radius = 100.5;        % 圆半径（亚像素级别）
edgewidths = 3;        % 过渡边缘宽度（像素）
samples = 4;           % 超采样倍数（建议2-4）

%% 生成超采样网格（亚像素精度提升）
[Xs, Ys] = meshgrid(linspace(0.5, widths + 0.5, widths * samples + 1));
Xs = Xs(1:end-1, 1:end-1) + 0.5 / samples;
Ys = Ys(1:end-1, 1:end-1) + 0.5 / samples;

%% 计算符号距离函数（精确到亚像素）
SDF = sqrt((Xs - cx).^2 + (Ys - cy).^2) - radius;

%% 创建平滑过渡（五次多项式插值）
t = max(0, min(SDF / edgewidths + 0.5, 1));       % 归一化到[0,1]
alpha = 6 * t.^5 - 15 * t.^4 + 10 * t.^3;         % 五次平滑曲线

%% 下采样到原始分辨率
alpha = mean(im2col(alpha, [samples samples], 'distinct'), 1);
alpha = reshape(alpha, widths, heights)';

%% 设置中心区域为纯白（补偿超采样误差）
alpha(alpha > 0.999) = 1;

% 生成灰度图（未启用）
% grayImageGenerated = uint8(255 * alpha);

%% 加载真实图像
grayImagePath = ".\Data\standard_circle.bmp";
grayImage = imread(grayImagePath);

%% 显示灰度图像及边缘检测
imshow(grayImage, []);
colormap gray;
xlabel("u-方向");
ylabel("v-方向");
title('标准圆形');
axis on;
axis image;
hold on;

%% Canny边缘提取
edgeImage = edge(grayImage, 'canny');
[yEdge, xEdge] = find(edgeImage);  % 提取边缘像素坐标
pixelEdgePoints = [xEdge, yEdge];

% 绘制圆和像素边缘点
viscircles([cx, cy], radius, 'Color', 'r');
plot(pixelEdgePoints(:, 1), pixelEdgePoints(:, 2), 'og');

%% 读取亚像素检测结果
subpixelPath = "./Data/zernikeEdgePoints.txt";
if exist(subpixelPath, "file")
    subPixelEdgePoints = readmatrix(subpixelPath);
else
    error("文件 subpixel.txt 不存在！");
end

% 坐标偏移修正
subPixelEdgePoints(:, 1) = subPixelEdgePoints(:, 1) + 1;    % x方向偏移
subPixelEdgePoints(:, 2) = subPixelEdgePoints(:, 2) + 1;  % y方向偏移

% 绘制亚像素点
plot(subPixelEdgePoints(:, 1), subPixelEdgePoints(:, 2), '*b');

%% 设置图像轴和图例
axis equal;
legend('像素提取点', '亚像素提取点');

%% 误差分析
figure;
hold on;

% 像素误差
pixelError = sqrt((pixelEdgePoints(:,1) - cx).^2 + (pixelEdgePoints(:,2) - cy).^2) - radius;
plot(1:length(pixelError), abs(pixelError), '-xr');

% 亚像素误差
subpixelError = sqrt((subPixelEdgePoints(:,1) - cx).^2 + (subPixelEdgePoints(:,2) - cy).^2) - radius;
plot(1:length(subpixelError), abs(subpixelError), '-og');

% 标注
xlabel('点序号', 'FontSize', 12);
ylabel('像素误差', 'FontSize', 12);
legend('像素级定位误差', '亚像素级定位误差');
title('像素定位误差', 'FontSize', 12);
