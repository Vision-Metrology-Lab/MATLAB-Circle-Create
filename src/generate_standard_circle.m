function gray_image = generate_standard_circle(config)
%GENERATE_STANDARD_CIRCLE 使用超采样和平滑 SDF 生成标准灰度圆。
    [x, y] = meshgrid(linspace(0.5, config.width + 0.5, ...
        config.width * config.supersampling + 1));
    x = x(1:end-1, 1:end-1) + 0.5 / config.supersampling;
    y = y(1:end-1, 1:end-1) + 0.5 / config.supersampling;
    sdf = sqrt((x - config.center_x).^2 + (y - config.center_y).^2) - config.radius;
    t = max(0, min(sdf / config.edge_width + 0.5, 1));
    alpha = 6 * t.^5 - 15 * t.^4 + 10 * t.^3;
    alpha = mean(im2col(alpha, [config.supersampling config.supersampling], 'distinct'), 1);
    alpha = reshape(alpha, config.width, config.height)';
    alpha(alpha > 0.999) = 1;
    gray_image = uint8(abs(double(uint8(255 * alpha)) - 255));
end
