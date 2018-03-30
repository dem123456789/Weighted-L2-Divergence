clc;
clear;

% X and Y are indep normal
%num = 300;
%for moving window
mu = 0;
lambda = 1;
mu1 =1;
lambda1 = 2;
K = @(y) K_KER(y);
W = @(y) W_KER(y,mu,lambda);
G = @(y) W_KER(y,mu1,lambda1);
H =@(y) W_KER(y,mu1,lambda1)*W_KER(y,mu,lambda);
%% My estimator
num2 = 1;
baba = zeros(1,num2);

for k=1:num2
num =100;
h = num^(-0.5); %bandwidth

rng(1)  % For reproducibility
X = mvnrnd(0,1,num); %1000*2 vector
 


rng(2)  % For reproducibility
Y = mvnrnd(0,1,num);


   
sum1 = 0;
var1= 0;
sum2 = 0;
var2= 0;
cov12 = 0;

for i = 1:num-1
    for j=i+1:num
        
        X_i = X(i);
        Y_i = Y(i);
        X_j = X(j);
        Y_j = Y(j);
        
        sum1 = sum1+K((X_i-X_j)/h)*(W(X_i)+W(X_j))+ K((Y_i-Y_j)/h)*(W(Y_i)+W(Y_j)) -K((X_i-Y_j)/h)*(W(X_i)+W(Y_j))-K((X_j-Y_i)/h)*(W(Y_i)+W(X_j));
        %        sum = sum+K((X_i-X_j)/h)*(2)+ K((Y_i-Y_j)/h)*(2) -K((X_i-Y_j)/h)*(2)-K((X_j-Y_i)/h)*(2);
        sum2 = sum2+K((X_i-X_j)/h)*(G(X_i)+G(X_j))+ K((Y_i-Y_j)/h)*(G(Y_i)+G(Y_j)) -K((X_i-Y_j)/h)*(G(X_i)+G(Y_j))-K((X_j-Y_i)/h)*(G(Y_i)+G(X_j));
 
        var1 = var1 + K((X_i-X_j)/h)*(W(X_i)^2+W(X_j)^2)+ K((Y_i-Y_j)/h)*(W(Y_i)^2+W(Y_j)^2) + K((X_i-Y_j)/h)*(W(X_i)^2+W(Y_j)^2) + K((X_j-Y_i)/h)*(W(Y_i)^2+W(X_j)^2);
      %var = var + K((X_i-X_j)/h)*(2)+ K((Y_i-Y_j)/h)*(2) + K((X_i-Y_j)/h)*(2) + K((X_j-Y_i)/h)*(2);
       var2 = var2 + K((X_i-X_j)/h)*(G(X_i)^2+G(X_j)^2)+ K((Y_i-Y_j)/h)*(G(Y_i)^2+G(Y_j)^2) + K((X_i-Y_j)/h)*(G(X_i)^2+G(Y_j)^2) + K((X_j-Y_i)/h)*(G(Y_i)^2+G(X_j)^2);
       cov12 = cov12 + K((X_i-X_j)/h)*(H(X_i)+H(X_j))+ K((Y_i-Y_j)/h)*(H(Y_i)+H(Y_j)) + K((X_i-Y_j)/h)*(H(X_i)+H(Y_j)) + K((X_j-Y_i)/h)*(H(Y_i)+H(X_j));
    end
end
T_n = (sum1+sum2)/(num*(num-1)*h);
var3 =  2*(var1+var2+2*cov12)/(num*(num-1)*h)*1/(2*pi^0.5);
baba(k) = (num-1)*h^0.5*T_n/var3^0.5;
%baba(k) = sum/(num*(num-1)*h^2);
%k=k+1;
end
%baba(k) = (num-1)*h*T_n;
%baba(k) = sum/(num*(num-1)*h^2);
%k=k+1;
%end

%% Plot 

%hist(baba)

%time =1:12;
%plot(time,baba);

    
