close all;
clear;




mu=zeros(4,1);
sigma = eye(4);

num = 30000;
baba = zeros(num,1);

for i=1:num 
    X=mvnrnd(mu,sigma);
    baba(i)=max(X);
end
p=[0.025,0.975];
quantile(baba,p)