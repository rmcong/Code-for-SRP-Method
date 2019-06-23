function BGseeds = BGRanking7( BGindex, options, frameName, Label, frame_sup, bg_all )
% 2017年6月24日 第1次修改 该函数用于 对候选背景种子点进行再筛选
% 输入：
% options, frameName：读入的原始rgb数据 参数
% BGindex：所有候选背景种子点 
% FGindex：uniqueness prior得到的前景种子点
% Label：超像素标号矩阵
% 输出：
% BGseeds：最终选择出的背景种子点标号

%  RBD method of bgProb
colDistM = GetDistanceMatrix(frame_sup.lab);
adjcMatrix = GetAdjMatrix(Label, max(max(Label)));
[clipVal, geoSigma, neiSigma] = EstimateDynamicParas(adjcMatrix, colDistM);
[bgProb, bdCon, bgWeight] = EstimateBgProb(colDistM, adjcMatrix, bg_all', clipVal, geoSigma);
Pbg = bgProb(BGindex);

imdata = get_imgData( options.infolder, frameName );% input_im: normalized double data M*N*3
supcol = get_supData( imdata, Label );% 提取超像素的颜色特征 包括直方图 纹理等
AllHist = supcol.LabHist;% 512*spnum
bgHist = AllHist(:,BGindex); % 512*bgnum
dist_bgbg = DistanceZL(bgHist', bgHist', 'chi')*Pbg; % bgnum×1  所有背景种子点与其他背景种子点的直方图距离之和
Score = norm_minmax(dist_bgbg);
th1 = mean(Score);
ind = find(Score <= th1);
BGseeds = BGindex(ind);

end




