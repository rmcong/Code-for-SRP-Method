function [ConSedge ConSTedge] = ConnectEdge( data, bounds, nframe, centres, height, width )
% 2017/07/06 第1次修改 该函数用于 构建整个视频序列超像素之间的空间边缘和空时边缘
% 输入：
% options, frameName：读入的原始rgb数据 参数
% BGindex：所有候选背景种子点
% FGindex：uniqueness prior得到的前景种子点
% Label：超像素标号矩阵
% 输出：
% BGseeds：最终选择出的背景种子点标号

ConSPix = [];
Conedge = [];%空间邻接关系
for index = 1:nframe-1
    Label = data.superpixels{index}.Label;
    [conSPix conedge]= find_connect_superpixel( Label, max(Label(:)), height ,width );
    Conedge = [Conedge;conedge + bounds(index)-1];
end
ConSedge = Conedge;%空间邻接关系
for index = 1:nframe-2
    [x y] = meshgrid(1:bounds(index+1)-bounds(index),1:bounds(index+2)-bounds(index+1));
    conedge = [x(:)+bounds(index)-1,y(:)+bounds(index+1)-1];
    connect = sum((centres(conedge(:,1),:) - centres(conedge(:,2),:)).^2,2 );
    Conedge = [Conedge;conedge(find(connect<800),:)];
end
ConSTedge = Conedge;%空间邻接关系
end


