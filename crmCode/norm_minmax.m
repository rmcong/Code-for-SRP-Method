function value = norm_minmax(in)
% 将数值范围归一化到0~1

value = (in - min(in(:)))/(max(in(:)) - min(in(:)));