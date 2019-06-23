function bgProb = calBGProb( frame_sup, bg_all, Label )
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


end




