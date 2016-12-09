clear; more off; close all; hold on;
data_filename = 'data/C1Microstrip_Stepped_Impedance_Port_1_Average_100_Attempt_200000.dat';
data_filename_2 = 'data/C1Microstrip_Stepped_Impedance_Port_2_Average_100_Attempt_200000.dat';
true_values = [50,30,80,50,80,30,50,50,50,50];
% import file 1
data_1 = importdata(data_filename);
times_1_ns = data_1(:,1)*1e9;
data_values_1 = data_1(:,2);
% import file 2
data_2 = importdata(data_filename_2);
times_2_ns = data_2(:,1)*1e9;
data_values_2 = data_2(:,2);

%plot data
fh = figure(1);
plot(times_1_ns, data_values_1, times_2_ns, data_values_2);
start_time_ns = 34.95;
stop_time_ns = 39.2;
data_value_estimates = [53.3, 30.0, 67.1, 54.3, 67.75, 44.1, ...
 38.9, 50.6, 50.6, 48.5, 53.0, 53.0, 50.5, 52.1, 52.1, 52.1];
breaktimes = [30, linspace(start_time_ns, stop_time_ns, length(data_value_estimates)-1)];
stairs(breaktimes, data_value_estimates,'k');
hy = ylabel('Impedance (\Omega)'); hx = xlabel('Time (ns)');
set(hy, 'FontSize', 14); set(hx, 'FontSize', 14);
legend('Port 1', 'Port 2', 'Approximation');

tikzify(fh, 'measurement_with_boxing/measurement_with_boxing.tikz',...
    'measurement_with_boxing/data','tikz/measurement_with_boxing/data');

%%% Next Figure
% import ADS data
ideal_z = dlmread('Z_ref_ideal_ADS.txt','\t',[1 0 809 1]);
physical_z = dlmread('Z_ref_ideal_ADS.txt','\t',[813 0 1621 1]);
fh = figure(2);
plot(ideal_z(:,1)*1e9,ideal_z(:,2),...
physical_z(:,1)*1e9, physical_z(:,2),...
times_1_ns-34.9,data_values_1);
legend('ADS Ideal', 'ADS Microstrip', 'Measurement (port 1)');
hy = ylabel('Impedance (\Omega)'); hx = xlabel('Time (ns)');
set(hy, 'FontSize', 14); set(hx, 'FontSize', 14);
axis([-1, 5, 10, 100])

% Apply corrections
reflection_coefficients = zeros(1,length(data_value_estimates)-1);
reflection_coefficients(1,1) = ...
(data_value_estimates(1)-50)/(data_value_estimates(1)+50);
for i = 2:length(data_value_estimates)-1
  reflection_coefficients(1,i) = (data_value_estimates(i) - 50)...
  /(data_value_estimates(i) + 50);
end

results = reflectionCoefficientsFromVoltageSignal(reflection_coefficients(1:5));
figure(3); hold on;
stairs(true_values(1:length(results)));
stairs(data_value_estimates(1:length(results)));
stairs(reflectionCoefficientsToImpedances(results,50));
hy = ylabel('Impedance (\Omega)'); hx = xlabel('Time (step)');
set(hy, 'FontSize', 14); set(hx, 'FontSize', 14);
axis([0 length(results) 20 80]);
legend('Goal', 'Data Estimates', 'Peeling Result');