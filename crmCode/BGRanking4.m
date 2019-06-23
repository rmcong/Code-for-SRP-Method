function BGseeds = BGRanking4( BGindex, options, frameName, FGindex, Label, frame_sup, bg_all, compactness )
% 2017年6月24日 第1次修改 该函数用于 对候选背景种子点进行再筛选
% 输入：
% options, frameName：读入的原始rgb数据 参数
% BGindex：所有候选背景种子点 
% FGindex：uniqueness prior得到的前景种子点
% Label：超像素标号矩阵
% 输出：
% BGseeds：最终选择出的背景种子点标号

%  RBD method of bgProb
bdIds = GetBndPatchIds(Label);
colDistM = GetDistanceMatrix(frame_sup.lab);
adjcMatrix = GetAdjMatrix(Label, max(max(Label)));
[clipVal, geoSigma, neiSigma] = EstimateDynamicParas(adjcMatrix, colDistM);
[bgProb, bdCon, bgWeight] = EstimateBgProb(colDistM, adjcMatrix, bg_all', clipVal, geoSigma);
Pbg = bgProb(BGindex);

Sfg = mean(compactness(FGindex));%1*1
Sbg = compactness(BGindex);%bgnum*1
Sfactor = exp(abs(Sbg-Sfg));

imdata = get_imgData( options.infolder, frameName );% input_im: normalized double data M*N*3
supcol = get_supData( imdata, Label );% 提取超像素的颜色特征 包括直方图 纹理等
AllHist = supcol.LabHist;% 512*spnum
bgHist = AllHist(:,BGindex); % 512*bgnum
fgHist = AllHist(:,FGindex); % 512*fgnum
FGHist = mean(fgHist,2); % 512*1 前景平均直方图
dist_bgfg = DistanceZL(bgHist', FGHist', 'chi').*Sfactor; % bgnum×1 所有背景种子点与前景类的直方图距离
dist_bgbg = DistanceZL(bgHist', bgHist', 'chi')*Pbg; % bgnum×1  所有背景种子点与其他背景种子点的直方图距离之和
dist_bgfg_norm = norm_minmax(dist_bgfg);
dist_bgbg_norm = norm_minmax(dist_bgbg);
Score = 0.5 * dist_bgfg_norm + 0.5*(1-dist_bgbg_norm);
th1 = mean(Score);
ind = find(Score >= th1);
BGseeds = BGindex(ind);

end




