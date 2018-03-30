load('./Mixture/muchangevar11.mat')
%Y_mu = Y_nu;
Y_mu=Y_mu(2,:);
eval_pvalue = zeros(1,length(Y_mu));
eval_pvalue_opt = zeros(1,length(Y_mu));
eval_pvalue_std = zeros(1,length(Y_mu));
eval_pvalue_std_opt = zeros(1,length(Y_mu));
eval_mu =zeros(1,length(Y_mu));
eval_lambda =zeros(1,length(Y_mu));
eval_mu_std =zeros(1,length(Y_mu));
eval_lambda_std =zeros(1,length(Y_mu));
thresh = 1.96;
n=length(test_baba);
for i=1:n
    eval_pvalue(i)=mean(abs(test_baba{i})<thresh);
    eval_pvalue_opt(i)=mean(abs(test_baba_opt{i})<thresh);
    eval_pvalue_std(i)=std(abs(test_baba{i})<thresh)/sqrt(length(test_baba{i}));
    eval_pvalue_std_opt(i)=std(abs(test_baba_opt{i})<1.96)/sqrt(length(test_baba_opt{i}));
    tmp_param = test_opt_param{i};
    tmp_mu = abs(tmp_param(:,1));
    tmp_lambda = abs(tmp_param(:,2));
    mask = tmp_mu~=0&tmp_mu<9.9&tmp_lambda~=1e10;
    tmp_mu = tmp_mu(mask);
    tmp_lambda = tmp_lambda(mask);
    eval_mu(i)=mean(tmp_mu);
    eval_mu_std(i)=std(tmp_mu)/sqrt(length(test_baba{i}));
    eval_lambda(i)=mean(tmp_lambda);
    eval_lambda_std(i)=std(tmp_lambda)/sqrt(length(test_baba{i}));
end


fontsize = 16;
set(0,'defaultfigurecolor',[1 1 1])
figure('position', [500, 200, 900, 750])
hold on
grid on
UW=shadedErrorBar(Y_mu,1-eval_pvalue,eval_pvalue_std,{'-r','LineWidth',1.5});
W=shadedErrorBar(Y_mu,1-eval_pvalue_opt,eval_pvalue_std_opt,{'-b','LineWidth',1.5});
L1=legend([UW.mainLine,W.mainLine],'unweighted','weighted');
set(L1,'FontSize',fontsize); 
xlabel('Y_2 Mean','FontSize', fontsize)
ylabel('Power','FontSize', fontsize)
ylim([0,1])
xlim([Y_mu(1),Y_mu(end)])