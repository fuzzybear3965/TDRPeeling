function [new_ref_coeff] = mediumCalculator(ref_voltage, ref_coeffs, light_transitions, time_step)
% medium calculator operates on a single step of the TDR history. It requires
% all of the 'learned' information up to this point in time as well as the
% latest measured voltage and the paths that are possible at that time step.

start = tic;
if time_step == 1
    new_ref_coeff = ref_voltage(1); % assume incident waveform is normalized
else
    % find row of deepest path
        [row, row_index, time_step] = deepestRow(light_transitions);
    
    if numel(time_step) > 1
        error(['More than 1 row that reached the deepest level for the' ...
            'corresponding time: ', num2str(row)])
    elseif numel(row) == 0
        error('No path reached that depth for the corresponding time.');
    end
    % loop through all of the paths except for the one we can't figure out yet
    path_amplitudes = zeros(size(light_transitions,1)-1,1);
    loop_cnt = 0;
    
    if toc(start) > .25
        fprintf('Calculating the path amplitudes at time step %d.\n', time_step);
    end
    
    for i = [1:row_index-1,row_index+1:size(light_transitions,1)]
        loop_cnt = loop_cnt + 1;
        
        [path_amplitudes(loop_cnt,1)] = calcPathAmplitude(ref_coeffs,light_transitions(i,:));
        
        if toc(start) > .25 && mod(i,floor(size(light_transitions,1)/10)) == 0
            if exist('str','var')
                % clear the old line
                fprintf(sprintf('%s',char(8)*ones(1,length(str)-1)));
            end
            str = sprintf('Calculating path amplitude %d of %d: %2.2f%%%% done.',i,size(light_transitions,1),100*i/size(light_transitions,1));
            fprintf(str);
        end
    end
    if exist('str','var')
        fprintf(sprintf('%s',char(8)*ones(1,length(str)-1)));
    end
    clear 'str';
    if ~isempty(path_amplitudes)
        prior_paths_amplitude = sum(path_amplitudes); % 'prior paths' contribution
    else
        prior_paths_amplitude = 0;
    end
    
    % now, calculate the amplitudes of all the events except for the latest event
    latest_events = reshape(light_transitions(row_index,:),3,[]).';
    [deepest_event_row, ~] = find(latest_events == time_step);
    event_amplitudes = zeros(size(latest_events,1)-1,1); % cut off the deepest row
    % calculate amplitudes of all events but latest event (which we can't know)
    loop_cnt = 0;
    for i=[1:deepest_event_row-1,deepest_event_row+1:size(latest_events,1)]
        loop_cnt = loop_cnt + 1;
        event_amplitudes(loop_cnt,1) = calcPathAmplitude(ref_coeffs,latest_events(i,:));
    end
    partial_latest_path_amplitude = prod(event_amplitudes);
    new_ref_coeff = (ref_voltage(time_step) - ...
        ref_voltage(time_step-1) - ...
        prior_paths_amplitude)/partial_latest_path_amplitude;
end

end
