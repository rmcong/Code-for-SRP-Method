function extOFGM = extendImg( OFGM, r )
% 20170628 第1次修改 该函数用于 将光流梯度幅度图像向外围扩展R像素
% 输入：
% OFGM：像素级的光流梯度幅度信息 M*N
% R：扩展区域大小
% 输出：
% extOFGM：边界扩展后的OFGM数据
[m n] = size(OFGM);

extOFGM = zeros(m+2*r,n+2*r);
extOFGM(r+1:m+r,r+1:n+r) = OFGM;

extOFGM(1:r,r+1:n+r) = OFGM(1:r,1:n);                 %扩展上边界
extOFGM(1:m+r,n+r+1:n+2*r) = extOFGM(1:m+r,n+1:n+r);    %扩展右边界
extOFGM(m+r+1:m+2*r,r:n+2*r) = extOFGM(m+1:m+r,r:n+2*r);    %扩展下边界
extOFGM(1:m+2*r,1:r) = extOFGM(1:m+2*r,r+1:2*r);       %扩展左边界
end

