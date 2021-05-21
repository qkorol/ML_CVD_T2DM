function trAcc = calculateTrainAccuracy(model)
%
%   trAcc - calculates training accuracy & does 5 fold cross-validation
%   
%---INPUT------------------------------------------------------------------
%
%   model - ML model
%
%---OUTPUT-----------------------------------------------------------------
%
%   trAcc <numerical> training accuracy
%

% Edit AK-AJD(c) 05-14-2021

modelTrained = crossval(model, 'Kfold', 5); % train on small sections
[~, ~] = kfoldPredict(modelTrained);        % predict on 1/5 of the section
trAcc = 1 - kfoldLoss(modelTrained, ...
    'LossFun', 'ClassifError');             % calculate acc from training
    
end