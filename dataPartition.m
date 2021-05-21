function [trDb, trLabel, tsDb, tsLabel] = dataPartition(fullDataset, fullLabel)
% 
%   dataPartition - randomizes and separates data in 65% training and 35%
%   test datasets
%
%---INPUT------------------------------------------------------------------
%
%   fullDataset <numerical> normilized dataset of features (predictors)
%   fullLabel <string> column of outcome (prediction)
%
%---OUTPUT-----------------------------------------------------------------
%
%   trDb <numerical> training, 
%   trLabel <string> 
%   tsDb <numerical> testing & fscore average 
%                and std values
% 


% Edit AK-AJD(c) 05-14-2021

tsPercent = 0.35;

c = cvpartition(size(fullDataset,1), 'HoldOut', tsPercent);

trDb = fullDataset(training(c), :);
trLabel = fullLabel(training(c), :);

trDbIdx = training(c, 1);
trLabelIdx = test(c, 1);

tsDb = fullDataset(test(c), :);
tsLabel = fullLabel(test(c), :);

end