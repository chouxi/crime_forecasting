function [lr_model, dev, stats] = logistic_regression(countMaps, censusMaps, hotspot_rate)
	if size(countMaps) ~= size(censusMaps)
		disp('Wrong shape of input data')
	end
	[t, x, y] = size(countMaps);
	% make top top_num values in the grid to 1
	hotspot_map = zeros([t, x, y]);
	for i=1:size(hotspot_map, 1)
		hot_num = round(size(find(countMaps(i,:)), 2) * hotspot_rate);
		tmp_count = countMaps(i,:);
		[sorted, sorted_idx] = sort(tmp_count, 'descend');
		sorted_idx = sorted_idx(1:hot_num);
		hotspot_map(i,sorted_idx) = 1;
		%size(find(hotspot_map(i,:)==1))
	end
	[t_idx, x_idx, y_idx] = meshgrid(1:t, 1:x, 1:y);
	x_idx = x_idx(:);
	y_idx = y_idx(:);
	t_idx = t_idx(:);
	census_vec = censusMaps(:);
	count_vec = hotspot_map(:);
	x_mean = mean(x_idx);
	x_std = std(x_idx);
	x_idx = (x_idx-x_mean)/ x_std;
	y_mean = mean(y_idx);
	y_std = std(y_idx);
	y_idx = (y_idx-y_mean)/ y_std;
	t_mean = mean(t_idx);
	t_std = std(t_idx);
	t_idx = (t_idx-t_mean)/ t_std;
	%[lr_model, dev, stats] = glmfit([t_idx, x_idx, y_idx, census_vec], count_vec, 'binomial', 'logit');
	%count_mat = glmval(lr_model, [t_idx, x_idx, y_idx, census_vec], 'logit');
	[lr_model, dev, stats] = glmfit([t_idx, x_idx, y_idx], count_vec,'binomial', 'logit');
	count_mat = glmval(lr_model, [t_idx, x_idx, y_idx], 'logit');
	% Error
	mean(count_mat)
	median(count_mat)
end
