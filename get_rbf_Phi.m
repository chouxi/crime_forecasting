function Phi = get_rbf_Phi(x, mu, gamma)
N = length(x);
M = length(mu);
Phi = zeros(N, M+1);
for i = 1:N
    for j = 1:M+1
        if j==1
            Phi(i, j) = 1;
        else
            Phi(i, j) = exp(-gamma(j-1) * ( x(i)-mu(j-1) )^2 );
        end
    end
end 