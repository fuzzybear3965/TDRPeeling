function [transitions] = transitionsFromPaths(paths)
% paths is a matrix of paths with num_paths rows and num_steps columns
% [+1, +1, -1, -1] is the following path: T_10 > R_21 > T_01
% -> [[0,1,1],[1,2,1],[1,0,0]]

num_steps = size(paths,2);
transitions = zeros(size(paths,1), (num_steps-1)*3);
%changes = diff(paths,1,2); % compute (j,n+1) - (j,n) for all j
%changes = paths(:,1:end-1).*paths(:,2:end); % A(j,n)*A(j,n+1) \forall j,n
% loop through changes
cur_medium = zeros(size(paths,1),1);
is_going_deeper = ones(size(paths,1),1); % assume it's moving forward first; true ==1, false == 0
for i = 1:size(paths,2)-1
   is_transmission = paths(:,i).*paths(:,i+1);  % +1 (trans) / -1 (ref)
   is_transmission = .5*(is_transmission + 1); % 1 == trans, 0 == ref
   transitions(:,3*i-2:3*i) = [cur_medium, ...
   cur_medium + 2*is_going_deeper-1 , ...
   cur_medium + is_transmission .* (2*is_going_deeper-1)]; % describe transition
   cur_medium = transitions(:,3*i); % update cur_medium
   is_going_deeper = not(xor(is_going_deeper,is_transmission)); % update direction
end
end
