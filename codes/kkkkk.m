clc;
clear;

% X and Y are indep normal
%num = 300;
%for moving window
mu = [1.62893209879946];
lambda = [0.00244887239270176];
K = @(y) K_KER(y);
W = @(y) W_KER(y,mu,lambda);
%% My estimator
num2 = 500;
baba = zeros(1,num2);

for k=1:num2
num =300;
h = num^(-0.5); %bandwidth

%rng default  % For reproducibility
X = mvnrnd(0,1,num); %1000*2 vector
 


%rng default  % For reproducibility
Y = mvnrnd(0,1,num);


   
sum = 0;
var= 0;
for i = 1:num-1
    for j=i+1:num
        
        X_i = X(i);
        Y_i = Y(i);
        X_j = X(j);
        Y_j = Y(j);
        
        sum = sum+K((X_i-X_j)/h)*(W(X_i)+W(X_j))+ K((Y_i-Y_j)/h)*(W(Y_i)+W(Y_j)) -K((X_i-Y_j)/h)*(W(X_i)+W(Y_j))-K((X_j-Y_i)/h)*(W(Y_i)+W(X_j));
        %        sum = sum+K((X_i-X_j)/h)*(2)+ K((Y_i-Y_j)/h)*(2) -K((X_i-Y_j)/h)*(2)-K((X_j-Y_i)/h)*(2);

 
        var = var + K((X_i-X_j)/h)*(W(X_i)^2+W(X_j)^2)+ K((Y_i-Y_j)/h)*(W(Y_i)^2+W(Y_j)^2) + K((X_i-Y_j)/h)*(W(X_i)^2+W(Y_j)^2) + K((X_j-Y_i)/h)*(W(Y_i)^2+W(X_j)^2);
      %var = var + K((X_i-X_j)/h)*(2)+ K((Y_i-Y_j)/h)*(2) + K((X_i-Y_j)/h)*(2) + K((X_j-Y_i)/h)*(2);

    end
end
T_n = sum/(num*(num-1)*h);
var =  2*var/(num*(num-1)*h)*1/(2*pi^0.5);
baba(k) = (num-1)*h^0.5*T_n/var^0.5;
%baba(k) = sum/(num*(num-1)*h^2);
%k=k+1;
end
%baba(k) = (num-1)*h*T_n;
%baba(k) = sum/(num*(num-1)*h^2);
%k=k+1;
%end

%% Plot 
figure
hist(baba)

%time =1:12;
%plot(time,baba);

    
