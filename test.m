clear
clc

%% read shapefiles
[X,Y,Census,T] = preprocess('TOA');

%% gennerate data
category = 'SC'; 
period = '1MO';
[data, countMaps, censusMaps] = generateByPeriodAndGrid(category,period,600);

%%
bar(1:length(data.summary), data.summary);
title([category,'-',period]);
% saveGifs(category,period,countMaps,censusMaps);