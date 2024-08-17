% MATLAB code to generate LUTs for Sin, Saw, and Triangle waves

NS = 128;  % Number of samples in LUT

% Generate Sin LUT
Sin_LUT = round((1023 / 2) * (1 + sin(2 * pi * (0:NS-1) / NS)));

% Generate Saw LUT
Saw_LUT = round((0:NS-1) * (1023 / (NS - 1)));

% Generate Triangle LUT
Triangle_LUT = round([2 * (0:NS/2-1) * (1023 / (NS - 1)), 2 * (NS/2-1:-1:0) * (1023 / (NS - 1))]);

% Plotting to verify
subplot(3,1,1);
plot(Sin_LUT);
title('Sinusoidal Wave');

subplot(3,1,2);
plot(Saw_LUT);
title('Sawtooth Wave');

subplot(3,1,3);
plot(Triangle_LUT);
title('Triangular Wave');

% Print Sin LUT in C array format
fprintf('uint32_t Sin_LUT[%d] = {', NS);
fprintf('%d, ', Sin_LUT(1:NS-1));
fprintf('%d};\n\n', Sin_LUT(NS));

% Print Saw LUT in C array format
fprintf('uint32_t Saw_LUT[%d] = {', NS);
fprintf('%d, ', Saw_LUT(1:NS-1));
fprintf('%d};\n\n', Saw_LUT(NS));

% Print Triangle LUT in C array format
fprintf('uint32_t Triangle_LUT[%d] = {', NS);
fprintf('%d, ', Triangle_LUT(1:NS-1));
fprintf('%d};\n\n', Triangle_LUT(NS));
