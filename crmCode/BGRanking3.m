function BGseeds = BGRanking3( BGindex, options, frameName, FGindex, Label, frame_sup, bg_all, compactness )
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
dist_bgbg_norm = norm_minmax(dist_bgbg);
th2 = mean(dist_bgbg_norm);
ind2 = find(dist_bgbg_norm <= th2);
label2 = BGindex(ind2);

if ~isempty(FGindex)
    Sfg = mean(compactness(FGindex));%1*1
    Sbg = compactness(BGindex);%bgnum*1
    Sfactor = exp(abs(Sbg-Sfg));
        
    fgHist = AllHist(:,FGindex); % 512*fgnum
    FGHist = mean(fgHist,2); % 512*1 前景平均直方图
    dist_bgfg = DistanceZL(bgHist', FGHist', 'chi').*Sfactor; % bgnum×1 所有背景种子点与前景类的直方图距离   
    dist_bgfg_norm = norm_minmax(dist_bgfg);
    
    th1 = mean(dist_bgfg_norm);
    ind1 = find(dist_bgfg_norm >= th1);
    label1 = BGindex(ind1);
    
    BGseeds = unique(union(label1,label2));
else
    BGseeds = label2;
end

end




