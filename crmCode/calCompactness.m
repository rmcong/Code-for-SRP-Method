function [ compactSal ] = calCompactness( P, sim, spnum, num_vals, x_vals, y_vals )
% 利用DCLC方法计算紧致性显著性 2017/03/29

Sal = P*sim;%扩散处理后的节点的相似矩阵
Sal = Sal';

salSup = Sal.*(ones(spnum,1)*num_vals');%每个超像素与其他超像素的相似性乘以其包含的像素个数 spnum×spnum
Isum = sum(salSup,2);% 每个超像素与其他所有超像素的（相似值*像素个数）的和  公式13-15的分母
x_valMat = ones(spnum,1)*x_vals'; 
y_valMat = ones(spnum,1)*y_vals';
x0 = (sum(salSup.*x_valMat,2)./Isum)*ones(1,spnum);%原文公式14
y0 = (sum(salSup.*y_valMat,2)./Isum)*ones(1,spnum);%原文公式15
coherence = sum(salSup.*sqrt((x_valMat-x0).^2 + (y_valMat - y0).^2),2)./Isum;%原文公式13 spatial variance

comSal = coherence';
comSal(comSal > mean(comSal)) = mean(comSal);
comSal = 1 - norm_minmax(comSal);
compactSal = comSal';
end

