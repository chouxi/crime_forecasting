clc
close all
clear

x = [1:0.1:50]';
yTrue = x .* sin(x);
yTrain = yTrue+5*randn(length(x),1);
theta0 = [0.2, 1.5, 0.2, 1.5];

kfcn = @(XN,XM,theta) (theta(1)^2)*exp(-(pdist2(XN,XM).^2)/(2*theta(2)^2))...
    + theta(3)*exp( -2*sin(pdist2(XN,XM)*pi/12).^2 )/(theta(4).^2);
model = fitrgp(x,yTrain,'Basis','linear',...
        'KernelFunction',kfcn,'KernelParameters',theta0,...
      'FitMethod','exact','PredictMethod','exact');
  
[y_gp,ysd] = predict(model,x);
figure;
plot(x, yTrue, 'g'); hold on,
plot(x, y_gp, 'r'); hold on,
plot(x, y_gp+ysd, 'r:'); hold on,
plot(x, y_gp-ysd, 'r:'); hold off,
legend('Ground truth', 'GP');
xlabel('x');
ylabel('count(total)');
title('Estimation of count(total)');
