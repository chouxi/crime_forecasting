clear
clc

%% read shapefiles
[X,Y,Census,T] = preprocess('TOA');

%% gennerate image-like data
category = 'SC'; 
period = '1MO';
[data, countMaps, censusMaps] = generateByPeriodAndGrid(category,period,600);
save([category,'_',period,'_countMaps'], 'countMaps')
%% draw data (total)
bar(1:length(data.summary), data.summary);
title([category,'-',period]);

%% save gifs
% saveGifs(category,period,countMaps,censusMaps);

%% test GP
load('SC_1MO_countMaps')
[model,img_test,img_pred,ysd,err_training,err_test] = gaussian_process(countMaps);

%%
close all

figure
imshow(img_test,[]);

figure
imshow(img_pred,[]);

ysd1 = ysd;
ysd1( ysd1 > min(ysd1)+ (max(ysd1)-min(ysd1))*0.9 ) = 0;
ysd1( ysd1 ~=0 ) = 1;
ysd_img = reshape(ysd1,138,163);
img_pred_norm = img_pred.*ysd_img;
err_norm = sqrt(mean( (img_pred_norm(:) - img_test(:)).^2 ));

figure
imshow(img_pred_norm, []);

%% show PAI and PEI with respect to number of proposed grids
close all
% compute the range of number of hotspot
gridSz = 600;
[nRange, nTotal] = computeResultRange(gridSz);
[PAI_pred,PEI_pred,PAI_best] = computePAIandPEI(img_pred_norm,img_test,nRange,true);


%% simple average baseline
close all
period = '1MO';
[img_test_base, img_pred_base] = baseline_average_over_chain(countMaps,period);
% compute the range of number of hotspot
gridSz = 600;
[nRange, nTotal] = computeResultRange(gridSz);
[PAI_pred_base,PEI_pred_base,PAI_best_base] = computePAIandPEI(img_pred_base,img_test_base,nRange,true);