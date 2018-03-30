clear
close all
% trainsize = [100:200:700];
trainsize = 100;
optimizatin_iter = 5;
testsize = 200;
num=trainsize+testsize;
bw = -0.5;
t_bw = -0.35;
train_h = trainsize.^(bw); %bandwidth
test_h = testsize.^(bw); %bandwidth
full_h = num.^(t_bw);
iter=500;
evaluation_iter=1;
test_baba = zeros(1,iter);
test_baba_opt = zeros(1,iter);
test_opt_param= zeros(iter,2);
eps = 1e-10;
mode_X = 'mvnorm';
mode_Y = 'mvnorm';
X_mu = 0;
X_lambda = 1;
% Y_mu = [0:0.1:0.3 0.4:0.05:0.6 0.65:0.005:0.7 0.8 0.9 1];
Y_mu = 0.3;
Y_lambda = 1;
options = optimoptions('ga','UseParallel',true);
lb=[-5,0.1];
ub=[5,Inf];
Pn=trainsize^(-1/2);
N=trainsize^(3/4);
tic
parfor i=1:iter
        train_X = GenData(trainsize,1,mode_X,X_mu,X_lambda);
        train_Y = GenData(trainsize,1,mode_Y,Y_mu,Y_lambda);
        opt_param = zeros(optimizatin_iter+1,2);
        opt_fval = zeros(1,optimizatin_iter+1);
        f = @(param) -SIT_T(param)-exp(param(2))/(1+exp(param(2)))*Pn*N;
    for k = 1:optimization_iter
        fprintf('Optimization Iteration: %d\n',k);
      %% Optimization
        opt_fval(k)=Inf;
        while(opt_fval(k)==Inf)
            lb=[-5,0.3];
            ub=[5,Inf];
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
    test_X = GenData(testsize,1,mode_X,X_mu,X_lambda);
    test_Y = GenData(testsize,1,mode_Y,Y_mu,Y_lambda);
    % Nonweight Test result
    test_baba(i) = nonWeight([train_X;test_X],[train_Y;test_Y],full_h);
    % SIT Test result
    test_baba_opt(i) = SIT([train_X;test_X],[train_Y;test_Y],full_h,real_opt_param);
    test_opt_param(i,:) = real_opt_param;
end
eval_pvalue=mean(abs(test_baba)<1.96);
eval_pvalue_opt=mean(abs(test_baba_opt)<1.96);
fprintf('Nonweighted: %f\n',eval_pvalue) 
fprintf('Weighted: %f\n',eval_pvalue_opt)
toc