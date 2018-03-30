clear
close all
mu = [4.39818651728509];
lambda = 0.1;
K = @(y) K_KER(y);
W = @(y) W_KER(y,mu,lambda);
%% My estimator
iter = 500;
baba = zeros(1,iter);
num =300;
h = num^(-0.5); %bandwidth

tic
for k=1:iter
X = mvnrnd(0,1,num); 
Y = mvnrnd(2,1,num);
sum1 = 0;
var1 = 0;
for i =1:num-1
    X_i = X(i,:);
    X_op = X(i+1:end,:);
    Y_i = Y(i,:);
    Y_op = Y(i+1:end,:);
    sum1 = sum1+sum(K((X_i-X_op)./h).*(W(X_i)+W(X_op))+K((Y_i-Y_op)./h).*(W(Y_i)+W(Y_op))-K((X_i-Y_op)./h).*(W(X_i)+W(Y_op))-K((X_op-Y_i)./h).*(W(Y_i)+W(X_op)));
    var1 = var1+sum(K((X_i-X_op)./h).*(W(X_i).^2+W(X_op).^2)+K((Y_i-Y_op)./h).*(W(Y_i).^2+W(Y_op).^2)+K((X_i-Y_op)./h).*(W(X_i).^2+W(Y_op).^2)+K((X_op-Y_i)./h).*(W(Y_i).^2+W(X_op).^2));
end
T_n2 = sum1/(num*(num-1)*h);
var1 =  2*var1/(num*(num-1)*h)*1/(2*pi^0.5);
baba(k) = (num-1)*h^0.5*T_n2/var1^0.5;

end
toc
%% Plot
figure
hist(baba)
figure
plot(baba);
disp(mean(abs(baba)<1.96))
    
