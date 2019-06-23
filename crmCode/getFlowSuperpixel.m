function [ flow_sup ] = getFlowSuperpixel( flow, superpixels, spnum )
% 该程序用于获取当前帧的超像素数据 2017/05/23
inds = cell(spnum,1);
flow_sup = zeros(spnum,2);
for i = 1:spnum
    inds{i} = find(superpixels==i);
    flow_sup(i,:) = mean(flow(inds{i},:),1);%每个超像素的平均颜色值 spnum×3
end
end

