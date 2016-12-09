function [path_amplitude] = calcPathAmplitude(reflection_coefficients, some_path)
% calcEventAmplitudes calculateds the amplitude of each event in a 1 x 3n array
% for 1 path with n events (transmission/reflection) each.

if size(some_path,1) > 1
   error('Too many paths passed.');
end
if size(reflection_coefficients,2) ~= 4
   error('Reflection coefficients not passed in the right format.');
end
num_events = size(some_path,2)/3;
event_amplitudes = ones(1,num_events);
% loop through events

for i = 1:num_events
   path_event = some_path(3*i-2:3*i); % 3-tuple indicating xmsn or refln
   % rows corresponding to medium in which either light is present or incident
   [cur_medium_rows, ~] = find(path_event(1,1) == reflection_coefficients(:,1:2));
   [inc_medium_rows, ~] = find(path_event(1,2) == reflection_coefficients(:,1:2));
   % the row that contains the reflection coefficient ofte
   event_row = intersect(cur_medium_rows, inc_medium_rows);
   % identify reflection events
   if path_event(1,1) == path_event(1,3)
      % the cur_medium is lesser than the reflected medium (forward case)
      if path_event(1,1) == path_event(1,2) - 1
         event_amplitude = reflection_coefficients(event_row,4);
         % cur_medium is greater than the reflected medium (reverse case)
      elseif path_event(1,1) == path_event(1,2) + 1
         event_amplitude = -1*reflection_coefficients(event_row,4);
      else
         error(['Reflected path doesn''t make sense: ', num2str(path_event),...
         '. Path is: ', num2str(some_path)]);
      end
   % transmission deeper event (cur_medium < next_medium)
   elseif path_event(1,1) == path_event(1,3) - 1
      event_amplitude = 1 - reflection_coefficients(event_row,4);
   % transmission shallower event (cur_medium > next_medium)
   elseif path_event(1,1) == path_event(1,3) + 1
      event_amplitude = 1 + reflection_coefficients(event_row,4);
   else
      error(['Path doesn''t make sense: ', num2str(path_event)])
   end
event_amplitudes(i) = event_amplitude;
end
path_amplitude = prod(event_amplitudes);
end
