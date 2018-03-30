function p_value = P_Val(X)

dim = length(X);

p_value = zeros(1,dim);

for i=1:dim
    p_value(i)=2* (1-normcdf(abs(X(i))));
end


    