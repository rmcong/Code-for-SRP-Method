function [ sim,W ] = Graph( rgb_vals, adjc, of_sup )
% 构建图模型 2017.03.19
% compute the feature (mean color in lab color space) for each superpixels
theta = 10;% 原文中(1/sigma^2)=10,sigma^2=0.1
seg_vals = colorspace('Lab<-', rgb_vals);%转换到Lab空间 spnumn*3
% Graph Construction
W_lab =  DistanceZL(seg_vals, seg_vals, 'euclid'); % euclid 公式9
W_of =  DistanceZL(of_sup, of_sup, 'euclid'); % euclid 公式9
sim = exp(-theta * norm_minmax(W_lab + W_of));%原文中公式11 描述节点之间的相似性矩阵  spnum×spnum 主对角线元素为1
W = sim.*adjc;% spnum×spnum的affinity矩阵  原文公式10
end

