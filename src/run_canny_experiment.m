function points = run_canny_experiment(image_path, points_path, config)
%RUN_CANNY_EXPERIMENT 生成标准圆、提取 Canny 边缘并保存坐标。
    if ~exist(image_path, 'file')
        image = generate_standard_circle(config);
        imwrite(image, image_path);
    else
        image = imread(image_path);
    end
    edge_image = edge(image, 'canny');
    [rows, cols] = find(edge_image);
    points = [rows, cols];
    writematrix(points, points_path, 'delimiter', ' ');

    figure('Visible', 'off');
    imshow(image, []); hold on;
    viscircles([config.center_x, config.center_y], config.radius, 'Color', 'r');
    plot(cols, rows, 'og');
    title('标准圆与 Canny 边缘');
    close(gcf);
end
