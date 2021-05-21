function [db, sGroupLabel, sVariableName] = pullData(nDbName, Type)
%
% Function PULLDATA gets data for mice's specific week and distributes it
% into separate datasets: Complete, PWD, Mmode, Global, Segmental, Anterior,
% Posterior, Lateral, Septal, Free. It depends what week do you add
% 5, 12, 20, 25 or 1 for all weeks.
%
% OUTPUT-------------------------------------------------------------------
%
% db            <struct> returns datasets of normalized numerical values
% sGroupLabel   <table>  returns column of labels
% sVariableName <struct> returns datasets of cell array for variable names
%
% INPUT--------------------------------------------------------------------
%
% nDbName       <numeral> gets 1, 5, 12, 20, 25 for respective week; 1 for
%                         all;
% Type <string> 'Class' or 'Reg'
%
% EXAMPLES-----------------------------------------------------------------
%
% [db5week, sGroupLabel5week, sVariableName] = pullData(5);
% [dbAll, sGroupLabelAll, sVariableName] = pullData(1);
%
% REFERENCES---------------------------------------------------------------
%
% See <a href="https://bit.ly/35QCmP9">table</a>, <a href="https://bit.ly/38TahZG">horzcat</a>

% Edit AK-AJD(c) 01-17-2021

switch nDbName
    case 5
        load saved_data/w5new
        dbAllCardiacData = AllCardiacData5;
    case 12
        load saved_data/w12new
        dbAllCardiacData = AllCardiacData12;
    case 20
        load saved_data/w20new
        dbAllCardiacData = AllCardiacData20;
    case 25
        load saved_data/w25new
        dbAllCardiacData = AllCardiacData25;
    otherwise
        load saved_data/allwnew
        dbAllCardiacData = AllCardiacDataAll;
end

if Type == "Class"
    % Set GroupLabel
    sGroupLabel = table2array(dbAllCardiacData(:, 2));
    
    % Data separation into datasets
    db.Complete = dbAllCardiacData(:, 4:end);
    db.PWD = dbAllCardiacData(:, 4:12);
    db.Mmode = dbAllCardiacData(:, 13:26);
    
elseif Type == "Reg"
    
    % Set GroupLabel
    sGroupLabel = table2array(dbAllCardiacData(:, 19));
    
    % 19 - EF
    % 20 - FS
    % Data separation into datasets
    db.Complete = dbAllCardiacData(:, [4:18, 20:end]);
    db.PWD = dbAllCardiacData(:, 4:12);
    db.Mmode = dbAllCardiacData(:, [13:18, 20:26]);
    
end

db.Global = dbAllCardiacData(:, 27:59);
db.Global = renamevars(db.Global, 'CDGCircDisplacement', 'SDGCircDisplacement');

skipCol = 5;  % number of skipped columns
addCol  = 5;  % number of added columns
j       = 60; % start of column for Segmental

db.Segmental = table(); db.Anterior = table();  db.Posterior = table();
db.Septal = table();    db.Free = table();

iDbName = {'Anterior', 'Posterior', 'Septal', 'Free'};

while j <= width(dbAllCardiacData)
    nColumns = dbAllCardiacData(:, j:j+addCol);
    db.Segmental = horzcat(db.Segmental, nColumns);
    i = 1;
    for k=j+addCol+1:j+addCol+skipCol-1
        if k > width(dbAllCardiacData)
            break;
        end
        nColumn = dbAllCardiacData(:, k);
        db.(iDbName{i}) = horzcat(db.(iDbName{i}), nColumn);
        i = i + 1;
    end
    j = j + addCol + skipCol;
end


%% Convert to numerical array

dbLabels = fieldnames(db);
for i=1:size(dbLabels, 1)
    sVariableName.(dbLabels{i}) = db.(dbLabels{i}).Properties.VariableNames;
    db.(dbLabels{i}) = table2array(db.(dbLabels{i}));
    % Normalize
    db.(dbLabels{i}) = normalize(db.(dbLabels{i}),'range');
end

end