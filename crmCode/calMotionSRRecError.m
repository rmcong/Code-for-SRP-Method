function [ SRRecError, propSRRecError ] = calMotionSRRecError( options, frameName, Label, bg_sp, of_sup,  MOF_sup )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 利用稀疏重建误差提取显著性区域 2017/06/28 使用26维特征表示超像素特性 RGB Lab HSV motion(3)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sparse representation parameters
paramSR.lambda2 = 0;
paramSR.mode    = 2;
paramSR.lambda  = 0.01;
%% Context-based error propagation parameters
paramPropagate.lamna = 0.5;
paramPropagate.nclus = 8;
paramPropagate.maxIter = 200;
%% load input image data
sulabel = Label;
% r = size(Label,1);
% c = size(Label,2);
supNum = max(sulabel(:));
% regions = calculateRegionProps(supNum,sulabel);
%% Extract superpixel features
% [sup_feat,color_weight] = extractSupfeat(options, frameName, regions, row, col, sup_num); % supNum*8
feat = extractSupfeat_motion(options, frameName, sulabel, of_sup,  MOF_sup); % supNum*12
featDim = size(feat,2);
%% Extract background templates
bgfeat = feat(bg_sp,:);
%% Calculate sparse reconstruction error
SRRecError = calculateSRError(bgfeat',feat',paramSR);%求解重建误差
%% Propagate sparse reconstruction error
propSRRecError = descendPropagation(feat,SRRecError,paramPropagate,supNum,featDim);% 1*spnum

end

