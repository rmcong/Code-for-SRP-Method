function [ ForSRRecError, propForSRRecError, diffpropForSRRecError ] = calForwardSRRecError_20170703( options, curframe_sup, preframe_sup, P_current, ismot )
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
if ismot == 1;
    %% Extract superpixel features for current frame
    sulabel_current = double(curframe_sup.Label);
    supNum_current = max(sulabel_current(:));
    regions_current = calculateRegionProps(supNum_current,sulabel_current);
    colfeat_current = extractSupfeat_col(options, curframe_sup.Name, sulabel_current, regions_current); % supNum*26
    feat_current = [colfeat_current curframe_sup.opflow curframe_sup.MOF curframe_sup.intra];% supNum*30
    featDim_current = size(feat_current,2);
    %% Extract superpixel features for previous frame
    sulabel_previous = double(preframe_sup.Label);
    supNum_previous = max(sulabel_previous(:));
    regions_previous = calculateRegionProps(supNum_previous,sulabel_previous);
    colfeat_previous = extractSupfeat_col(options, preframe_sup.Name, sulabel_previous, regions_previous); % supNum*26
    feat_previous = [colfeat_previous preframe_sup.opflow preframe_sup.MOF preframe_sup.intra];% supNum*30
else
    %% Extract superpixel features for current frame
    sulabel_current = double(curframe_sup.Label);
    supNum_current = max(sulabel_current(:));
    regions_current = calculateRegionProps(supNum_current,sulabel_current);
    colfeat_current = extractSupfeat_col(options, curframe_sup.Name, sulabel_current, regions_current); % supNum*26
    feat_current = [colfeat_current curframe_sup.intra];% supNum*27
    featDim_current = size(feat_current,2);
    %% Extract superpixel features for previous frame
    sulabel_previous = double(preframe_sup.Label);
    supNum_previous = max(sulabel_previous(:));
    regions_previous = calculateRegionProps(supNum_previous,sulabel_previous);
    colfeat_previous = extractSupfeat_col(options, preframe_sup.Name, sulabel_previous, regions_previous); % supNum*26
    feat_previous = [colfeat_previous preframe_sup.intra];% supNum*27
end
%% Extract foreground templates from previous frame
fg_sp = extract_fg_sp(preframe_sup.intra,options.fg_num);%factor是尺度因子，即从总超像素个数中选择前10%个超像素做前景种子点
Dictionary = feat_previous(fg_sp,:);
%% Calculate sparse reconstruction error for current frame
ForSRRecError = calculateSRError(Dictionary',feat_current',paramSR);%求解重建误差
%% Propagate sparse reconstruction error for current frame
propForSRRecError = descendPropagation(feat_current,ForSRRecError,paramPropagate,supNum_current,featDim_current);% 1*spnum
diffpropForSRRecError = norm_minmax(P_current*propForSRRecError');% spnum*1 Manifold Ranking-based Diffusion
end


