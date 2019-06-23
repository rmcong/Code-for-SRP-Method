function [ BackSRRecError, propBackSRRecError ] = calBackwardSRRecError_20170607( options, curframe_sup, backframe_sup, ismot )
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
if ismot ==1
    %% Extract superpixel features for current frame
    sulabel_current = double(curframe_sup.Label);
    supNum_current = max(sulabel_current(:));
    regions_current = calculateRegionProps(supNum_current,sulabel_current);
    colfeat_current = extractSupfeat_col(options, curframe_sup.Name, sulabel_current, regions_current); % supNum*26
    feat_current = [colfeat_current curframe_sup.opflow curframe_sup.MOF curframe_sup.intra curframe_sup.forward];% supNum*28
    featDim_current = size(feat_current,2);
    %% Extract superpixel features for back frame
    sulabel_back = double(backframe_sup.Label);
    supNum_back = max(sulabel_back(:));
    regions_back = calculateRegionProps(supNum_back,sulabel_back);
    colfeat_back = extractSupfeat_col(options, backframe_sup.Name, sulabel_back, regions_back); % supNum*26
    feat_back = [colfeat_back backframe_sup.opflow backframe_sup.MOF backframe_sup.intra backframe_sup.forward];% supNum*28
else
    %% Extract superpixel features for current frame
    sulabel_current = double(curframe_sup.Label);
    supNum_current = max(sulabel_current(:));
    regions_current = calculateRegionProps(supNum_current,sulabel_current);
    colfeat_current = extractSupfeat_col(options, curframe_sup.Name, sulabel_current, regions_current); % supNum*26
    feat_current = [colfeat_current curframe_sup.intra curframe_sup.forward];% supNum*28
    featDim_current = size(feat_current,2);
    %% Extract superpixel features for back frame
    sulabel_back = double(backframe_sup.Label);
    supNum_back = max(sulabel_back(:));
    regions_back = calculateRegionProps(supNum_back,sulabel_back);
    colfeat_back = extractSupfeat_col(options, backframe_sup.Name, sulabel_back, regions_back); % supNum*26
    feat_back = [colfeat_back backframe_sup.intra backframe_sup.forward];% supNum*28
end
%% Extract foreground templates from back frame
fg_sp_intra = extract_fg_sp(backframe_sup.intra,options.Backfactor);%factor是尺度因子，即从总超像素个数中选择前factor%个超像素做前景种子点
fg_sp_forward = extract_fg_sp(backframe_sup.forward,options.Backfactor);%factor是尺度因子，即从总超像素个数中选择前factor%个超像素做前景种子点
fg_sp = union(fg_sp_intra,fg_sp_forward);%factor是尺度因子，即从总超像素个数中选择前factor%个超像素做前景种子点
Dictionary = feat_back(fg_sp,:);
%% Calculate sparse reconstruction error for current frame
BackSRRecError = calculateSRError(Dictionary',feat_current',paramSR);%求解重建误差
%% Propagate sparse reconstruction error for current frame
propBackSRRecError = descendPropagation(feat_current,BackSRRecError,paramPropagate,supNum_current,featDim_current);% 1*spnum

end


