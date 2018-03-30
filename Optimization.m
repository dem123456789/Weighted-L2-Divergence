function [opt_param,opt_fval] =Optimization(X,Y,lb,ub,iter)
size = length(X);
h = size^(-0.5);
opt_param = zeros(iter,2);
opt_fval = zeros(1,iter);
f = @(param) -SIT(X,Y,h,param);
for k = 1:iter
    opt_fval(k)=-Inf;
    while(opt_fval(k)==-Inf)
        [opt_param(k,:),opt_fval(k)]=ga(f,2,[],[],[],[],lb,ub);
%         tmp = opt_param(k,:);
%         fprintf('Optimal parameter: %f,%f. Optimal value: %f\n',tmp(1),tmp(2),opt_fval(k));
    end      
end
end