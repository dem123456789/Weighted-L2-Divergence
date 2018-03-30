clear
close all
load('./lb0_3/muchangeH0.mat')
test_baba_H0 = test_baba;
test_baba_opt_H0 = test_baba_opt;
load('./Mixture/muchangevar11.mat')
test_baba_H1 = test_baba;
test_baba_opt_H1 = test_baba_opt;
thresh = 0:0.1:10;
unweighted_H0=zeros(length(test_baba),length(thresh));
weighted_H0=zeros(length(test_baba),length(thresh));
unweighted_H1=zeros(length(test_baba),length(thresh));
weighted_H1=zeros(length(test_baba),length(thresh));
indices = 7;%mixturevar11 mu=6, mixturevar10_1 mu=3, normal mu=6(0.3)
fontsize = 16;
figure('position', [500, 200, 900, 750])
hold on
grid on
xlabel('False Alarm rate','FontSize', fontsize)
ylabel('Miss detection rate','FontSize', fontsize)
for i=indices
    c_test_baba = test_baba{i};
    c_test_baba_opt = test_baba_opt{i};
    for j=1:length(thresh)
        unweighted_H0(i,j)=mean(abs(test_baba_H0)<thresh(j));
        weighted_H0(i,j)=mean(abs(test_baba_opt_H0)<thresh(j));
        unweighted_H1(i,j)=mean(abs(test_baba_H1{i})<thresh(j));
        weighted_H1(i,j)=mean(abs(test_baba_opt_H1{i})<thresh(j));
    end
%     scatter(1-unweighted_H0(i,:),unweighted_H1(i,:),25,'filled');
%     scatter(1-weighted_H0(i,:),weighted_H1(i,:),25,'filled');
    f1=plot(1-unweighted_H0(i,:),unweighted_H1(i,:),'LineWidth',1.5);
    f2=plot(1-weighted_H0(i,:),weighted_H1(i,:),'LineWidth',1.5);
end
L1=legend('unweighted','weighted');
set(L1,'FontSize',fontsize);
