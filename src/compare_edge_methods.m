function report = compare_edge_methods(image_path, zernike_path, config)
%COMPARE_EDGE_METHODS 对比像素级 Canny 与 Zernike 亚像素边缘结果。
    image = imread(image_path);
    edge_image = edge(image, 'canny');
    [rows, cols] = find(edge_image);
    pixel_points = [cols, rows];
    if ~exist(zernike_path, 'file')
        error('找不到 Zernike 边缘点文件: %s', zernike_path);
    end
    subpixel_points = readmatrix(zernike_path) + 1;

    pixel_error = hypot(pixel_points(:, 1) - config.center_x, ...
                        pixel_points(:, 2) - config.center_y) - config.radius;
    subpixel_error = hypot(subpixel_points(:, 1) - config.center_x, ...
                           subpixel_points(:, 2) - config.center_y) - config.radius;
    report.pixel_mae = mean(abs(pixel_error));
    report.subpixel_mae = mean(abs(subpixel_error));
    report.pixel_points = pixel_points;
    report.subpixel_points = subpixel_points;

    figure('Visible', 'off');
    imshow(image, []); hold on;
    plot(pixel_points(:, 1), pixel_points(:, 2), 'og');
    plot(subpixel_points(:, 1), subpixel_points(:, 2), '*b');
    viscircles([config.center_x, config.center_y], config.radius, 'Color', 'r');
    legend('像素级边缘', '亚像素边缘', '理论圆');
    title('Canny 与 Zernike 边缘对比');
    close(gcf);

    figure('Visible', 'off');
    plot(abs(pixel_error), '-xr'); hold on;
    plot(abs(subpixel_error), '-og'); grid on;
    legend('像素级定位误差', '亚像素级定位误差');
    title('边缘定位误差'); ylabel('误差（像素）');
    close(gcf);
end
