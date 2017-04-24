clear
clc

%% read shapefiles
[X,Y,Census,T] = preprocess('TOA');

%% gennerate image-like data
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

%% precess maps
[x_train, y_train] = images2inputs(countMaps(1:end-3,:,:));
y_train = y_train(y_train~=0);
x_train = x_train(y_train~=0,:);
[x_train_norm, mu, sigma] = zscore(x_train);
y_train_prob = rescaleMat(y_train,0,1);

%% test GP
gpModel = gaussian_process(x_train_norm, y_train_prob);
L1 = resubLoss(gpModel);

%% predict
[x_test,y_test] = images2inputs(countMaps(end-2,:,:));
x_test_norm = (x_test - mu)./sigma;
y_test_prob = rescaleMat(y_test,0,1);
[y_test_pred,~,yci] = predict(gpModel,x_test_norm);

%%
img = reshape(y_test_prob,138,163);
img_pred = reshape(y_test_pred,138,163);