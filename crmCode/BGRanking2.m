function BGseeds = BGRanking2( BGindex, options, frameName, FGindex, Label )

% 2017年6月22日 第1次修改 该函数用于 对候选背景种子点进行再筛选
% 输入：
% options, frameName：读入的原始rgb数据 参数
% BGindex：所有候选背景种子点 
% FGindex：uniqueness prior得到的前景种子点
% Label：超像素标号矩阵
% 输出：
% BGseeds：最终选择出的背景种子点标号
imdata = get_imgData( options.infolder, frameName );% input_im: normalized double data M*N*3
supcol = get_supData( imdata, Label );% 提取超像素的颜色特征 包括直方图 纹理等
AllHist = supcol.LabHist;% 512*spnum
bgHist = AllHist(:,BGindex); % 512*bgnum
fgHist = AllHist(:,FGindex); % 512*fgnum
FGHist = mean(fgHist,2); % 512*1 前景平均直方图
dist_bgfg = DistanceZL(bgHist', FGHist', 'chi'); % bgnum×1 所有背景种子点与前景类的直方图距离
dist_bgbg = sum(DistanceZL(bgHist', bgHist', 'chi'),2); % bgnum×1  所有背景种子点与其他背景种子点的直方图距离之和
dist_bgfg_norm = norm_minmax(dist_bgfg);
dist_bgbg_norm = norm_minmax(dist_bgbg);
th1 = mean(dist_bgfg_norm);
th2 = mean(dist_bgbg_norm);
ind1 = find(dist_bgfg_norm >= th1);
ind2 = find(dist_bgbg_norm <= th2);
label1 = BGindex(ind1);
label2 = BGindex(ind2);
BGseeds = unique(union(label1,label2));

end




