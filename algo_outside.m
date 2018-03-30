function [test_baba,test_baba_opt,test_opt_param]=algo_outside(trainsize,testsize,bw,t_bw,mode_X,mode_Y,X_mu,X_lambda,Y_mu,Y_lambda,varargin)
optimizatin_iter = 5;
num=trainsize+testsize;
train_h = trainsize.^(bw); %bandwidth
full_h = num.^(t_bw);
iter=500;
test_baba = zeros(1,iter);
test_baba_opt = zeros(1,iter);
test_opt_param= zeros(iter,2);
% mode_X = 'mvnorm';
% mode_Y = 'mvnorm';
% X_mu = 0;
% X_lambda = 1;
% Y_mu = 0.05:0.05:0.75;
% % Y_mu = 0.3;
% Y_lambda = 1;
options = optimoptions('ga','UseParallel',true);
lb=[-10,0.3];
ub=[10,Inf];

if(length(varargin)>=1)
    train_X = GenData(trainsize,1,mode_X,X_mu,X_lambda,varargin);
    train_Y = GenData(trainsize,1,mode_Y,Y_mu,Y_lambda,varargin);
else
    train_X = GenData(trainsize,1,mode_X,X_mu,X_lambda);
    train_Y = GenData(trainsize,1,mode_Y,Y_mu,Y_lambda);
end
opt_param = zeros(optimizatin_iter+1,2);
opt_fval = zeros(1,optimizatin_iter+1);
f = @(param) -abs(SIT(train_X,train_Y,train_h,param));
for k = 1:optimizatin_iter
  %% Optimization
    opt_fval(k)=-Inf;
    while(opt_fval(k)==-Inf)
        [opt_param(k,:),opt_fval(k)]=ga(f,2,[],[],[],[],lb,ub,[],options);
            tmp = opt_param(k,:);
            fprintf('Optimal parameter: %f,%f. Optimal value: %f\n',tmp(1),tmp(2),opt_fval(k));
    end      
end
opt_param(end,:)=[0,1e10];
opt_fval(end)=-SIT(train_X,train_Y,train_h,opt_param(end,:));
fprintf('default parameter: %f,%f. default value: %f\n',0,1e10,opt_fval(end));
[real_opt_fval,real_opt_fval_idx]=max(abs(opt_fval));
real_opt_param=opt_param(real_opt_fval_idx,:);
fprintf('Final Optimal parameter: %f,%f. Optimal value: %f\n',real_opt_param(1),real_opt_param(2),real_opt_fval);
parfor i=1:iter
    fprintf('Iteration: %d\n',i);
%     test_X = GenData(testsize,1,mode_X,X_mu,X_lambda);
%     test_Y = GenData(testsize,1,mode_Y,Y_mu,Y_lambda);
    if(length(varargin)>=1)
        test_X = GenData(testsize,1,mode_X,X_mu,X_lambda,varargin);
        test_Y = GenData(testsize,1,mode_Y,Y_mu,Y_lambda,varargin);
    else
        test_X = GenData(testsize,1,mode_X,X_mu,X_lambda);
        test_Y = GenData(testsize,1,mode_Y,Y_mu,Y_lambda);
    end
    % Nonweight Test result
    test_baba(i) = nonWeight([train_X;test_X],[train_Y;test_Y],full_h);
    % SIT Test result
    test_baba_opt(i) = SIT([train_X;test_X],[train_Y;test_Y],full_h,real_opt_param);
    test_opt_param(i,:) = real_opt_param;
end
end