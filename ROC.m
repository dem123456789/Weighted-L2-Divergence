clear
close all
ifsplit=true;
type1_unweighted_baba=zeros(1,500);
type1_weighted_baba=zeros(1,500);
testsize = 200;
bound = 'lb0_3';
bandwidth='bw0_4';
if(ifsplit)
    for l=1:5
        load(sprintf('./%s/%s/type1/100%d_%d.mat',bound,bandwidth,testsize,l))
        type1_unweighted_baba((l-1)*100+1:l*100) = test_baba;
        type1_weighted_baba((l-1)*100+1:l*100) = test_baba_opt;
    end
else
    load(sprintf('./%s/%s/type1/100%d.mat',bound,bandwidth,testsize))
    type1_unweighted_baba = test_baba;
    type1_weighted_baba = test_baba_opt;
end
test_baba_H0 = type1_unweighted_baba;
test_baba_opt_H0 = type1_weighted_baba;
load('./Mixture/mu05_var11.mat')
test_baba_H1 = test_baba{1};
test_baba_opt_H1 = test_baba_opt{1};
thresh = 0:0.1:10;

unweighted_H0=zeros(1,length(thresh));
weighted_H0=zeros(1,length(thresh));
unweighted_H1=zeros(1,length(thresh));
weighted_H1=zeros(1,length(thresh));
for i=1:length(thresh)
    unweighted_H0(i)=mean(abs(test_baba_H0)<thresh(i));
    weighted_H0(i)=mean(abs(test_baba_opt_H0)<thresh(i));
    unweighted_H1(i)=mean(abs(test_baba_H1)<thresh(i));
    weighted_H1(i)=mean(abs(test_baba_opt_H1)<thresh(i));
end




line_width = 4;
set(0,'defaultfigurecolor',[1 1 1])
unweighted_A=P_Val(type1_unweighted_baba);
weighted_A=P_Val(type1_weighted_baba);
figure('position', [500, 200, 900, 750])
hold on;
h1=cdfplot(unweighted_A);
h2=cdfplot(weighted_A);
set(h1,'LineWidth',line_width)
set(h2,'LineWidth',line_width)
X=[0:0.01:1];
plot(X,X,'LineWidth',line_width-2);
legend('unweighted','weighted')

fontsize = 16;
figure('position', [500, 200, 900, 750])
set(0,'defaultfigurecolor',[1 1 1])
hold on
grid on
scatter(1-unweighted_H0,unweighted_H1,25,'filled');
scatter(1-weighted_H0,weighted_H1,25,'filled');
xlabel('False Alarm rate','FontSize', fontsize)
ylabel('Miss detection rate','FontSize', fontsize)
L1=legend('unweighted','weighted');
set(L1,'FontSize',fontsize);
