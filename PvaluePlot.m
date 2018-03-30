load('./lb0_3/muchangeH0.mat')
line_width = 4;
set(0,'defaultfigurecolor',[1 1 1])
unweighted_A=P_Val(test_baba);
weighted_A=P_Val(test_baba_opt);
figure('position', [500, 200, 900, 750])
hold on;
h1=cdfplot(unweighted_A);
h2=cdfplot(weighted_A);
set(h1,'LineWidth',line_width)
set(h2,'LineWidth',line_width)
X=[0:0.01:1];
plot(X,X,'LineWidth',line_width-2);
legend('unweighted','weighted')
