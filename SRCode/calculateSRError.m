function recError = calculateSRError(dictionary,allfeats,paramSR)
%% Calculate the sparse reconstruction errors.
allfeats = normVector(allfeats);%每列归一化
dictionary = normVector(dictionary);%每列归一化

paramSR.L = length(allfeats(:,1)); %特征维数                               

beta = mexLasso(allfeats, dictionary, paramSR);%计算稀疏系数
beta = full(beta);%稀疏矩阵转化为全矩阵

recError = sum((allfeats - dictionary*beta(1:size(dictionary,2),:)).^2); 

recError = (recError -   min(recError(:)))/(max(recError(:)) - min(recError(:)));