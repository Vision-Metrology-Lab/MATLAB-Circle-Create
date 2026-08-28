%% 边缘检测对比实验入口
root_dir = fileparts(fileparts(mfilename('fullpath')));
run(fullfile(root_dir, 'subPixel_cpp.m'));
