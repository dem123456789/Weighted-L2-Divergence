clear;
close all;
% X and Y are indep normal
%num = 300;
%for moving window
% mu = -5:1:6;
% lambda = [0+1e-4:0.1:1+1e-4 1e10];
mu=[0 3];
lambda=[0.01 1e10];
[LAMBDA,MU] = meshgrid(lambda,mu);
% mu1 =1;
% lambda1 = 2;
K = @(y) K_KER(y);
W = @(y) W_KER(y,MU,LAMBDA);
% G = @(y) W_KER(y,mu1,lambda1);
% H =@(y) W_KER(y,mu1,lambda1)*W_KER(y,mu,lambda);

%% My estimator
num2 = 500;
baba = zeros(1,num2);
nonweight_baba = zeros(1,num2);
tic
for k=1:num2
num =100;
h = num^(-0.5); %bandwidth

% rng(1) % For reproducibility
% X = mvnrnd(0,1,num); %1000*2 vector
% X = GenData(num,1,'laplace',0,sqrt(2)/200);
X = GenData(num,1,'mvnorm',0,1);

% rng(2)  % For reproducibility
% Y = mvnrnd(3,1,num);
% Y = GenData(num,1,'laplace',0,sqrt(2)/100);
Y = GenData(num,1,'mvnorm',0,2);
   
sum1 = 0;
var1= 0;
% sum2 = 0;
% var2= 0;
% cov12 = 0;
for i = 1:num-1
    for j=i+1:num
        
        X_i = X(i);
        Y_i = Y(i);
        X_j = X(j);
        Y_j = Y(j);
        W_X_i = W(X_i);
        W_X_j = W(X_j);
        W_Y_i = W(Y_i);
        W_Y_j = W(Y_j);
        tmp_W_X_i=reshape(W_X_i,numel(W_X_i),1);
        tmp_W_X_j=reshape(W_X_j,numel(W_X_j),1);
        tmp_W_Y_i=reshape(W_Y_i,numel(W_Y_i),1);
        tmp_W_Y_j=reshape(W_Y_j,numel(W_Y_j),1);
        Sigma_W_X_i = tmp_W_X_i*tmp_W_X_i';
        Sigma_W_X_j = tmp_W_X_j*tmp_W_X_j';
        Sigma_W_Y_i = tmp_W_Y_i*tmp_W_Y_i';
        Sigma_W_Y_j = tmp_W_Y_j*tmp_W_Y_j';
%         sum1 = sum1+K((X_i-X_j)/h)*(W(X_i)+W(X_j))+ K((Y_i-Y_j)/h)*(W(Y_i)+W(Y_j)) -K((X_i-Y_j)/h)*(W(X_i)+W(Y_j))-K((X_j-Y_i)/h)*(W(Y_i)+W(X_j));
        sum1 = sum1+K((X_i-X_j)/h)*(W_X_i+W_X_j)+ K((Y_i-Y_j)/h)*(W_Y_i+W_Y_j) -K((X_i-Y_j)/h)*(W_X_i+W_Y_j)-K((X_j-Y_i)/h)*(W_Y_i+W_X_j);

        %        sum = sum+K((X_i-X_j)/h)*(2)+ K((Y_i-Y_j)/h)*(2) -K((X_i-Y_j)/h)*(2)-K((X_j-Y_i)/h)*(2);
%         sum2 = sum2+K((X_i-X_j)/h)*(G(X_i)+G(X_j))+ K((Y_i-Y_j)/h)*(G(Y_i)+G(Y_j)) -K((X_i-Y_j)/h)*(G(X_i)+G(Y_j))-K((X_j-Y_i)/h)*(G(Y_i)+G(X_j));
 
%         var1 = var1 + K((X_i-X_j)/h)*(W(X_i)^2+W(X_j)^2)+ K((Y_i-Y_j)/h)*(W(Y_i)^2+W(Y_j)^2) + K((X_i-Y_j)/h)*(W(X_i)^2+W(Y_j)^2) + K((X_j-Y_i)/h)*(W(Y_i)^2+W(X_j)^2);
      var1 = var1 + K((X_i-X_j)/h)*(Sigma_W_X_i+Sigma_W_X_j)+ K((Y_i-Y_j)/h)*(Sigma_W_Y_i+Sigma_W_Y_j) + K((X_i-Y_j)/h)*(Sigma_W_X_i+Sigma_W_Y_j) + K((X_j-Y_i)/h)*(Sigma_W_Y_i+Sigma_W_X_j);
        %var = var + K((X_i-X_j)/h)*(2)+ K((Y_i-Y_j)/h)*(2) + K((X_i-Y_j)/h)*(2) + K((X_j-Y_i)/h)*(2);
%        var2 = var2 + K((X_i-X_j)/h)*(G(X_i)^2+G(X_j)^2)+ K((Y_i-Y_j)/h)*(G(Y_i)^2+G(Y_j)^2) + K((X_i-Y_j)/h)*(G(X_i)^2+G(Y_j)^2) + K((X_j-Y_i)/h)*(G(Y_i)^2+G(X_j)^2);
%        cov12 = cov12 + K((X_i-X_j)/h)*(H(X_i)+H(X_j))+ K((Y_i-Y_j)/h)*(H(Y_i)+H(Y_j)) + K((X_i-Y_j)/h)*(H(X_i)+H(Y_j)) + K((X_j-Y_i)/h)*(H(Y_i)+H(X_j));
    end
end
% T_n = (sum1+sum2)/(num*(num-1)*h);
% var3 =  2*(var1+var2+2*cov12)/(num*(num-1)*h)*1/(2*pi^0.5);
% baba(k) = (num-1)*h^0.5*T_n/var3^0.5;
T_n2 = sum1/(num*(num-1)*h);
var1 =  2*var1/(num*(num-1)*h)*1/(2*pi^0.5);
vec_T_n2=reshape(T_n2,numel(T_n2),1);
[U,S,V] = svd(var1);
vec_var1=U*S.^(0.5)*V;
baba(k) = max((num-1)*h^0.5*inv(vec_var1)*vec_T_n2);
nonweight_baba(k) = nonWeight(X,Y,h);
%baba(k) = sum/(num*(num-1)*h^2);
%k=k+1;
end
toc
dim = length(mu)*length(lambda);
mu=zeros(dim,1);
sigma = eye(dim);

num = 30000;
t_baba = zeros(num,1);

for i=1:num 
    X=mvnrnd(mu,sigma);
    t_baba(i)=max(X);
end
p=[0.025,0.975];
q=quantile(t_baba,p);

result=mean(baba<q(2)&baba>q(1));
result_nonweight=mean(abs(nonweight_baba)<1.96);
%baba(k) = (num-1)*h*T_n;
%baba(k) = sum/(num*(num-1)*h^2);
%k=k+1;
%end

%% Plot 

%hist(baba)

%time =1:12;
%plot(time,baba);

    
