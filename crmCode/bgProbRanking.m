function BGseeds = bgProbRanking( Label, frame_sup, BGindex )

%  RBD method of bgProb
bdIds = GetBndPatchIds(Label);
colDistM = GetDistanceMatrix(frame_sup.lab);
adjcMatrix = GetAdjMatrix(Label, max(max(Label)));
[clipVal, geoSigma, neiSigma] = EstimateDynamicParas(adjcMatrix, colDistM);
[bgProb, bdCon, bgWeight] = EstimateBgProb(colDistM, adjcMatrix, bg_all', clipVal, geoSigma);
% [bgProb1, bdCon1, bgWeight1] = EstimateBgProb(colDistM, adjcMatrix, bdIds, clipVal, geoSigma);
BGProb = bgProb(BGindex); % find the salicny of the boundary superpixel
th = mean(BGProb); % threshld
ind_bg = find(BGProb>=th);
BGseeds = BGindex(ind_bg); % the final boundary superpixels


end

