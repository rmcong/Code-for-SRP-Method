function ForSRRecError = calinterSRRecError2( options, curframe_sup, preframe_sup, nextframe_sup, ismot )
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
    %% Extract superpixel features for next frame
    sulabel_next = double(nextframe_sup.Label);
    supNum_next = max(sulabel_next(:));
    regions_next = calculateRegionProps(supNum_next,sulabel_next);
    colfeat_next = extractSupfeat_col(options, nextframe_sup.Name, sulabel_next, regions_next); % supNum*26
    feat_next = [colfeat_next nextframe_sup.opflow nextframe_sup.MOF nextframe_sup.intra];% supNum*30
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
    %% Extract superpixel features for next frame
    sulabel_next = double(nextframe_sup.Label);
    supNum_next = max(sulabel_next(:));
    regions_next = calculateRegionProps(supNum_next,sulabel_next);
    colfeat_next = extractSupfeat_col(options, nextframe_sup.Name, sulabel_next, regions_next); % supNum*26
    feat_next = [colfeat_next nextframe_sup.intra];% supNum*27
end
%% Extract foreground templates from previous frame and next frame
fg_sp_pre = extract_fg_sp(preframe_sup.intra,options.fg_num);%factor是尺度因子，即从总超像素个数中选择前10%个超像素做前景种子点
Dictionary_pre = feat_previous(fg_sp_pre,:);
fg_sp_next = extract_fg_sp(nextframe_sup.intra,options.fg_num);%factor是尺度因子，即从总超像素个数中选择前10%个超像素做前景种子点
Dictionary_next = feat_next(fg_sp_next,:);
Dictionary = [Dictionary_pre' Dictionary_next']';
%% Calculate sparse reconstruction error for current frame
ForSRRecError = calculateSRError(Dictionary',feat_current',paramSR);%求解重建误差
end


