function DistCluster = calCtrsDistance( ctrs )

% 2017年6月17日 
% 该函数用于 计算类中心的距离矩阵
% 输入：
% sup_cluster_label, ctrs：两个图的超像素与聚类的对应关系 spnum×1  和  类中心位置 spnum×3
% 输出：
% DistCluster：输出spnum*spnum大小的标号矩阵，存储类间距离矩阵

bin_num = size(ctrs,1);
DistCluster = zeros(bin_num,bin_num);
for ii = 1:bin_num
    for jj = 1:bin_num
        if ii~=jj
            DistCluster(ii,jj) = DistanceZL(ctrs(ii,:), ctrs(jj,:), 'euclid');
        else
            DistCluster(ii,jj) = 0;
        end
    end
end

end