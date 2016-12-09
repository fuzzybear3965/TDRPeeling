function [row, row_idx, time_step] = deepestRow(transitions)
% finds the 'deepest' row corresponding to the transition (path) with the
% greatest value (deepest material)
if size(transitions,1) > 1
   [vals, rows] = max(transitions);
   [time_step, col] = max(vals);
   row = transitions(rows(col),:);
   row_idx = rows(col);
else
   row = transitions;
   row_idx = 1;
   time_step = max(transitions);
end
if numel(time_step) > 1
   error('More than one deepest path.')
end

end
