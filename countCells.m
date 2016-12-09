function n = countCells(cellsContainer)
%% Assumes that all of the cells to be counted are one level below the root
%level so that the structure is something like {{{ }}} (cell of cell of cell)

n = 0;
for i = 1:numel(cellsContainer)
   n = n + numel(cellsContainer{i});
end
end
