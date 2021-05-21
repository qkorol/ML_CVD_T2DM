function fscore = calculateFscore(tsPred, tsLabel)
%
%   fscore - calculates fscore on predicted and true labels
%   
%---INPUT------------------------------------------------------------------
%
%   tsPred - predicted labels
%   tsLabel - true labels
%
%---OUTPUT-----------------------------------------------------------------
%
%   fscore <numerical> fscore value

% Edit AK-AJD(c) 05-14-2021

confMatrix = confusionmat(tsPred, tsLabel); % confusion matrix

for i=1:size(confMatrix, 1)
    
    TP = diag(confMatrix);                  % true positive
    TP = TP(i);                     
    FP = sum(confMatrix(:,i),1) - TP;       % false positive
    FN = sum(confMatrix(i,:),2) - TP;       % false negative
    TN = sum(confMatrix(:)) - TP - FP - FN; % true negative
    
    acc = (TP+TN)./(TP+TN+FP+FN);           % accuracy
    
    recallTP = TP./(TP + FN);               % recall
    if isnan(recallTP), recallTP = 0; end
    
    predPrecision  = TP./(TP + FP);         % precision
    if isnan(predPrecision), predPrecision = 0; end
    
    % f score
    fscore = 2*predPrecision*recallTP/(predPrecision + recallTP);
    if isnan(fscore), fscore = 0; end
    end

end



