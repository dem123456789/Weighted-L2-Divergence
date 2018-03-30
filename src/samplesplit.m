function [train_data, test_data] = samplesplit(data,n,p)
totalsize = n;
trainsize = floor(totalsize*p);
rng('shuffle')
[total_data,~] = datasample(data,totalsize,'Replace',false);
train_data=total_data(1:trainsize);
test_data = total_data(trainsize+1:end);
end