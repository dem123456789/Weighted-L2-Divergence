function [X,Y,F,default] = MESH(f,lb,ub,step,dataX,dataY,h)
num_param = length(lb);
num_coor_len = zeros(1,num_param);
coordinates = cell(1,num_param);
for i = 1:num_param
    coordinates{i}=lb(i):step(i):ub(i);
    num_coor_len(i) = length(coordinates{i});
end
F = zeros([num_coor_len(2) num_coor_len(1)]);
[X,Y] = meshgrid(coordinates{1},coordinates{2});
for i = 1:num_coor_len(2)
    for j = 1:num_coor_len(1)
        F(i,j)=abs(f(dataX,dataY,h,[X(i,j),Y(i,j)]));
    end
end
mu=coordinates{1};
default=zeros(1,num_coor_len(1));
for i = 1:num_coor_len(1)
    default(i) = abs(f(dataX,dataY,h,[mu(i),Inf]));
end

end