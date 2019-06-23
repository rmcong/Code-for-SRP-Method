function [ SRRecError, propSRRecError ] = calColorSRRecError( options, frameName, Label, bg_sp )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 利用稀疏重建误差提取显著性区域 2017/06/28 使用26维特征表示超像素特性 RGB Lab HSV texton（15） x y
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
r = size(Label,1);
c = size(Label,2);
supNum = max(sulabel(:));
regions = calculateRegionProps(supNum,sulabel);
%% Extract superpixel features
% [sup_feat,color_weight] = extractSupfeat(options, frameName, regions, row, col, sup_num); % supNum*8
feat = extractSupfeat_col(options, frameName, sulabel, regions); % supNum*26
featDim = size(feat,2);
%% Extract background templates
bgfeat = feat(bg_sp,:);
%% Calculate sparse reconstruction error
SRRecError = calculateSRError(bgfeat',feat',paramSR);%求解重建误差
% SRRecErrorSaliency = convertRecErrorToSal(SRRecError,regions,r,c,supNum);%将重建误差转化成图像大小的显著性图
%% Propagate sparse reconstruction error
propSRRecError = descendPropagation(feat,SRRecError,paramPropagate,supNum,featDim);% 1*spnum
% propSRRecErrorSaliency = convertRecErrorToSal(propSRRecError,regions,r,c,supNum);%M*N

end

