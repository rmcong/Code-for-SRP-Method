function dOFGM = diffusionOFGM( OFGM, R )
% 20170628 第1次修改 该函数用于 计算光流幅度的全局对比度
% 输入：
% MOF_sup：超像素级的光流幅度信息 spnum*1
% frame_sup：超像素级的原始视频数据 
% nLabel：double型超像素个数
% 输出：
% GC：计算全局对比信息 spnum*1
% mask = template( R );
mask = circTemplate( R );
extOFGM = extendImg( OFGM, R );
[m n] = size(OFGM);
dOFGM = zeros(m,n);
for i=R+1:m+R
    for j=R+1:n+R        
        data = extOFGM(i-R:i+R,j-R:j+R);
        dOFGM(i-R,j-R) = sum(sum(data.*mask));    
    end
end
dOFGM = norm_minmax(dOFGM);
end
