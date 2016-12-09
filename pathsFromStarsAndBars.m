function paths = pathsFromStarsAndBars(stars_and_bars)
% this returns all of the paths for a particular time.
% stars_and_bars is in the form of a cell of cells
num_paths = 0;
for i=1:length(stars_and_bars)
   i
   % loop through number of stars
   for j = 1:length(stars_and_bars{i})
      j
      % loop through number of resulting arrangements
      num_paths = num_paths+1;
      path = stars_and_bars{i}{j};
      number_of_stars = sum(path);
      number_of_bars = length(path)-1;
      % len_working_path is the resource value of this path... the total number of +s
      % and -s.
      len_working_path = 2*number_of_stars + number_of_bars;
      working_path = zeros(1,len_working_path);
      index_counter = 1; % keep track of where we are in the output array
      plus_counter = 1;
      max_pluses = number_of_bars/2;
      for j = 1:length(path)
         if path(j) ~= 0
            start = index_counter;
            stop = start + 2*path(j)-1; % should have (2*#-of-stars) assigned
            working_path(1,start:stop) = repmat([-1,1],1,path(j));
            index_counter = index_counter + 2*path(j);
         end
         if plus_counter <= max_pluses
            working_path(index_counter) = 1;
            plus_counter = plus_counter + 1;
            index_counter = index_counter + 1;
         elseif plus_counter > max_pluses && j < length(path)
            working_path(index_counter) = -1;
            index_counter = index_counter + 1;
      end
   end
   paths(num_paths,:) = working_path;
end
end
