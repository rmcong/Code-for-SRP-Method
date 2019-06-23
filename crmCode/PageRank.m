function BGseeds = PageRank( compactness, BGindex, S  )
% PageRank
BGindexSal = compactness(BGindex);
if max(BGindexSal) == min(BGindexSal)
    BGseeds = BGindex;
else
    A1 = S(BGindex,:);
    A2 = A1(:,BGindex);
    A2(logical(eye(size(A2)))) = 0;
    PR = 0.5*(eye(size(BGindex,1))-0.5*A2)\eye(size(BGindex,1))*BGindexSal;
    PR_norm = norm_minmax(PR);
    thmean = mean(PR_norm);
    ind_PR = find(PR_norm<=thmean);
    BGseeds = BGindex(ind_PR);
end

end

