% 2016年8月17日 第1次修改
% 该函数用于 两个graph的superpixel之间基于相似性的节点匹配
% 输入：
% superinfo：double spnum*3
% Bin_num：kmeans聚类个数
% 输出：
% sup_cluster_label：输出spnum×1大小的标号矩阵，找到每一个超像素节点被分到哪一类
% ctrs：Bin_num×3的矩阵，是每一类的类中心
function [sup_cluster_label,ctrs] = get_sup_cluster( superinfo, Bin_num )
% ---- clustering via Kmeans++ -------
[idx,ctrs] = kmeansPP(superinfo',Bin_num);
idx = idx';
ctrs = ctrs';
sup_cluster_label = idx;
end


