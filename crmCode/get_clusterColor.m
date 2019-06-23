function clusterColor = get_clusterColor( color_sup, sup_cluster_label )

% 2017年6月21日 第1次修改 该函数用于 获取类的平均颜色信息
% 输入：
% color_sup, ：double spnum*3
% sup_cluster_label：每个超像素对应的类别标号 spnum×1
% 输出：
% clusterColor：输出 类别数×3大小的颜色矩阵

color_sup_norm(:,1) = norm_minmax(color_sup(:,1));
color_sup_norm(:,2) = norm_minmax(color_sup(:,2));
color_sup_norm(:,3) = norm_minmax(color_sup(:,3));
K = max(sup_cluster_label);
clusterColor = zeros(K,3);
for ii = 1:K
    index = find(sup_cluster_label == ii);
    clusterColor(ii,:) = mean(color_sup_norm(index,:));
end
end

