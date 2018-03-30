clear
close all
% trainsize = [100:200:700];
trainsize = 100;
optimization_iter = 5;
testsize = 200;
num=trainsize+testsize;
train_h = trainsize.^(-0.5); %bandwidth
test_h = testsize.^(-0.5); %bandwidth
full_h = num.^(-0.5);
iter=500;
evaluation_iter=1;
opt_param = zeros(optimization_iter+1,2);
opt_fval = zeros(1,optimization_iter+1);
train_baba = zeros(1,optimization_iter);
validate_baba = zeros(1,optimization_iter);
test_baba = zeros(1,iter);
test_baba_opt = zeros(1,iter);
test_opt_param= zeros(iter,2);
step_mu = 0.125;
step_lambda = 0.075;
% eps = 1e-10;
mode_X = 'mvnorm';
mode_Y = 'mvnorm';
X_mu = 0;
X_lambda = 1;
% Y_mu = [0:0.1:0.3 0.4:0.05:0.6 0.65:0.005:0.7 0.8 0.9 1];
Y_mu = 0.3;
total_iter = length(Y_mu);
Y_lambda = ones(1,total_iter);
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
eps=1e-10;
Pn=trainsize^(-1/2);
% Pn=1;
N=trainsize^(3/4);
for n = 1:total_iter
    tic
    for t = 1:evaluation_iter
        fprintf('Current Iteration: %d\n',t);
%                     rng(9);
                    train_X = GenData(trainsize,1,mode_X,X_mu,X_lambda);
%                     rng(1);
%                     train_X_o = train_X(randperm(trainsize))+randn()/0.1;
                    train_X_o =  GenData(trainsize,1,mode_X,X_mu,X_lambda);
%                     rng(4);
                    train_Y = GenData(trainsize,1,mode_Y,Y_mu(n),Y_lambda(n));
%                     rng(8);
%                     train_Y_o =train_Y(randperm(trainsize))+randn()/0.1;
                    train_Y_o = GenData(trainsize,1,mode_Y,Y_mu(n),Y_lambda(n));
                    sample_m = mean([train_X;train_Y]);
                    T = @(t) t/(1-t);
                    T2 = @(t) log((1+t)/(1-t));
                    SIT_T = @(param_T) SIT(train_X,train_Y,train_h,[param_T(1),T(param_T(2))]);
                    SIT_T2 = @(param_T) SIT(train_X,train_X_o,train_h,[param_T(1),T(param_T(2))]);
                    SIT_T3 = @(param_T) SIT(train_Y,train_Y_o,train_h,[param_T(1),T(param_T(2))]);
%                     Pn = sqrt(SIT_T2([sample_m,1-eps])*SIT_T3([sample_m,1-eps]));
                    f = @(param) -SIT_T(param);
%                     f = @(param) -SIT_T(param)+sqrt(abs(SIT_T2(param))*abs(SIT_T3(param)));
%                     f2 = @(param) -SIT_T2(param);
%                     f3 = @(param) -SIT_T3(param);
%                     f4 = @(param) -sqrt(SIT_T2(param)*SIT_T3(param));
%                     f = @(param) -SIT_T(param)-exp(T(param(2)))/(1+exp(T(param(2))))*exp(-abs(param(1)-sample_m))*Pn;
%                     f2 = @(param) -SIT_T2(param)-(1+param(2))/2*exp(-abs(param(1)-sample_m))*Pn;
                for k = 1:optimization_iter
                    fprintf('Optimization Iteration: %d\n',k);
                  %% Optimization
                    opt_fval(k)=Inf;
                    while(opt_fval(k)==Inf||isnan(opt_fval(k)))
                        lb=[-5,0];
                        ub=[5,1-eps];
                        [opt_param(k,:),opt_fval(k)]=ga(f,2,[],[],[],[],lb,ub,[],options);
%                         [opt_param2(k,:),opt_fval2(k)]=ga(f2,2,[],[],[],[],lb,ub,[],options);
%                         [opt_param3(k,:),opt_fval3(k)]=ga(f3,2,[],[],[],[],lb,ub,[],options);
%                         [opt_param4(k,:),opt_fval4(k)]=ga(f4,2,[],[],[],[],lb,ub,[],options);
%                         [opt_param(k,:),opt_fval(k)]=simulannealbnd(f,[0,1],lb,ub);
                          u(k)=sqrt(abs(SIT_T2(opt_param(k,:)))*abs(SIT_T3(opt_param(k,:))));
%                           opt_fval(k)=abs(opt_fval(k))-u(k);
                          opt_fval(k)=abs(opt_fval(k));
                          fprintf('u: %f\n',u(k));
                        tmp = opt_param(k,:);
%                         tmp2 = opt_param4(k,:);
                        fprintf('Sn1: %f\n',SIT_T(opt_param(k,:)));
%                         fprintf('u: %f\n',opt_fval4(k));
%                         fprintf('Sn2: %f\n',SIT_T2(opt_param2(k,:)));
                        fprintf('Optimal parameter: %f,%f(%f). Optimal value: %f\n',tmp(1),tmp(2),T(tmp(2)),opt_fval(k));
%                         fprintf('Optimal parameter2: %f,%f(%f). Optimal value: %f\n',tmp2(1),tmp2(2),T2(tmp2(2)),opt_fval2(k));
                    end      
                end
%                 u=max(abs(opt_fval4));
%                 fprintf('optimal u: %f\n',u);
%                 opt_fval(1:end-1)=abs(opt_fval(1:end-1))-u;
                opt_param(end,:)=[sample_m,1-eps];
                opt_fval(end)=abs(SIT(train_X,train_Y,train_h,[sample_m,T(1-eps)]));
                fprintf('default parameter: %f,%f(%f). default value: %f\n',sample_m,1-eps,T(1-eps),opt_fval(end));
                [real_opt_fval,real_opt_fval_idx]=max((opt_fval(1:end-1)));
                if(u(real_opt_fval_idx)/real_opt_fval>1/2)
                    real_opt_param=opt_param(end,:);
                else
                    real_opt_param=opt_param(real_opt_fval_idx,:);
                end
                if(real_opt_fval_idx==optimization_iter+1)
                    ifdefault =true;
                else
                    ifdefault =false;
                end
                fprintf('Final Optimal parameter: %f,%f. Optimal value: %f\n',real_opt_param(1),real_opt_param(2),real_opt_fval);
            %% Evaluation
            disp('Evaluation start')
            for i=1:iter
                test_X = GenData(testsize-trainsize,1,mode_X,X_mu,X_lambda);
                test_Y = GenData(testsize-trainsize,1,mode_Y,Y_mu(n),Y_lambda(n));
                full_X = [train_X;train_X_o;test_X];
                full_Y = [train_Y;train_Y_o;test_Y];
                % Nonweight Test result
                test_baba(i) = nonWeight(full_X,full_Y,full_h);
                % SIT Test result
%                 SIT(train_X,train_Y,train_h,[param_T(1),T(param_T(2))]);
                    p=[real_opt_param(1) T(real_opt_param(2))];
%                     full_X_o = full_X(randperm(num))+randn()/0.1;
%                     full_Y_o = full_Y(randperm(num))+randn()/0.1;
                    if(ifdefault)
                        test_baba_opt(i) = abs(SIT(full_X,full_Y,full_h,p));
                    else
                        test_baba_opt(i) = abs(SIT(full_X,full_Y,full_h,p));
                    end
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