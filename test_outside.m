clear
close all
% trainsize = [100:200:700];
trainsize = 100;
optimizatin_iter = 5;
testsize = 200;
num=trainsize+testsize;
bw = -0.8;
t_bw = -0.2;
train_h = trainsize.^(bw); %bandwidth
full_h = num.^(t_bw);
iter=500;
evaluation_iter=1;
opt_param = zeros(optimizatin_iter+1,2);
opt_fval = zeros(1,optimizatin_iter+1);
train_baba = zeros(1,optimizatin_iter);
validate_baba = zeros(1,optimizatin_iter);
test_baba = zeros(1,iter);
test_baba_opt = zeros(1,iter);
test_opt_param= zeros(iter,2);
step_mu = 0.125;
step_lambda = 0.075;
eps = 1e-10;
mode_X = 'mvnorm';
mode_Y = 'mvnorm';
X_mu = 0;
X_lambda = 1;
% Y_mu = [0:0.1:0.3 0.4:0.05:0.6 0.65:0.005:0.7 0.8 0.9 1];
Y_mu = 0.3;
total_iter = length(Y_mu);
Y_lambda = 1*ones(1,total_iter);
pvalue=zeros(1,total_iter);
pvalue_opt=zeros(1,total_iter);
total_opt_param = cell(1,total_iter);
total_baba = cell(1,total_iter);
total_baba_opt = cell(1,total_iter);
eval_m_pvalue = zeros(1,total_iter);
eval_err_pvalue = zeros(1,total_iter);
eval_m_pvalue_opt = zeros(1,total_iter);
eval_err_pvalue_opt = zeros(1,total_iter);
eval_opt_param = cell(1,evaluation_iter);
eval_baba = cell(1,evaluation_iter);
eval_baba_opt = cell(1,evaluation_iter);
eval_pvalue= zeros(1,evaluation_iter);
eval_pvalue_opt=zeros(1,evaluation_iter);
options =  optimoptions('ga','FunctionTolerance',1e-6);
lb=[-5,0.3];
ub=[5,Inf];
for n = 1:total_iter
    tic
    for t = 1:evaluation_iter
        fprintf('Current Iteration: %d\n',t);
                    train_X = GenData(trainsize,1,mode_X,X_mu,X_lambda);
                    train_Y = GenData(trainsize,1,mode_Y,Y_mu(n),Y_lambda(n));
                    f = @(param) -SIT(train_X,train_Y,train_h,param);
                for k = 1:optimizatin_iter
                    fprintf('Optimization Iteration: %d\n',k);
                  %% Optimization
                    opt_fval(k)=-Inf;
                    while(opt_fval(k)==-Inf)
                        [opt_param(k,:),opt_fval(k)]=ga(f,2,[],[],[],[],lb,ub,[],options);
%                         [opt_param(k,:),opt_fval(k)]=simulannealbnd(f,[0,1],lb,ub);
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
            %% Evaluation
            disp('Evaluation start')
            for i=1:iter
                test_X = GenData(testsize,1,mode_X,X_mu,X_lambda);
                test_Y = GenData(testsize,1,mode_Y,Y_mu(n),Y_lambda(n));
                % Nonweight Test result
                test_baba(i) = nonWeight([train_X;test_X],[train_Y;test_Y],full_h);
                % SIT Test result
                test_baba_opt(i) = SIT([train_X;test_X],[train_Y;test_Y],full_h,real_opt_param);
                test_opt_param(i,:) = real_opt_param;
            end
        eval_opt_param{t} = test_opt_param;
        eval_baba{t} = test_baba;
        eval_baba_opt{t} = test_baba_opt;
        eval_pvalue(t)=(mean(abs(test_baba)<1.96,2));
        eval_pvalue_opt(t)=(mean(abs(test_baba_opt)<1.96,2));
    end
    total_opt_param{n} = eval_opt_param;
    total_baba{n} = eval_baba;
    total_baba_opt{n} = eval_baba_opt;
    eval_m_pvalue(n) = mean(eval_pvalue);
    eval_err_pvalue(n) = std(eval_pvalue)/evaluation_iter;
    eval_m_pvalue_opt(n) = mean(eval_pvalue_opt);
    eval_err_pvalue_opt(n) = std(eval_pvalue_opt)/evaluation_iter;
    fprintf('Nonweighted: %f\n',eval_m_pvalue(n)) 
    fprintf('Weighted: %f\n',eval_m_pvalue_opt(n))
    toc
end