function w_ker = W_KER(Y,mu,lambda)

w_ker =exp(-(Y-mu).^2./(2*lambda));
%w_ker=1;