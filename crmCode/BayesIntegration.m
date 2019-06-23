function [ ByesSaliency ] = BayesIntegration( propSRRecErrorDiffusionSaliency,compactDiffSaliency,frame_norm,height,width )
%% 该函数用于利用贝叶斯后验概率融合两个显著性结果  参考程序DSR方法  2017/05/10
%% 输入propSRRecErrorDiffusionSaliency,compactDiffSaliency都是M*N大小的图片
SRPriorBayes = calBayesPosterior(propSRRecErrorDiffusionSaliency,compactDiffSaliency,frame_norm,height,width);
compactPriorBayes = calBayesPosterior(compactDiffSaliency,propSRRecErrorDiffusionSaliency,frame_norm,height,width);
salmaps = zeros(height,width,2);
salmaps(:,:,1) = SRPriorBayes(:,:,1);
salmaps(:,:,2) = compactPriorBayes(:,:,1);
ByesSaliency = combineSalMap(salmaps, '+');
end

