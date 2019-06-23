function [ GC, BGindex_MU ] = MotionUniqueSeeds( frame_sup, MOF_sup, nLabel, bg_num )
% 2017年6月24日 第1次修改 该函数用于 对候选背景种子点进行再筛选
% 输入：
% frame_sup：读入的原始数据
% MOF_sup：光流幅度数据
% nLabel：double型超像素个数
% 输出：
% BGindex_compact, FGindex_unique：最终选择出的独特性背景种子点
% compactness：紧致显著性结果
GC = GlobalContrast( MOF_sup, frame_sup, nLabel );% spnum×1
[~,ind_GC] = sort( GC );
BGindex_MU = ind_GC(1:bg_num);
end

