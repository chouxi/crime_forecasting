function [img_test, img_pred] = baseline_temporal_gp(countMaps,period)
period = validatestring(period,{'1MO'});
[nt,ny,nx] = size(countMaps);

if strcmp(period, '1MO')
    ind_pred = nt-2;
    img_test = squeeze(countMaps(ind_pred,:,:));
    img_pred = zeros(ny,nx);
    for k=1:nt-2
        img = squeeze(countMaps(k,:,:));
        t(k) = sum(img(:));
    end
    t= t';
    x_train = [1:nt-3]';
    t_train = t(1:end-1);
    x_test = [1:nt-2]';
    t_test = t;
    model = fitrgp(x_train,t_train,'KernelFunction','squaredexponential','Sigma', 1.5);
end

[t_gp,tsd] = predict(model,x_test);
figure;
plot(x_test, t_test, 'g'); hold on,
plot(x_test, t_gp, 'r.'); hold on,
legend('Ground truth', 'GP');
xlabel('x');
ylabel('count(total)');
title('Estimation of count(total)');

