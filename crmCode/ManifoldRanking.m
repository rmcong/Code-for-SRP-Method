function BGseeds = ManifoldRanking( compactness, BGindex, S  )
% Manifold Ranking
BGindexSal = compactness(BGindex);
if max(BGindexSal) == min(BGindexSal)
    BGseeds = BGindex;
else
    A1 = S(BGindex,:);
    A2 = A1(:,BGindex);
    A2(logical(eye(size(A2)))) = 0;
    PMR = Diffusion_Pmatrix( A2, size(BGindex,1) );
    [~,ind2] = sort(BGindexSal);
    ind3 = ind2(1:floor(0.1*size(BGindex,1)));
    query = zeros(size(BGindex,1),1);
    query(ind3) = 1;
    MR = PMR*query;
    MR_norm = norm_minmax(MR);
    thmean = mean(MR_norm);
    ind_MR = find(MR_norm>=thmean);
    BGseeds = BGindex(ind_MR);
end


end

