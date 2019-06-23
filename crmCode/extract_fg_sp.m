function fg_sp = extract_fg_sp(sal_sup,fg_num)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find the superpixel label for each foreground templates. 2017/05/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
th = 2*mean(sal_sup);
index1 = find(sal_sup>=th);
[~,ind] = sort(sal_sup,'descend');
index2 = ind(1:fg_num);
fg_sp = intersect(index1,index2);
if isempty(fg_sp)
    fg_sp = index2;
end
% fg_sp = unique(union(index1,index2));
end