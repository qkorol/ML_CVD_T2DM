function tableFs = fsMethods(nData, sLabel, sFeature)
%
% fsMethods – uses feature selection methods and creates a table with all
% results
%
%---INPUT------------------------------------------------------------------
%
%   nData <numerical> normilized dataset of features (predictors)
%   sLabel <string> column of outcome (prediction)
%   sFeature <string> feature list
% 
%---OUTPUT-----------------------------------------------------------------
%   
%   tableFs <numerical> scores of each FS method in respect to feature list
%

% Edit AK-AJD(c) 01-17-2021

% Maximum relevancy and minimum redundancy
[nListIdx, nListScores] = fscmrmr(nData, sLabel);
tableFs = table(sFeature', nListScores', 'VariableNames', {'Features', 'MRMR'});

% figure(); bar(nListScores(nListIdx));
% xlabel('Feature index'); ylabel('Feature importance score');

% Neighborhood component analysis
model = fscnca(nData, sLabel);
nListScores = model.FeatureWeights';
tableFs = addvars(tableFs, nListScores', 'NewVariableNames', 'NCA');

% figure(); plot(nFsWeights, 'ro');
% xlabel('Feature index'); ylabel('Feature importance score');

% figure(); plot(model.FitInfo.Iteration, model.FitInfo.Objective, 'ko-');
% xlabel('Iteration'); ylabel('Objective');

% acc = -model.FitInfo.UnregularizedObjective;
% figure(); plot(model.FitInfo.Iteration, acc, 'bo-');
% xlabel('Iteration'); ylabel('Leave-one-out accuracy');

% Out of bag importance
model = fitcensemble(nData, sLabel, 'Method' , 'Bag');
nListScores = oobPermutedPredictorImportance(model);
tableFs = addvars(tableFs, nListScores', 'NewVariableNames', 'OOB');
% figure(); plot(Imp, 'go')
% xlabel('Feature index'); ylabel('Feature importance score');

% predictorImportance
model = fitcensemble(nData, sLabel, 'Method' , 'Bag');
[nListScores, ~] = predictorImportance(model);
tableFs = addvars(tableFs, nListScores', 'NewVariableNames', 'PI');

% Relief
[nListIdx, nListScores] = relieff(nData, sLabel, 10);
tableFs = addvars(tableFs, nListScores', 'NewVariableNames', 'Relief');
% figure(); bar(weights); %bar(weights(idx));
% xlabel('Feature index'); ylabel('Feature importance weight');

% Chi-square
[nListIdx, nListScores] = fscchi2(nData, sLabel);
tableFs = addvars(tableFs, nListScores', 'NewVariableNames', 'Chi2');
% figure();  bar(scores(idx)); %bar(scores);
% xlabel('Feature index'); ylabel('Feature importance weight');
end
