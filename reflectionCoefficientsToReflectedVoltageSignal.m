function ref_voltage_signal = reflectionCoefficientsToReflectedVoltageSignal(ref_coeffs, time_steps)
% generated a reflected voltage signal from an array of reflection coefficients

paths_amplitude = zeros(length(time_steps),1);
% generate paths for each time step
fprintf('Generating voltage signal.\n');
start = tic;
for i = 1:time_steps
    % Generate all new transitions;
    cur_transitions = transitionsFromPaths(allPathsGenerator(i));
    depths = max(cur_transitions,[],2);
    % select only those rows that have the proper depth
    cur_transitions = cur_transitions(depths <= size(ref_coeffs,1),:);
    path_amplitude = zeros(size(cur_transitions,1),1);
    
    if toc(start) > .25
        fprintf('Calculating the path amplitudes at time step %d.\n', i);
    end
    
    for j = 1:size(cur_transitions,1)
        path_amplitude(j,1) = calcPathAmplitude(ref_coeffs(1:min(i,size(ref_coeffs,1)),:),cur_transitions(j,:));
        if toc(start) > .25 && mod(j,floor(size(cur_transitions,1)/10)) == 0
            if exist('str','var')
                % clear the old line
                fprintf(sprintf('%s',char(8)*ones(1,length(str)-1)));
            end
            str = sprintf('Calculating path amplitude %d of %d: %2.2f%%%% done.',j,size(cur_transitions,1),100*j/size(cur_transitions,1));
            fprintf(str);
        end
    end
    if exist('str','var')
        fprintf(sprintf('%s',char(8)*ones(1,length(str)-1)));
    end
    clear 'str';
    paths_amplitude(i,1) = sum(path_amplitude);
    % give some feedback if it's been taking a while
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
        fprintf('Calculated reflection coefficients %d/%d: %2.2f seconds in.\nCurrent Time: %s:%s.\n\n',i,time_steps,toc(start),cur_hour,cur_minute);
    end
end
ref_voltage_signal = cumsum(paths_amplitude);
end