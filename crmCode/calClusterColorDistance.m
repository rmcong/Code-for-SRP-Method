function DistColorCluster = calClusterColorDistance( clusterColor )

% 2017年6月17日 
% 该函数用于 计算类间颜色距离矩阵
% 输入：
% clusterColor：类的平均颜色矩阵  类别数K×3 
% 输出：
% DistColorCluster：输出K×K大小的矩阵，存储类间颜色距离

bin_num = size(clusterColor,1);
DistColorCluster = zeros(bin_num,bin_num);
for ii = 1:bin_num
    for jj = 1:bin_num
        if ii~=jj
            DistColorCluster(ii,jj) = DistanceZL(clusterColor(ii,:), clusterColor(jj,:), 'euclid');
        else
            DistColorCluster(ii,jj) = 0;
        end
    end
end
DistColorCluster = norm_minmax(DistColorCluster);
end
