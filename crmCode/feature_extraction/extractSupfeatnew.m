function [sup_feat] = extractSupfeatnew(options, frameName, sulabel, regions, of_sup,  MOF_sup)
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

sup_feat = [];
for r = 1:sup_num
    indxy = regions{r}.pixelIndxy;
    location = [mean(indxy(:,2))/col,mean(indxy(:,1))/row];% 1*2
    color = [spdata.R(r) spdata.G(r) spdata.B(r) spdata.L(r) spdata.a(r) spdata.b(r) spdata.H(r) spdata.S(r) spdata.V(r)];% 1*9
    texture = spdata.texture(:,r);% 1*15
    motion = [of_sup(r)  MOF_sup(r)];% 1*3
    feat = [color location texture' motion];% 1*29
    sup_feat = [sup_feat;feat];
end