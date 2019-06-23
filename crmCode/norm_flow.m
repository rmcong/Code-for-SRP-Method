function norm_flow = norm_flow( flow )
norm_flow(:,:,1)=norm_minmax(flow(:,:,1));
norm_flow(:,:,2)=norm_minmax(flow(:,:,2));
end

