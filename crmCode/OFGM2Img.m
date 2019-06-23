function label = OFGM2Img( OFGM )
% 2017年6月29日 第1次修改 该函数用于 由边缘图生成分割区域
th = graythresh( OFGM );
label = bwlabel( OFGM >= th);
end
