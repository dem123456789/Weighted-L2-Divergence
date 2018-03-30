        %% plot p value to see if it is uniform

A=P_Val(test_baba_opt);
cdfplot(A);
hold on;
X=[0:0.01:1];
Y=X;
plot(X,Y);