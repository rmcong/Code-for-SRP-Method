function [ frame_sup ] = getFrameSuperpixel( input_vals, superpixels, spnum, height, width )
% 该程序用于获取当前帧的超像素数据 2017.03.29
STATS = regionprops(superpixels, 'all');%得到超像素标号矩阵的所有属性特征，包括质心、个数等。
inds = cell(spnum,1);
[x, y] = meshgrid(1:1:width, 1:1:height);%m×n的矩阵，每行是1~n的数字
frame_sup.rgb = zeros(spnum,3);
frame_sup.x = zeros(spnum,1);
frame_sup.y = zeros(spnum,1);
frame_sup.num = zeros(spnum,1);
frame_sup.area = zeros(spnum,1);
frame_sup.adjc = zeros(spnum,spnum);
for i = 1:spnum
    inds{i} = find(superpixels==i);
    frame_sup.num(i) = length(inds{i});%每个超像素包含像素的个数
    frame_sup.rgb(i,:) = mean(input_vals(inds{i},:),1);%每个超像素的平均颜色值 spnum×3
    frame_sup.x(i) = sum(x(inds{i}))/frame_sup.num(i);%超像素的x坐标
    frame_sup.y(i) = sum(y(inds{i}))/frame_sup.num(i);%超像素的y坐标
    frame_sup.area(i,:) = STATS(i).Area;    
end
frame_sup.adjc = calAdjacentMatrix(superpixels,spnum);
frame_sup.lab = colorspace('Lab<-', frame_sup.rgb);
end

