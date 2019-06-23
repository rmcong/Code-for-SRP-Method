function BayesPosterior = calBayesPosterior(prior,observer,frame_norm,r,c)
%% Calculate the Bayesian posterior probability. crm revised at 2017/05/100 
paramHist.isColorObserver = 0;       	%1: calculate the likelihoods of Bayesian inference by Lab color
paramHist.isErrorObserver = 1;      	%1: calculate the likelihoods of Bayesian inference by error map
paramHist.numBin = 60;
paramHist.labFactor = 5;
paramHist.errFactor = 0.02;

BayesPosterior = zeros(r,c,3);
BW = im2bw(prior,mean(prior(:)));
ind = find(BW==1);
out_ind = find(BW==0);

input_imlab = RGB2Lab(frame_norm);

%% calculate the likelihoods of Bayesian inference by Lab color
if paramHist.isColorObserver
    smoothFactor = paramHist.labFactor;
    BayesPosterior(:,:,2) = Bayes(prior, input_imlab, ind, out_ind, paramHist.numBin, smoothFactor, r, c);
end
%% calculate the likelihoods of Bayesian inference by error map
if paramHist.isErrorObserver
    smoothFactor = paramHist.errFactor;
    BayesPosterior(:,:,1) = Bayes(prior, observer, ind, out_ind, paramHist.numBin, smoothFactor, r, c);
end