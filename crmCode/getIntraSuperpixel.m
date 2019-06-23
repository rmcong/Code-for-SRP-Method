function [ intra_sup ] = getIntraSuperpixel( intra, superpixels, spnum )
% 该程序用于获取当前帧的超像素数据 2017/05/23
inds = cell(spnum,1);
intra_sup = zeros(spnum,1);
for i = 1:spnum
    inds{i} = find(superpixels==i);
    intra_sup(i,:) = mean(intra(inds{i},:),1);%每个超像素的平均颜色值 spnum×3
end
end


