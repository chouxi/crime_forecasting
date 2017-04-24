clear
clc

%% read shapefiles
[X,Y,Census,T] = preprocess('TOA');

%% gennerate data
category = 'SC'; 
period = '1MO';
[data, countMaps, censusMaps] = generateByPeriodAndGrid(category,period,600);

%% draw data (total)
bar(1:length(data.summary), data.summary);
title([category,'-',period]);

%% save gifs
% saveGifs(category,period,countMaps,censusMaps);

%% compute the range of number of hotspot
[nRange, nTotal] = computeResultRange(600);