function norm_im = norm_img( input_im )
norm_im(:,:,1)=norm_minmax(input_im(:,:,1));
norm_im(:,:,2)=norm_minmax(input_im(:,:,2));
norm_im(:,:,3)=norm_minmax(input_im(:,:,3));
end

