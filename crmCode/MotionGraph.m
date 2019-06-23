function [ Sm,Wm,Pm ] = MotionGraph( of_sup, adjc, nLabel, ismot )
% 构建图模型 20170627
if ismot == 1
    % compute the feature (mean color in lab color space) for each superpixels
    theta = 10;% 原文中(1/sigma^2)=10,sigma^2=0.1
    % Graph Construction
    W_of =  DistanceZL(of_sup, of_sup, 'euclid'); % euclid 公式9
    Sm = exp(-theta * norm_minmax(W_of));%原文中公式11 描述节点之间的相似性矩阵  spnum×spnum 主对角线元素为1
    Wm = Sm.*adjc;% spnum×spnum的affinity矩阵  原文公式10
    Pm = Diffusion_Pmatrix( Wm, nLabel );
else
    Sm = [];
    Wm = [];
    Pm = [];
end
end

