function [ fgRGBHist ] = calfgHist0( data, allsals, bounds, height, width, K )
% 视频所有帧的saliency模型  2017/07/26
allframes = data.frames;% 读取视频所有帧的rgb数据
nframe = length( data.superpixels );%待处理的视频帧数
fg_pixel = [];
for index = 1: nframe-1
    frame = allframes{index}; % double M*N*3 0-255
    frame_norm = norm_img(frame); % double M*N*3 0-1
    frame_vals = reshape(frame_norm, height*width, 3);
    Label = double(data.superpixels{index}.Label); % M*N
    label_vals = reshape(Label, height*width, 1);
    sal = allsals(bounds(index):bounds(index+1)-1);
%     th = 2*mean(sal);
%     ind = find(sal>=th);
    [~,indd] = sort(sal,'descend');
    ind = indd(1:K);
    for kk = 1 : length(ind)
        ind2 = find(label_vals == ind(kk));
        fg_pixel = [fg_pixel; frame_vals(ind2,:)];
    end
end
RGB_bins = [8, 8, 8];
nRGBHist = prod( RGB_bins );
% RGB histogram
R = fg_pixel(:,1);
G = fg_pixel(:,2);
B = fg_pixel(:,3);

rr = min( floor(R*RGB_bins(1)) + 1, RGB_bins(1) );
gg = min( floor(G*RGB_bins(2)) + 1, RGB_bins(2) );
bb = min( floor(B*RGB_bins(3)) + 1, RGB_bins(3) );
Q_rgb = (rr-1) * RGB_bins(2) * RGB_bins(3) + ...
    (gg-1) * RGB_bins(3) + ...
    bb + 1;
fgRGBHist = hist( Q_rgb, 1:nRGBHist )';
fgRGBHist = fgRGBHist / max( fgRGBHist );
end

