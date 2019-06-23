function [ BGindex_unique, FGindex_unique ] = UniquenessSeeds2( frame_sup, clusternum, compactness )
% 2017年6月24日 第1次修改 该函数用于 对候选背景种子点进行再筛选
% 输入：
% frame_sup：读入的原始数据
% clusternum：聚类数目 
% compactness：紧致显著性结果
% 输出：
% BGindex_unique, FGindex_unique：最终选择出的独特性背景种子点和前景种子点

% k-means聚类
[centers, assignments] = vl_kmeans(frame_sup.rgb', clusternum, 'Initialization', 'plusplus') ;
sup_cluster_label = double(assignments)';% spnum*1
ctrs = centers';
% 引入显著性因子修正类中心距离
sal_cluster =  zeros(clusternum,1);
for ii = 1:clusternum
    index = find(sup_cluster_label == ii);
    sal_cluster(ii,1) = mean(compactness(index));
end
salinfactor = exp(abs(repmat(sal_cluster,1,clusternum)-repmat(sal_cluster',clusternum,1)));
% Method 1
DistCluster = calCtrsDistance( ctrs ).*salinfactor; % distance among different clusers
[indx indy] = find(DistCluster == max(max(DistCluster)));
indA_unique = indx(1,1);
indB_unique = indy(1,1);
clusterA = find(sup_cluster_label == indA_unique);
clusterB = find(sup_cluster_label == indB_unique);
salA = mean(compactness(clusterA));
salB = mean(compactness(clusterB));
if salA > salB
    BGindex_unique = clusterB;
    FGindex_unique = clusterA;
else
    BGindex_unique = clusterA;
    FGindex_unique = clusterB;
end

end

