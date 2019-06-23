function [ P ] = Diffusion_Pmatrix( W, spnum )

alpha = 0.99;
dd = sum(W,2); % 超像素节点的度 degree
D = sparse(1:spnum,1:spnum,dd);%对角矩阵
P = (D-alpha*W)\eye(spnum); %eye产生单位矩阵 等价于(D-alpha*W)的逆 

end

