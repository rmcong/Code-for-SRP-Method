function [ supHist ] = calsupHist( data, options )
% 视频所有帧的saliency模型  2017/07/26
nframe = length( data.superpixels );%待处理的视频帧数
supHist = [];
for index = 1: nframe
    frameName = data.names{index};
    Label = double(data.superpixels{index}.Label); % int32 M*N
    imdata = get_imgData( options.infolder, frameName );% input_im: normalized double data M*N*3
    supcol = get_supData( imdata, Label );% 提取超像素的颜色特征 包括直方图 纹理等
    AllHist = supcol.RGBHist';% spnum*512
    supHist = [supHist; AllHist];
end
end

