function ref_coeffs = reflectedVoltageSignalToReflectionCoefficients(ref_voltage_signal)

ref_coeffs = zeros(length(ref_voltage_signal), 4);
ref_coeffs(:,1) = 0:length(ref_voltage_signal)-1;
ref_coeffs(:,2) = 1:length(ref_voltage_signal);
ref_coeffs(:,3) = 0:length(ref_voltage_signal)-1;

start = tic;
for i = 1:length(ref_voltage_signal)
    if toc(start) > .25
        fprintf('Generating reflection coefficient %d/%d.\n',i,length(ref_voltage_signal));
    end
    paths = allPathsGenerator(i); % get paths in form +1,-1,+1,-1
    light_transitions = transitionsFromPaths(paths); % expand paths representation
    [~, ~, time_step] = deepestRow(light_transitions);
    if time_step ~= i
        error('Error with calculated paths.');
    end
    [ref_coeffs(i,4)] = ...
        mediumCalculator(ref_voltage_signal(1:i),...
        ref_coeffs(1:i,:), light_transitions,i);
    
    if toc(start) > .25
        c = clock();
        % make hour two digit
        if c(4)<10
            cur_hour = ['0', num2str(c(4))];
        else
            cur_hour = num2str(c(4));
        end
        % make minute two digit
        if c(5)<10
            cur_minute = ['0', num2str(c(5))];
        else
            cur_minute = num2str(c(5));
        end
        fprintf('Calculated reflection coefficients %d/%d: %2.2f seconds in.\nCurrent Time: %s:%s.\n\n',i,length(ref_voltage_signal),toc(start),cur_hour,cur_minute);
    end
end
end