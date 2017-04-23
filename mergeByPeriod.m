function data = mergeByPeriod(X,Y,T,type)
if strcmp(type,'1MO')
    T = (T - mod(T,100))/100;
    [a,b]=hist(T,unique(T));
    data.summary = a';
    N = cell(length(b),1);
    for k = 1:length(b)
        x = X(T==b(k)); 
        y = Y(T==b(k));
        N{k} = [x,y];
    end
    data.detail = N;
end