ifsplit=true;
type1_unweighted_baba=zeros(1,500);
type1_weighted_baba=zeros(1,500);
type1_opt_param=zeros(500,2);
type2_unweighted_baba=zeros(1,500);
type2_weighted_baba=zeros(1,500);
type2_opt_param=zeros(500,2);
testsize = 200;
bound = 'lb0_3';
bandwidth='bw0_4';
if(ifsplit)
    for l=1:5
        load(sprintf('./%s/%s/type1/100%d_%d.mat',bound,bandwidth,testsize,l))
        type1_unweighted_baba((l-1)*100+1:l*100) = test_baba;
        type1_weighted_baba((l-1)*100+1:l*100) = test_baba_opt;
        type1_opt_param((l-1)*100+1:l*100,:)=test_opt_param;
    end
    for l=1:5
        load(sprintf('./%s/%s/type2/100%d_%d.mat',bound,bandwidth,testsize,l))
        type2_unweighted_baba((l-1)*100+1:l*100) = test_baba;
        type2_weighted_baba((l-1)*100+1:l*100) = test_baba_opt;
        type2_opt_param((l-1)*100+1:l*100,:)=test_opt_param;
    end
else
    load(sprintf('./%s/%s/type1/100%d.mat',bound,bandwidth,testsize))
    type1_unweighted_baba = test_baba;
    type1_weighted_baba = test_baba_opt;
    load(sprintf('./%s/%s/type2/100%d.mat',bound,bandwidth,testsize))
    type2_unweighted_baba = test_baba;
    type2_weighted_baba = test_baba_opt;
end
% test_baba=type1_unweighted_baba;
% test_baba_opt=type1_weighted_baba;
% test_opt_param=type1_opt_param;
%% Evaluation
Nonweighted=(mean(abs(type1_unweighted_baba)<1.96));
Weighted=(mean(abs(type1_weighted_baba)<1.96));
fprintf('Nonweighted: %f\n',Nonweighted) 
fprintf('Weighted: %f\n',Weighted)


Nonweighted_2=(mean(abs(type2_unweighted_baba)<1.96));
Weighted_2=(mean(abs(type2_weighted_baba)<1.96));
fprintf('Nonweighted: %f\n',Nonweighted_2) 
fprintf('Weighted: %f\n',Weighted_2)

thresh = 0:0.1:10;

unweighted_H0=zeros(1,length(thresh));
weighted_H0=zeros(1,length(thresh));
unweighted_H1=zeros(1,length(thresh));
weighted_H1=zeros(1,length(thresh));
for i=1:length(thresh)
    unweighted_H0(i)=mean(abs(type1_unweighted_baba)<thresh(i));
    weighted_H0(i)=mean(abs(type1_weighted_baba)<thresh(i));
    unweighted_H1(i)=mean(abs(type2_unweighted_baba)<thresh(i));
    weighted_H1(i)=mean(abs(type2_weighted_baba)<thresh(i));
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

figure('position', [500, 200, 900, 750])
hold on
scatter(1-unweighted_H0,unweighted_H1,25,'filled');
scatter(1-weighted_H0,weighted_H1,25,'filled');
grid on
xlabel('False Alarm rate')
ylabel('Miss detection rate')
legend('unweighted','weighted')