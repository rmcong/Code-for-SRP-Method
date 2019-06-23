function [ compactness, BGindex_compact ] = CompactSeeds( frame_sup, P, S, nLabel, bg_num )
% 2017年6月24日 第1次修改 该函数用于 对候选背景种子点进行再筛选
% 输入：
% frame_sup：读入的原始数据
% P：传播矩阵
% S：相似性矩阵
% nLabel：double型超像素个数
% 输出：
% BGindex_compact, FGindex_unique：最终选择出的独特性背景种子点
% compactness：紧致显著性结果
compactness = calCompactness( P, S, nLabel, frame_sup.num, frame_sup.x, frame_sup.y);% spnum×1
[~,ind_compact] = sort(compactness);
BGindex_compact = ind_compact(1:bg_num);
end

