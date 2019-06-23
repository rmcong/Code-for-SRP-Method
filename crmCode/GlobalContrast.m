function GC = GlobalContrast( MOF_sup, frame_sup, nLabel )
% 2017年6月27日 第1次修改 该函数用于 计算光流幅度的全局对比度
% 输入：
% MOF_sup：超像素级的光流幅度信息 spnum*1
% frame_sup：超像素级的原始视频数据 
% nLabel：double型超像素个数
% 输出：
% GC：计算全局对比信息 spnum*1

location = [norm_minmax(frame_sup.x) norm_minmax(frame_sup.y)];% spnum*2
dist_loc = DistanceZL(location, location, 'euclid'); % spnum×spnum
dist = exp(-dist_loc/0.4);
sal = abs(repmat(MOF_sup,1,nLabel)-repmat(MOF_sup',nLabel,1));
GC = norm_minmax(sum(sal.*dist,2));
end

