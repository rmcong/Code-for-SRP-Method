function [ BackSRRecError, propBackSRRecError ] = calBackwardSRRecError( options, frameName_current, Label_current, opflow_current_sup,  frameName_back, Label_back, opflow_back_sup, intra_back_sup, forward_back_sup )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 利用稀疏重建误差提取显著性区域 2017/05/25 
% 使用28维特征表示超像素特性 RGB Lab HSV texton（15） x y flowx flowy
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
%% Extract superpixel features for back frame
sulabel_back = double(Label_back);
supNum_back = max(sulabel_back(:));
regions_back = calculateRegionProps(supNum_back,sulabel_back);
colfeat_back = extractSupfeat_col(options, frameName_back, sulabel_back, regions_back); % supNum*26
feat_back = [colfeat_back opflow_back_sup];% supNum*28
%% Extract foreground templates from back frame
fg_sp_intra = extract_fg_sp(intra_back_sup,options.Backfactor);%factor是尺度因子，即从总超像素个数中选择前factor%个超像素做前景种子点
fg_sp_forward = extract_fg_sp(forward_back_sup,options.Backfactor);%factor是尺度因子，即从总超像素个数中选择前factor%个超像素做前景种子点
fg_sp = union(fg_sp_intra,fg_sp_forward);%factor是尺度因子，即从总超像素个数中选择前factor%个超像素做前景种子点
Dictionary = feat_back(fg_sp,:);
%% Calculate sparse reconstruction error for current frame
BackSRRecError = calculateSRError(Dictionary',feat_current',paramSR);%求解重建误差
%% Propagate sparse reconstruction error for current frame
propBackSRRecError = descendPropagation(feat_current,BackSRRecError,paramPropagate,supNum_current,featDim_current);% 1*spnum

end


