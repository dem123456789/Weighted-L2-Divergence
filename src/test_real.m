clear
close all
filename='./data/precious_metal.csv';
fid = fopen(filename);
data = textscan(fid,'%s%f%f%f%f','delimiter',',');
fclose(fid);

Z = @(Y)( - log(Y(2:end,:) ./ Y(1:end-1,:)) * 100);
gold = data{2};
silver = data{3};
plantinum = data{4};
palladium = data{5};

log_gold = Z(gold);
log_silver = Z(silver);
log_plantinum = Z(plantinum);
log_palladium = Z(palladium);
%% Data Split
X=log_silver;
Y=log_gold;
n=100;
p=1/3;
%% Test
optimizatin_iter = 1;
bw = -0.5;
t_bw = -0.4;
totalsize = length(X);
trainsize = floor(totalsize*p);
train_h = trainsize.^(bw);
full_h = totalsize.^(t_bw);
iter=2;
options = optimoptions('ga','UseParallel',true);
lb=[-Inf,0.3];
ub=[Inf,Inf];
test_baba = zeros(1,iter);
test_baba_opt = zeros(1,iter);
test_opt_param= zeros(iter,2);
for i=1:iter
    fprintf('Iteration: %d\n',i);
    [train_X, test_X]=samplesplit(X,n,p);
    [train_Y, test_Y]=samplesplit(Y,n,p);
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
    test_baba(i) = nonWeight([train_X;test_X],[train_Y;test_Y],full_h);
    test_baba_opt(i) = SIT([train_X;test_X],[train_Y;test_Y],full_h,real_opt_param);
    test_opt_param(i,:) = real_opt_param;
end
%% gold and silver 
% figure
% hist(log_gold)
% figure
% hist(log_silver)
% figure
% hist(log_plantinum)
% figure
% hist(log_palladium)
% figure
% hold on
% plot(log_gold);
% plot(log_silver);
% plot(log_plantinum);
% plot(log_palladium);
