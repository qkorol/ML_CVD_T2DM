clear all; close all; clc;

%% Load Data for Classification
sTypeC = 'Class';

[db.w5, groupLabel.w5, sVarName] = pullData(5, sTypeC);
[db.w12, groupLabel.w12, ~] = pullData(12, sTypeC);
[db.w20, groupLabel.w20, ~] = pullData(20, sTypeC);
[db.w25, groupLabel.w25, ~] = pullData(25, sTypeC);
[db.w, groupLabel.w, ~] = pullData(1, sTypeC);

sDbWeekLabels = fieldnames(db); % w5, w12, w20, w25, w
sDbLabels = fieldnames(db.w5);  % Complete, PWD, Mmode, etc

%% Feature Selection

% for iWeek = 1:size(sDbWeekLabels,1)
%     for iDataset=1:size(sDbLabels,1)
%         tableFs.(sDbWeekLabels{iWeek,1}).(sDbLabels{iDataset}) = ...
%             fsMethods(db.(sDbWeekLabels{iWeek,1}).(sDbLabels{iDataset}), ...
%             groupLabel.(sDbWeekLabels{iWeek,1}), sVarName.(sDbLabels{iDataset}));
%     end
% end
%
% % Sort for ReliefF
%
% for iWeek = 1:size(sDbWeekLabels,1)
%     for iDataset=1:size(sDbLabels,1)
%         tableFs.(sDbWeekLabels{iWeek,1}).(sDbLabels{iDataset}) = ...
%             sortrows(tableFs.(sDbWeekLabels{iWeek,1}).(sDbLabels{iDataset}),'Relief','descend');
%     end
% end
%
% save('saved_data/resFsAll.mat', 'tableFs')

load saved_data/resFsAll
resFsAll = tableFs;

%%  Classification for all timepoints

% tic;
%
% resTable = table();
% fig = figure();
%
% for iWeek=1:size(sDbWeekLabels,1)-1
%     subplot(size(sDbWeekLabels,1)-1,1,iWeek)
%     for iDataset=1:size(sDbLabels,1)
%         res = classSvm(db.(sDbWeekLabels{iWeek}).(sDbLabels{iDataset}),...
%             groupLabel.(sDbWeekLabels{iWeek}), 0);
%         errorbar(iDataset, res.trAccAver, res.trAccStd, '-o',...
%             'Color', 'red', 'MarkerFaceColor', 'red'); hold on;
%
%         res.week = sDbWeekLabels(iWeek);
%         res.dbName = sDbLabels(iDataset);
%
%         newTable = struct2table(res);
%         resTable = vertcat(resTable, newTable);
%     end
%     xticks(1:size(sDbLabels,1)); xticklabels(sDbLabels);
%     xlim([0, size(sDbLabels,1)+1]); ylim([0,1]);
%     title(sDbWeekLabels(iWeek,1)); ylabel('Accuracy'); hold off;
% end
% sgtitle('SVM model preformance')
%
% endtime = toc/60;
% fprintf(strcat("Classification pref run in ", num2str(endtime), " mins\n"));
%
% save('saved_data/resSvmModels.mat', 'resTable')

load saved_data/resSvmModels
resSvmModels = resTable;


%% Plot Datasets of SVM (all features)

fig = figure();

k = 0;
for iWeek=1:size(sDbWeekLabels,1)-1
    subplot(size(sDbWeekLabels,1)-1,1,iWeek)
    for iDataset=1:size(sDbLabels,1)
        errorbar(iDataset, resSvmModels.tsAccAver(iDataset+k), ...
            resSvmModels.tsAccStd(iDataset+k), '-o',...
            'Color', 'red', 'MarkerFaceColor', 'red'); hold on;
        %         plot(iDataset, ...
        %             resSvmModels.tsAccAver(iDataset+k), ...
        %             '-o','Color', 'red', 'MarkerFaceColor', 'red', 'MarkerSize', 6); hold on;
    end
    k = k + 9;
    xticks(1:size(sDbLabels,1)); xticklabels(sDbLabels);
    xlim([0, size(sDbLabels,1)+1]); ylim([0.24,1]);
    title(sDbWeekLabels(iWeek,1)); ylabel('Accuracy '); hold off;
end
sgtitle('SVM model preformance')


%% Feature selection & SVM

% resTable = table();
% for iWeek=1:4
%     [nListIdx, nListScores] = relieff(db.(sDbWeekLabels{iWeek}).Complete, groupLabel.(sDbWeekLabels{iWeek}), 10);
%     size(db.(sDbWeekLabels{iWeek}).Complete);
%     newData = db.(sDbWeekLabels{iWeek}).Complete(:, nListScores > 0);
% %     newData = db.(sDbWeekLabels{iWeek}).Complete(:, nListIdx(1:50));
% 
%     size(newData);
%     res = classSvm(newData, groupLabel.(sDbWeekLabels{iWeek}), 0);
% 
%     res.week = sDbWeekLabels(iWeek);
%     res.dbName = 'Complete';
%     res.fsReduced = size(newData,2);
% 
%     newTable = struct2table(res);
%     resTable = vertcat(resTable, newTable);
% 
% end

