function [valid_paths, valid_path_count] = allPathsGenerator(n)
% n is the number of reflection planes. There are n-1 possible upstrokes and n-1
% possible downstrokes for a system with n reflection planes.
init_path = [ones(1,n-1), -1*ones(1,n-1)];
perm_paths = uniqueperms(init_path);
cumsum_paths_along_cols = cumsum(perm_paths,2);
valid_paths = perm_paths(all(cumsum_paths_along_cols >= 0,2),:);
valid_paths = unique(valid_paths, 'rows');
valid_paths = [1*ones(max(size(valid_paths,1),1),1),valid_paths, -1*ones(max(size(valid_paths,1),1),1)]; % tack on the initial and final conditions
end
