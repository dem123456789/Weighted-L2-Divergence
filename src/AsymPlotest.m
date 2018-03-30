clear;
close all;
lb=[-5,1];
ub=[5,10];
zlimit = [0,10];
% step=[0.1,0.05];
step=[0.5,0.5];
bw=-0.35;
X_mu=0;
Y_mu=0.3;
X_lambda=1;
Y_lambda=1;
mode_X = 'mvnorm';
mode_Y = 'mvnorm';
x = lb(1):step(1):ub(1);

size = linspace(100,10000,100);
% size = [100 200];
h=size.^(bw);


tic
parfor i=1:length(size)
    fprintf('Current sample size: %d\n',size(i));
    dataX = GenData(size(i),1,mode_X,X_mu,X_lambda);
    dataY = GenData(size(i),1,mode_Y,Y_mu,Y_lambda);
    [X{i},Y{i},F{i},default{i}]=MESH(@TT,lb,ub,step,dataX,dataY,h(i));
end
toc

K(length(size))= struct('cdata',[],'colormap',[]);
fig1 = figure('position',[500 300 850 600]);
% fig2 = figure('position',[500 300 850 600]);
% fig3 = figure('position',[500 300 850 600]);
for i=1:length(size)
    surf(X{i},Y{i},F{i},'EdgeColor','none');
    zlim(zlimit)
    xlabel('mu')
    ylabel('lambda')
    title(sprintf('sample size: %d',size(i)))
    K(i) = getframe(fig1);
end
close all
fig = figure('position',[500 300 850 600]);
movie(fig,K,1,2)


%     contour(X,Y,F)
%     xlabel('mu')
%     ylabel('lambda')
% 

%     plot(x,default)
%     xlabel('mu')
%     ylabel('lambda')
