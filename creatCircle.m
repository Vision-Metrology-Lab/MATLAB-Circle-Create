%% creatCircle.m
% 该脚本生成标准圆并存储

%% 清空工作区
clc, clear;
close all;

%% 参数设置
widths = 512;          % 图像宽度
heights = 512;        % 图像高度
cx = 256.3;           % 圆心x坐标（亚像素位置）
cy = 256.7;           % 圆心y坐标（亚像素位置）
radius = 100.5;       % 圆半径（亚像素级别）
edgewidths = 3;        % 过渡边缘宽度（像素）
samples = 4;          % 超采样倍数（建议2-4）

%% 生成超采样网格（亚像素精度提升）
[Xs, Ys] = meshgrid(linspace(0.5, widths+0.5, widths*samples+1));
Xs = Xs(1:end-1, 1:end-1) + 0.5/samples;
Ys = Ys(1:end-1, 1:end-1) + 0.5/samples;

%% 计算符号距离函数（精确到亚像素）
SDF = sqrt((Xs - cx).^2 + (Ys - cy).^2) - radius;

%% 创建平滑过渡（五次多项式插值）
t = clamp(SDF / edgewidths + 0.5, 0, 1); % 归一化到[0,1]
alpha = 6*t.^5 - 15*t.^4 + 10*t.^3;     % 五次平滑曲线

%% 下采样到原始分辨率
alpha = mean(im2col(alpha, [samples samples], 'distinct'), 1);
alpha = reshape(alpha, widths, heights)';

%% 设置中心区域为纯白（补偿超采样误差）
alpha(alpha > 0.999) = 1;

%% 生成灰度图像
grayImage = uint8(255 * alpha);
grayImage = uint8(abs(double(grayImage) - 255.0));

%% 保存图像
% savePath = '.\Data\standard_circle.jpg'; % 保存的文件名和路径
% imwrite(grayImage, savePath);

%% 显示生成的灰度圆
imshow(grayImage, []);
colormap gray; % 设置为灰度色图
xlabel("u-方向");
ylabel("v-方向");
ax = gca;
axis on;
axis image;
title('标准圆形');

%% 辅助函数
function y = clamp(x, a, b)
    y = max(a, min(x, b));
end