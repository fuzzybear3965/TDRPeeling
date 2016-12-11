clear;
more off;

%orig_ref_coeffs = [...
%0,1,0,rand;
%1,2,1,rand;
%2,3,2,rand;
%3,4,3,rand;
%4,5,4,rand;
%5,6,5,rand;
%];

start = tic;

orig_ref_coeffs = [...
0,1,0,(30-50)/(30+50);
1,2,1,(80-30)/(80+30);
2,3,2,(50-80)/(50+80);
3,4,3,(80-50)/(50+80);
4,5,4,(30-80)/(80+30);
5,6,5,(50-30)/(30+50);
];

fprintf('\t------- Generating reflected voltage signals. -------\n');
ref_voltage_signal = ...
reflectionCoefficientsToReflectedVoltageSignal(orig_ref_coeffs,11   );
fprintf('\t------- Finished generating reflected voltage signal. -------\n');

ref_coeffs = zeros(length(ref_voltage_signal),4);
ref_coeffs(:,1) = 0:length(ref_voltage_signal)-1;
ref_coeffs(:,2) = 1:length(ref_voltage_signal);
ref_coeffs(:,3) = 0:length(ref_voltage_signal)-1;
ref_coeffs(:,4) = zeros(length(ref_voltage_signal),1);

% loop through the signal
fprintf('\n\n\t------- Generating reflection coefficients -------\n');
ref_coeffs = reflectedVoltageSignalToReflectionCoefficients(ref_voltage_signal);
fprintf('\t------- Finished generating reflection coefficients -------\n');

number_of_values = min(size(ref_coeffs,1),size(orig_ref_coeffs,1));
fprintf('Took %2.2f seconds to complete.\n',toc(start));
fprintf('\n\tOriginal\tCalculated\n');
fprintf('\t%2.4f\t\t%2.4f\n',[orig_ref_coeffs(1:number_of_values,4), ref_coeffs(1:number_of_values,4)].');
fprintf('\n');
%display(orig_ref_coeffs(:,4))
%display(ref_coeffs(:,4))
% if size(orig_ref_coeffs) == size(ref_coeffs)
%    abs(orig_ref_coeffs - ref_coeffs) < 1e3*eps(min(abs(orig_ref_coeffs),abs(ref_coeffs)))
% end

%% Below used to count paths
%totalCount = 0;
%for i = 1:length(light_paths)
%   totalCount = totalCount + countCells(paths{i});
%   printf('%d paths at time step %d\n\n', countCells(paths{i}), i)
%end
%printf('%d total paths\n', totalCount)

%% Below used for speed tests
%num_tests = 15;
%times = zeros(1,num_tests-2);
%for i = 3:num_tests
%start = tic();
%historyCorrection(1:i)
%times(i-2) = toc(start);
%disp(i)
%toc(start)
%end

%plot(1:num_tests-2,times)
