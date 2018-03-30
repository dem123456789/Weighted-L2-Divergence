function k_ker = K_KER(Y)
%Here we only consider Y is 2 dim vector, we use gaussian kernel

k_ker = (2*pi)^(-0.5).*exp(-Y.^2./2);




end
