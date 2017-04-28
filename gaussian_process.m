function [model,img_test,img_pred,ysd,err_training,err_test] = gaussian_process(countMaps)

% transfer images to features and counts and normalize

[nt,ny,nx] = size(countMaps);
x_train = [];
y_train = [];
for k=1:nt-3
    countMap = squeeze(countMaps(k,:,:));
    [x,y] = image2input(countMap,k,-1);
    x_train = [x_train;x];
    y_train = [y_train;y];
end
[~, mu, sigma] = zscore(x_train);
x_train = [];
y_train = [];
for k=1:nt-3
    countMap = squeeze(countMaps(k,:,:));
    [x,y] = image2input(countMap,k,100);
    x_train = [x_train;x];
    y_train = [y_train;y];
    
%     img = zeros(ny,nx);
%     xCoord = x(:,1);
%     yCoord = x(:,2);
%     linearInd = sub2ind(size(img),yCoord,xCoord);
%     img(linearInd) = y;
%     imshow(img);
%     title(num2str(k))
%     w = waitforbuttonpress;
end
x_train_norm = (x_train - mu)./sigma;

if exist('gpModel.mat', 'file') == 0
    % fit
    disp('begin fitting');
    model = fitrgp(x_train_norm,y_train,'KernelFunction','squaredexponential','Sigma', 1.5);
%     sigma0 = std(y_train);
%     sigmaF0 = sigma0;
%     d = size(x_train_norm,2);
%     sigmaM0 = 10*ones(d,1);
%     model = fitrgp(x_train_norm,y_train,'Basis','constant','FitMethod','exact',...
%     'PredictMethod','exact','KernelFunction','ardsquaredexponential',...
%     'KernelParameters',[sigmaM0;sigmaF0],'Sigma',sigma0,'Standardize',1);
%     
%     rng default
%     model = fitrgp(x_train_norm,y_train,'KernelFunction','squaredexponential',...
%     'OptimizeHyperparameters','auto','HyperparameterOptimizationOptions',...
%     struct('AcquisitionFunctionName','expected-improvement-plus'));

    save('gpModel', 'model')
else
    % load
    disp('load model from disk');
    load('gpModel')
end
% estimate training error
disp('begin estimating training error');
err_training = sqrt(resubLoss(model));

% predict
disp('begin predicting');
countMap = squeeze(countMaps(end-2,:,:));
[x_test,y_test] = image2input(countMap,nt-2,-1);
x_test_norm = (x_test - mu)./sigma;
[y_test_pred,ysd] = predict(model,x_test_norm);
% weight = (ysd - min(ysd)) * (max(ysd) - min(ysd));
% y_test_pred = y_test_pred.*weight;
% estimate test error
disp('begin estimating test error');
err_test = sqrt(mean((y_test_pred-y_test).^2));

% transfer features back to image
disp('begin transfering back to image');
img_test = reshape(y_test,138,163);
img_pred = reshape(y_test_pred,138,163);