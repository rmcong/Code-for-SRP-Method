function mask = template( R )
% 该程序用于生成扩散8个方向的模板 20170627
% 绘制就矩形米字状模板
square_mask = eye(2*R+1)+fliplr(eye(2*R+1));
square_mask(R+1,:) = 1;
square_mask(:,R+1) = 1;
% 绘制圆形模板
m = 2*R + 1; %矩阵的函数  
n = 2*R + 1; %矩阵的列数  
m1 = -m/2:m/2-1;   %把圆心变到矩阵的中间  
n1 = -n/2:n/2-1;  
[x,y] = meshgrid(m1,n1);  
circle = x.^2 + y.^2;   %计算出每一点到圆心的距离的平方    
circ_mask = zeros(m,n);    
circ_mask(find(circle <= R*R))=1;  %找到圆内的元素，并复制为1  
circ_mask(find(circle > R*R))=0;   %找到圆外的元素，并复制为0   
% 绘制圆形米字状模板
mask = square_mask.*circ_mask;
end

