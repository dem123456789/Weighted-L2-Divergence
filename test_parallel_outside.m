clear
close all
% trainsize = [100:200:700];
trainsize = 100;
optimizatin_iter = 5;
testsize = 200;
bw = -0.5;
t_bw = -0.4;
iter=500;
mode_X = 'mvnorm';
mode_Y = 'mvnorm';
X_mu = 0;
X_lambda = 1;
Y_mu = 0.05:0.05:0.75;
% Y_mu = 0.3;
Y_lambda = 1;
options = optimoptions('ga','UseParallel',true);
lb=[-5,0.3];
ub=[5,Inf];
test_baba = cell(1,length(Y_mu));
test_baba_opt = cell(1,length(Y_mu));
test_opt_param= cell(1,length(Y_mu));
eval_pvalue = zeros(1,length(Y_mu));
eval_pvalue_opt = zeros(1,length(Y_mu));
tic
parfor n=1:length(Y_mu)
    fprintf('Current Y_mu: %f\n',Y_mu(n)) 
    [test_baba{n},test_baba_opt{n},test_opt_param{n}]=algo_outside(trainsize,testsize,bw,t_bw,mode_X,mode_Y,X_mu,X_lambda,Y_mu(n),Y_lambda);
    eval_pvalue(n)=mean(abs(test_baba{n})<1.96);
    eval_pvalue_opt(n)=mean(abs(test_baba_opt{n})<1.96);
    fprintf('Nonweighted: %f\n',eval_pvalue(n)) 
    fprintf('Weighted: %f\n',eval_pvalue_opt(n))
end
toc