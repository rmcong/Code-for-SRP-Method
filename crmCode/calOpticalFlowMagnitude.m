function [ MOF_norm ] = calOpticalFlowMagnitude( opflow )
% 计算光流幅度 2017/06/09
OF = flowToColor(opflow);
MOF_norm = norm_minmax(sqrt( double(OF( :, :, 1 )).^2 + double(OF( :, :, 2 )).^2 + double(OF( :, :, 3 )).^2));

end

