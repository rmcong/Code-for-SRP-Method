%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2016年9月29日
% 该函数用于 提取一幅图像的超像素区域的基于颜色的各种特征，如色彩、纹理等
% 输入：
% im_rgb：rgb image with type of uint8, can be got using imread
% 输出：
% spdata：输出 结构体 超像素的特征向量
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function spdata = get_sup_feature_col( im_rgb,superpixels )
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

imdata = get_imgData( im_rgb );
spdata = get_supData( imdata, superpixels );

end

