clear
close all
trainsize = 100;
optimizatin_iter = 5;
testsize = 200;
totalsize = trainsize+testsize;
iter=500;
mode_X = 't';
mode_Y = 't';
X_nu = 2;
X_lambda = 1;
Y_nu = 5;
Y_lambda = 1;
alpha = 0.05;

% mode_X = 'mixture';
% mode_Y = 'mixture';
% X_mu = [0;0];
% X_lambda = cat(3,1,1);
% Y_mu = [0;2];
% Y_lambda = cat(3,1,0.1);
% ratio={[9,1]};

params.sig = 1;
params.numNullSamp = trainsize;
testStat = zeros(1,iter);
thresh = zeros(1,iter);
tic
for i=1:iter
    X = GenData(totalsize,1,mode_X,X_nu,X_lambda);
    Y = GenData(totalsize,1,mode_Y,Y_nu,Y_lambda);
%     X = GenData(totalsize,1,mode_X,X_mu,X_lambda,ratio);
%     Y = GenData(totalsize,1,mode_Y,Y_mu,Y_lambda,ratio);
    [testStat(i), thresh(i)]=mmdTestPears(X,Y,alpha,params); 
end
toc
out=mean(abs(testStat)<thresh);
fprintf('MMD: %f\n',out) 