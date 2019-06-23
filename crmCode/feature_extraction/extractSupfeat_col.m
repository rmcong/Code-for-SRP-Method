function [sup_feat] = extractSupfeat_col(options, frameName, sulabel, regions)
%% Extract superpixel features.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% spdata.R 颜色数据 1×spnum
% spdata.G 颜色数据 1×spnum
% spdata.B 颜色数据 1×spnum
% spdata.RGBHist RGB直方图 512×spnum
% spdata.L 颜色数据 1×spnum
% spdata.a 颜色数据 1×spnum
% spdata.b 颜色数据 1×spnum
% spdata.LabHist Lab直方图 512×spnum
% spdata.H 颜色数据 1×spnum
% spdata.S 颜色数据 1×spnum
% spdata.V 颜色数据 1×spnum
% spdata.HSVHist HSV直方图 512×spnum
% spdata.texture 纹理 15×spnum
% spdata.textureHist 纹理直方图 15×spnum
% spdata.lbpHist LBP直方图 256×spnum

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imdata = get_imgData( options.infolder, frameName );% input_im: normalized double data M*N*3
spdata = get_supData( imdata, sulabel );% struct data
sup_num = max(sulabel(:));

row = size(sulabel,1);
col = size(sulabel,2);

% color_weight = zeros(row, col);

sup_feat = [];
for r = 1:sup_num
%     ind = regions{r}.pixelInd;
    indxy = regions{r}.pixelIndxy;
    location = [mean(indxy(:,2))/col,mean(indxy(:,1))/row];% 1*2
    color = [spdata.R(r) spdata.G(r) spdata.B(r) spdata.L(r) spdata.a(r) spdata.b(r) spdata.H(r) spdata.S(r) spdata.V(r)];% 1*9
    texture = spdata.texture(:,r);% 1*15
    feat = [color location texture'];% 1*26
%     color_weight(ind) = computeColorDist([R(ind) G(ind) B1(ind) L(ind) A(ind) B2(ind) indxy],repmat(meanall, [length(ind), 1]));
    sup_feat = [sup_feat;feat];
end
% color_weight = 1 ./ (color_weight + eps);

% function color_dist = computeColorDist(c1, c2)
% color_dist = sqrt(sum((c1 - c2).^2, 2));