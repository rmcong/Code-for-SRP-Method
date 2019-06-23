function [ of ] = getOFSuperpixel( input_vals, superpixels, spnum )
% 该程序用于获取当前帧的超像素数据 20170627
inds = cell(spnum,1);
of = zeros(spnum,2);
for i = 1:spnum
    inds{i} = find(superpixels==i);
    of(i,:) = mean(input_vals(inds{i},:),1);%每个超像素的平均颜色值 spnum×3  
end
end

