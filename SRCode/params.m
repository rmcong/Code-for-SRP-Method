function [ seg_paras,isLAB,isRGB,isXY,featDim,paramSR,paramPCA,paramPropagate,paramHist,guassSigmaRatio  ] = params( )
seg_paras = [50   10;
        100  10;
        150  20;
        200  20;
        250  25;
        300  25;
        350  30;
        400  30;
        ];
    %% feature selection parameters
    isLAB = 1;                              %if isLAB = 1, LAB feature is chosen. if isLAB = 0, LAB feature is not chosen.
    isRGB = 1;
    isXY  = 1;
    featDim = 3*(isLAB+isRGB)+2*isXY;       %The actual feature dimension. featDim = 8 when LAB, RGB and XY are all chosen as features.
    %% Sparse representation parameters
    paramSR.lambda2 = 0;
    paramSR.mode    = 2;
    paramSR.lambda  = 0.01;
    %% Dense representation parameters
    paramPCA.dim  = 3*(isLAB+isRGB)+2*isXY;
    paramPCA.rate = 95;
    %% Context-based error propagation parameters
    paramPropagate.lamna = 0.5;
    paramPropagate.nclus = 8;
    paramPropagate.maxIter=200;
    %% The parameter that controls the window size of the Gaussian model
    guassSigmaRatio = 0.25;
    %% The parameters of Bayesian integration
    paramHist.isColorObserver = 0;       	%1: calculate the likelihoods of Bayesian inference by Lab color
    paramHist.isErrorObserver = 1;      	%1: calculate the likelihoods of Bayesian inference by error map
    paramHist.numBin = 60;
    paramHist.labFactor = 5;
    paramHist.errFactor = 0.02;
end

