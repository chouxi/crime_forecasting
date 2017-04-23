clear
clc

%% read shapefiles
[X,Y,Census,T] = preprocess('TOA');

%% gennerate heat maps
[data, countMaps, censusMaps] = generateByPeriodAndGrid('BURG', '1MO', 600);
bar(1:length(data.summary), data.summary);