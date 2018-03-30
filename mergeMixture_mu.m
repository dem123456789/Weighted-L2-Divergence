n=8;
tmp_baba=cell(1,n);
tmp_baba_opt=cell(1,n);
tmp_param_opt = cell(1,n);
tmp_Y_mu = zeros(2,n);
for i=1:n
    load(sprintf('./Mixture/mu0%d_var10_1_abs.mat',i));
    tmp_baba{i}=test_baba{1};
    tmp_baba_opt{i}=test_baba_opt{1};
    tmp_param_opt{i}=test_opt_param{1};
    tmp_Y_mu(:,i)=Y_mu;
end
test_baba=tmp_baba;
test_baba_opt=tmp_baba_opt;
test_opt_param=tmp_param_opt;
Y_mu = tmp_Y_mu;