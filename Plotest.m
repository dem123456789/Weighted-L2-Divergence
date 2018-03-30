clear;
close all;
lb=[-10,0.3];
ub=[10,3];
% lb=[-10,0.3];
% ub=[10,3];
step=[0.1,0.05];
k = 100;
h=k^(-0.4);
% X_mu=0;
% Y_mu=0.3;
% X_lambda=1;
% Y_lambda=1;
X_mu = [0;0];
X_lambda = cat(3,1,1);
Y_mu = [0;7];
Y_lambda = cat(3,1,0.1);
% mode_X = 'mvnorm';
% mode_Y = 'mvnorm';
mode_X = 'mixture';
mode_Y = 'mixture';
ratio={[9,1]};
% dataX= GenData(k,1,mode_X,X_mu,X_lambda);
% dataY= GenData(k,1,mode_Y,Y_mu,Y_lambda);
dataX= GenData(k,1,mode_X,X_mu,X_lambda,ratio);
dataY= GenData(k,1,mode_Y,Y_mu,Y_lambda,ratio);
x = lb(1):step(1):ub(1);
tic
[X,Y,F,default]=MESH(@TT,lb,ub,step,dataX,dataY,h);
toc
[max_f,ind] = max(abs(F(:)));
[y_idx,x_idx] = ind2sub(size(F),ind);
max_x = X(1,x_idx);
max_y= Y(y_idx,1);
fprintf('Optimal parameter: %f,%f. Optimal value: %f\n',max_x,max_y,max_f);

line_width = 4;
set(0,'defaultfigurecolor',[1 1 1])
figure('position', [500, 200, 900, 750])
hist(dataX)
xlabel('X')
xlim([-10,10])
figure('position', [500, 200, 900, 750])
hist(dataY)
xlim([-10,10])
xlabel('Y')
figure('position', [500, 200, 900, 750])
surf(X,Y,F,'EdgeColor','none');
xlabel('\alpha')
ylabel('$$\lambda^{(-1)}$$','Interpreter','latex')
zlabel('Estimate')
figure('position', [500, 200, 900, 750])
contour(X,Y,F,'LineWidth',line_width)
xlabel('\alpha')
ylabel('$$\lambda^{(-1)}$$','Interpreter','latex')
zlabel('Estimate')
figure('position', [500, 200, 900, 750])
plot(x,default,'LineWidth',line_width)
xlabel('\alpha')
ylabel('Estimate')