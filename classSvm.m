function res = classSvm(dataset, groupLabel, bPlot)
% 
%   classSvm - ML model: Support Vector Machine
%
%---INPUT------------------------------------------------------------------
%
%   dataset <numerical> normilized dataset of features (predictors)
%   groupLabel <string> column of outcome (prediction)
%   bPlot <boolean> plots figure
%
%---OUTPUT-----------------------------------------------------------------
%
%   res <struct> numerical struct with training, testing & fscore average 
%                and std values
%

% Edit AK-AJD(c) 05-14-2021

res.modelName = "SVM";
aver = 5;

for i=1:aver
    
    [trDb, trLabel, tsDb, tsLabel] = dataPartition(dataset, groupLabel);
    a = fitcsvm(trDb, trLabel); % create model
    trAcc = calculateTrainAccuracy(a);
    
    [tsPred, tsScore] = predict(a,tsDb); % test on unseen data
    tsAcc = sum(tsPred == tsLabel)/length(tsLabel); % calculate acc for test db
    
    fscore = calculateFscore(tsPred, tsLabel);
    
    trAccList(i) = trAcc;
    tsAccList(i) = tsAcc;
    fscoreList(i) = fscore;
end

% training, testing & fscore average and std values
res.trAccAver = mean(trAccList);    res.trAccStd = std(trAccList);
res.tsAccAver = mean(tsAccList);    res.tsAccStd = std(tsAccList);
res.fscoreAver = mean(fscoreList);  res.fscoreStd = std(fscoreList);

if bPlot
    plotFigure(tsPred, tsScore, tsLabel)
end

end