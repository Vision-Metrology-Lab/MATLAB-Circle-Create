# MATLAB 标准圆与亚像素边缘实验

生成带亚像素圆心和半径的标准灰度圆，使用 Canny 提取像素级边缘，并与外部 Zernike 亚像素边缘结果进行对比。

## 目录结构

~~~text
src/circle_config.m             统一实验参数
src/generate_standard_circle.m  标准圆生成
src/run_canny_experiment.m      Canny 边缘提取
src/compare_edge_methods.m      Canny/Zernike 对比和误差统计
scripts/                        实验入口
creatCircle.m                   标准圆生成兼容入口
subPixel_MATLAB.m               Canny 兼容入口
subPixel_cpp.m                  对比实验兼容入口
standard_circle.bmp             示例标准圆
cannyEdgePoints.txt             Canny 边缘点
zernikeEdgePoints.txt           Zernike 边缘点
~~~

## 运行环境

需要 MATLAB Image Processing Toolbox。脚本应从仓库根目录或通过绝对路径运行。

~~~matlab
creatCircle
subPixel_MATLAB
subPixel_cpp
~~~

参数集中在 src/circle_config.m。输入输出路径由入口脚本根据仓库位置计算，不再依赖大小写不一致的 Data/ 目录。Zernike 边缘点由外部 C++ 检测程序生成，本仓库只负责读取和比较。

