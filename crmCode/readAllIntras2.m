function [ sals, allsals ] = readAllIntras2( data )
% 读取视频所有帧的intra saliency结果  2017/05/23 
allsals = [];
nframe = length( data.intra );
sals = cell( nframe, 1 );
for index = 1: nframe
    sals{ index } = norm_minmax(data.intra{index} + data.forinter{index} + data.backinter{index});
    allsals = [allsals;sals{ index }];
end
end

