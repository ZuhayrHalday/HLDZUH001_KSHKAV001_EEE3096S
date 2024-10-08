% Load the data
data = readtable('eee3096_prac2.xlsx'); 
frequencies = data.Frequency * 2 * pi; % Convert to rad/sec
output_amplitudes = data.OutputAmplitude;

% Calculating the magnitude in dB
input_amplitude = 3.3; 
magnitude_dB = 20 * log10(output_amplitudes / input_amplitude);

% Defining the R and C values for the low-pass filter
R = 1200; % Ohms
C = 150e-9; % Farads

% Plots the experimental magnitude vs frequency data
figure;
semilogx(frequencies, magnitude_dB, 'rx');
hold on; % Keeps the plot open to overlay the Bode plot

% Generating and plotting the Bode plot for the 1st order low-pass filter
% Calculating the transfer function H(s) = 1 / (RCs + 1)
s = tf('s');
H = 1 / (R*C*s + 1);

% Gets the magnitude and frequency data from the Bode plot
[mag,~,w] = bode(H);

% Converts magnitude to dB
mag_dB = 20 * log10(squeeze(mag));

% Plots the magnitude response of the low-pass filter
semilogx(w, mag_dB, 'b-'); % Overlays the Bode plot in blue

% Adds labels, title, and grid
xlabel('Frequency (rad/sec)');
ylabel('Magnitude (dB)');
title('Bode Plot of 1st Order Passive Low-Pass Filter');
grid on;

% Displays the cutoff frequency
cutoff_frequency = 1 / (2*pi*R * C);
disp(['Cutoff Frequency: ', num2str(cutoff_frequency), ' Hz']);

legend('Measured Data Points', 'Theoretical Bode Plot', 'Location','southwest');
hold off; % Releases the plot
