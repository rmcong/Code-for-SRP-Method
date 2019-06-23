function allsals = readallsals0( videonum, intraSaliency, interForeSaliency )
% 读取视频所有帧的intra saliency结果  2017/07/08
allsals = [];
nframe = length( interForeSaliency{videonum} );
sals = cell( nframe, 1 );
for index = 1: nframe
    sals{ index } = norm_minmax(intraSaliency{videonum}{index} + interForeSaliency{videonum}{index});
    allsals = [allsals;sals{ index }];
end
end

