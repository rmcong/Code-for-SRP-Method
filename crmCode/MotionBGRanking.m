function MBGseeds = MotionBGRanking( MBGindex, of_sup,  MOF_sup )
% 2017年6月28日 第1次修改 该函数用于 对候选背景种子点进行再筛选
% 输入：
% MBGindex：所有候选背景种子点 
% of_sup,  MOF_sup：超像素级的光流数据和光流幅度数据
% 输出：
% MBGseeds：最终选择出的背景种子点标号

bgof = of_sup(MBGindex);% bgnum*2
bgmof = MOF_sup(MBGindex);% bgnum*1
bgfeature = [bgof bgmof];% bgnum*3
dist_bgbg = DistanceZL(bgfeature, bgfeature, 'euclid'); % bgnum×bgnum 
Score = norm_minmax(sum(dist_bgbg,2));
[~,index] = sort(Score,'descend');
ind = index(1:floor(0.8*length(MBGindex)));
MBGseeds = MBGindex(ind);
end




