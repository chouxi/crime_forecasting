clear
clc

%% read shapefiles
[X,Y,Census,T] = preprocess('SC');

%% gennerate image-like data
category = 'SC'; 
period = '1MO';
[data, countMaps, censusMaps] = generateByPeriodAndGrid(category,period,600);
save([category,'_',period,'_countMaps'], 'countMaps')
%% draw data (total)
% load data (specific type and period)
load('SC_1MO_countMaps')
bar(1:length(data.summary), data.summary);
title([category,'-',period]);

%% draw distribution of # of crimes in each month
f = figure;
nt = size(countMaps,1);
for t=1:nt
    img = squeeze(countMaps(t,:,:));
    img = img(:);
    img_noZero = img;
    img_noZero(img==0)=[];
    histogram(img_noZero,'Normalization','Probability');
    hold on,
    x = 1:20;
    lambda = 1;
    y = exp(-lambda).*lambda.^x./factorial(x);
    plot(x,y,'LineWidth',1.5)
    xlim([0,20]);
    title(num2str(t));
    filename = ['figs/hists/hist_',num2str(t),'.png'];
    saveas(f,filename)
    w = waitforbuttonpress;
    hold off,
end

%% collect top 100 of each month and analyze each feature's relationship with # of crimes
close all
X = [];
Y = [];
for k=1:nt
    countMap = squeeze(countMaps(k,:,:));
    [x,y] = image2input(countMap,k,100);
    X = [X;x];
    Y = [Y;y];
end
figure,
subplot(231), plot(X(:,1), Y, 'r.'); xlabel('x');ylabel('count');
subplot(232), plot(X(:,2), Y, 'g.'); xlabel('y');ylabel('count');
subplot(233), plot(X(:,3), Y, 'b.'); xlabel('t');ylabel('count');

% covariance matrix
MatIn = [X Y];
[MatIn_norm, ~, ~] = zscore(MatIn);
C = cov(MatIn_norm)

%% save gifs
% load data (specific type and period)
load('SC_1MO_countMaps')
saveGifs(category,period,countMaps,censusMaps);

%% simple average baseline
close all
% load data (specific type and period)
load('SC_1MO_countMaps')

period = '1MO';
[img_test_base, img_pred_base] = baseline_average_over_chain(countMaps,period);
% compute the range of number of hotspot
gridSz = 600;
[nRange, ~] = computeResultRange(gridSz);
[PAI_pred_base,PEI_pred_base,PAI_best_base] = computePAIandPEI(img_pred_base,img_test_base,nRange,true);

%% simple temporal GLM baseline
close all
% load data (specific type and period)
load('SC_1MO_countMaps')

period = '1MO';
[img_test_temp_glm, img_pred_temp_glm] = baseline_temporal_glm(countMaps,period);
% compute the range of number of hotspot
gridSz = 600;
[nRange, nTotal] = computeResultRange(gridSz);
[PAI_pred_temp_glm,PEI_pred_temp_glm,PAI_best_temp_glm] = computePAIandPEI(img_pred_temp_glm,img_test_temp_glm,nRange,true);

%% simple temporal GP baseline
close all
% load data (specific type and period)
load('SC_1MO_countMaps')

period = '1MO';
[img_test_temp_gp, img_pred_temp_gp] = baseline_temporal_gp(countMaps,period);
% compute the range of number of hotspot
% gridSz = 600;
% [nRange, nTotal] = computeResultRange(gridSz);
% [PAI_pred_temp,PEI_pred_temp,PAI_best_temp] = computePAIandPEI(img_pred_temp,img_test_temp,nRange,true);

%% Gaussian Progress ~ (x,y,t)
% load data (specific type and period)
load('SC_1MO_countMaps')
[model,img_test,img_pred,ysd,err_training,err_test] = gaussian_process(countMaps);

figure, 
subplot(121), imshow(img_test,[]);
subplot(122), imshow(img_pred,[]);

ysd1 = ysd;
ysd1( ysd1 > min(ysd1)+ (max(ysd1)-min(ysd1))*0.9 ) = 0;
ysd1( ysd1 ~=0 ) = 1;
ysd_img = reshape(ysd1,138,163);
img_pred_norm = img_pred.*ysd_img;
err_norm = sqrt(mean( (img_pred_norm(:) - img_test(:)).^2 ));
figure
imshow(img_pred_norm, []);

% compute the range of number of hotspots
gridSz = 600;
[nRange, ~] = computeResultRange(gridSz);
[PAI_pred,PEI_pred,PAI_best] = computePAIandPEI(img_pred_norm,img_test,nRange,true);

