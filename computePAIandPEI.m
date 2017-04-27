function [PAI_pred,PEI_pred,PAI_best] = computePAIandPEI(img_pred,img_test,nRange,plotResult)

[ny,nx] = size(img_test);
oneCol_test = img_test(:);
[oneCol_test_sorted,~]=sort(oneCol_test,'descend');
PAI_best = [];
PEI_best = [];

oneCol_pred = img_pred(:);
[~,ind]=sort(oneCol_pred,'descend');
oneCol_pred_sorted = oneCol_test(ind);
PAI_pred = [];
PEI_pred = [];
for k=floor(nRange(1)):floor(nRange(2))
    n_best = sum(oneCol_test_sorted(1:k));
    N = nx*ny;
    a = k;
    A = N;
    PAI_best = [PAI_best (n_best/N)/(a/A)];
    PEI_best = [PEI_best 1]; % because we already choose the best PAI_test.
    
    n_pred = sum(oneCol_pred_sorted(1:k));
    PAI_pred = [PAI_pred (n_pred/N)/(a/A)];
    PEI_pred = [PEI_pred n_pred/n_best];
end

if plotResult
    figure;
    plot(PAI_best), hold on
    plot(PAI_pred), hold on
    plot(PAI_best - PAI_pred, 'g:', 'linewidth', 4), hold off
    title('PAI')
    legend('true', 'pred', '(true-pred)')

    figure;
    plot(PEI_best), hold on
    plot(PEI_pred), hold off
    title('PEI')
    legend('ture', 'pred')
end