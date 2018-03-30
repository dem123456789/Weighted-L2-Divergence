n=1;
m=5;
iter =20;
for i=1:n
    matname =sprintf('./result/%d.mat',i);
    load(matname);
    for j=1:m
        a=out{j,2};
        tmp=a{1};
        
    end
end