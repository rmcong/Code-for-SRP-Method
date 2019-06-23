function [ ForSRRecError, propForSRRecError ] = calForwardSRRecError( options, frameName_current, Label_current, opflow_current_sup, frameName_previous, Label_previous, opflow_previous_sup, Salintra_previous )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 利用稀疏重建误差提取显著性区域 2017/05/25 
% 使用28维特征表示超像素特性 RGB Lab HSV texton（15） x y flowx flowy
% Salintra是超像素级显著性列向量
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sparse representation parameters
paramSR.lambda2 = 0;
paramSR.mode    = 2;
paramSR.lambda  = 0.01;
%% Context-based error propagation parameters
paramPropagate.lamna = 0.5;
paramPropagate.nclus = 8;
paramPropagate.maxIter = 200;
%% Extract superpixel features for current frame
sulabel_current = double(Label_current);
supNum_current = max(sulabel_current(:));
regions_current = calculateRegionProps(supNum_current,sulabel_current);
colfeat_current = extractSupfeat_col(options, frameName_current, sulabel_current, regions_current); % supNum*26
feat_current = [colfeat_current opflow_current_sup];% supNum*28
featDim_current = size(feat_current,2);
%% Extract superpixel features for previous frame
sulabel_previous = double(Label_previous);
supNum_previous = max(sulabel_previous(:));
regions_previous = calculateRegionProps(supNum_previous,sulabel_previous);
colfeat_previous = extractSupfeat_col(options, frameName_previous, sulabel_previous, regions_previous); % supNum*26
feat_previous = [colfeat_previous opflow_previous_sup];% supNum*28
%% Extract foreground templates from previous frame
fg_sp = extract_fg_sp(Salintra_previous,options.Forfactor);%factor是尺度因子，即从总超像素个数中选择前10%个超像素做前景种子点
Dictionary = feat_previous(fg_sp,:);
%% Calculate sparse reconstruction error for current frame
ForSRRecError = calculateSRError(Dictionary',feat_current',paramSR);%求解重建误差
%% Propagate sparse reconstruction error for current frame
propForSRRecError = descendPropagation(feat_current,ForSRRecError,paramPropagate,supNum_current,featDim_current);% 1*spnum

end