% save('saved_data/ClassSvmReducedToRelevant.mat', 'resTable')
% save('saved_data/ClassSvmReduced50.mat', 'resTable')

load saved_data/ClassSvmReducedToRelevant.mat
resSvmReducedToRelevant = resTable;

load saved_data/ClassSvmReduced50.mat
resSvmReduced50 = resTable;

%% Plot Complete models (all features & 50 features)

load saved_data/resSvmModels
resSvmModels = resTable;

fig = figure();
nWeeks = size(sDbWeekLabels,1)-1;
for iWeek=1:nWeeks
    takeData = resSvmModels(resSvmModels.dbName == "Complete", :);
    subplot(4,1,iWeek)
    errorbar(1, takeData.tsAccAver(iWeek), ...
            takeData.tsAccStd(iWeek), '-o',...
            'Color', 'red', 'MarkerFaceColor', 'red','MarkerSize', 6)
%     plot(1, takeData.tsAccAver(iWeek), 'ro', 'MarkerFaceColor', 'red','MarkerSize', 6);
%     line(xlim(), [1,1],'LineWidth', 0.5, 'Color', 'k', 'LineStyle', '--');
    xticks(1); xticklabels(sDbLabels{1});
    xlim([0.5, 1.5]); ylim([0.4,1]);
    title(sDbWeekLabels(iWeek,1)); ylabel('Accuracy');
end
sgtitle('SVM: All Data')

fig = figure();
nWeeks = size(sDbWeekLabels,1)-1;
for iWeek=1:nWeeks
    takeData = resSvmReduced50;
    subplot(4,1,iWeek)
     errorbar(1, takeData.tsAccAver(iWeek), ...
            takeData.tsAccStd(iWeek), '-o',...
            'Color', 'red', 'MarkerFaceColor', 'red','MarkerSize', 6)
%     plot(1, takeData.tsAccAver(iWeek), 'ro', 'MarkerFaceColor', 'red', 'MarkerSize', 6);
%     line(xlim(), [1,1],'LineWidth', 0.5, 'Color', 'k', 'LineStyle', '--');
    xticks(1); xticklabels(sDbLabels{1});
    xlim([0.5, 1.5]); ylim([0.4,1]);
    title(sDbWeekLabels(iWeek,1)); ylabel('Accuracy');
end
sgtitle('SVM: Reduced Data')

%% Classification for Weeks

% resTable = table();
%
% k = 0.2;
% figure();
% for iDataset=1:size(sDbLabels,1)
%     res = classSvm(db.w.(sDbLabels{iDataset}), groupLabel.w, 0);
%
%     res.week = "w";
%         res.dbName = sDbLabels(iDataset);
%
%         newTable = struct2table(res);
%         resTable = vertcat(resTable, newTable);
%
%     e = errorbar(iDataset, res.trAccAver, res.trAccStd,...
%         'o', 'MarkerFaceColor', 'red');
%     e.Color = 'red';
%     text(iDataset+2*k, res.trAccAver, ...
%         weekFs.(sDbLabels{iDataset}).Features(1:5));
%     hold on;
% end
% xticks(1:size(sDbLabels,1)); xticklabels(sDbLabels);
% xlim([0, size(sDbLabels,1)+1]); ylim([0.5,1]);
% title('SVM: Weeks'); ylabel('Accuracy'); hold off;
%
% save('saved_data/resSvmModelWeeks.mat', 'resTable')
% load saved_data/resSvmModelWeeks.mat
% weeksSvm = resTable;
%
% %% Reduced Weeks to above-zero ReliefF
%
% figure()
% [nListIdx, nListScores] = relieff(db.w.Complete, groupLabel.w, 10);
% newData = db.w.Complete(:, nListScores > 0);
% res = classSvm(db.w.Complete, groupLabel.w, 0);
% e = errorbar(5, res.trAccAver, res.trAccStd, 'o', 'MarkerFaceColor', 'red');
% e.Color = 'red';
% xticks(5); xticklabels('Complete');
% xlim([0, size(sDbLabels,1)+1]); ylim([0.5,1]);
% title('SVM: Weeks (Reduced)'); ylabel('Accuracy'); hold off;
%
% save('saved_data/weekReducedSvm.mat', 'res')
% load saved_data/weekReducedSvm.mat
% weekReducedSvm = res;


