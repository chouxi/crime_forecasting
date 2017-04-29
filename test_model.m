%clear
%clc
%[data, countMaps, censusMaps] = generateByPeriodAndGrid('SC', '1MO', 600);
%save('data.mat')
%% Get center of logistic regression gaussain.
load('data.mat')
sum_count = mean(countMaps,1);
sum_count = squeeze(sum_count);
sum_count(sum_count<=2)=0;
figure
imshow(sum_count)
mean_num = 5;
[idx_y, idx_x] = find(sum_count~=0);
%[x_idx, y_idx] = meshgrid(1:size(sum_count,1), 1:size(sum_count, 2));
%crime_mat = [x_idx(:),y_idx(:), sum_count(:)];
%x = find(crime_mat(:,3)>2);
%crime_mat = crime_mat(x,:);
%crime_mat = [crime_mat(:,1) crime_mat(:,2)];
crime_mat = [idx_y, idx_x];
[idx,C]= kmeans(crime_mat,mean_num);
figure;
%imshow(sum_count,[])
plot(crime_mat(:,2),164-crime_mat(:,1),'k.');
hold on
for i=1:mean_num
    plot(crime_mat(idx==i,2),164-crime_mat(idx==i,1),'.','MarkerSize',12)
    hold on
    plot(C(i,2), 164-C(i,1), '+', 'MarkerSize', 30)
end
% plot(crime_mat(idx==1,2),164-crime_mat(idx==1,1),'.','MarkerSize',12)
% plot(C(1,2), C(1,1), '+', 'MarkerSize', 30)

%%
Centers = [C(:,2), C(:,1)];
[predict_mat, sigma_mat, real_mat] = baseline_linear_regression(countMaps, censusMaps, Centers);
figure
imshow(predict_mat,[])

sigma_mat1 = sigma_mat;
sigma_mat1( sigma_mat1 > min(sigma_mat1)+ (max(sigma_mat1)-min(sigma_mat1))*0.9 ) = 0;
sigma_mat1( sigma_mat1 ~=0 ) = 1;
ysd_img = reshape(sigma_mat1,138,163);
img_pred_norm = predict_mat.*ysd_img;
figure
imshow(img_pred_norm, []);