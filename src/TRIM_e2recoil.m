function [E2RECOIL,Headers] = TRIM_e2recoil(filename)
%TRIM_E2RECOIL Import numeric data from a text file as a matrix.
%   E2RECOIL = TRIM_e2recoil(FILENAME) Reads data from text file FILENAME for
%   the default selection.
%
%   E2RECOIL = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows
%   STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   E2RECOIL = importfile('E2RECOIL.txt');
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2015/07/13 17:29:00
% Heavily adapted by Pieter.

%% Initialize variables.
Nrows = numel(textread(filename,'%1c%*[^\n]'));
    startRow = Nrows-99;
    endRow = Nrows;
    testRow = Nrows-103;
    headerRow = Nrows-103;
    
    % This section is to handle reading when the number of elements is
    % varying.
    fileID = fopen(filename,'r');
    D = textscan(fileID, '%s', 1, 'delimiter', '\n', 'headerlines', testRow-1);
    D2 = textscan(fileID, '%s', 1, 'delimiter', '\n', 'headerlines', 1);
    header = D2{1,1}{1,1};
    C = strsplit(header,'by ');
    C{1} =  ['Ions'];
    C = ['Ang.',C]
    Headers= cellfun(@strtrim,C,'UniformOutput',false)


    L = length(D{1,1}{1,1}); %WHY would matlab make a cell inside a cell in beyond me but it has so this is the solution to this problem.
    n = (L -27 + 3 )/ 13 + 1 ;

% uses the above to generate the correct reading to read in ancy size file.
 formatSpec= strcat('%11f', repmat('%13f', [1, n]),'%[^\n\r]');
 fclose(fileID);
 
 
 fileID = fopen(filename,'r');


% Original used, 
%formatSpec = '%11f%13f%13f%13f%13f%13f%13f%13f%13f%13f%13f%13f%13f%[^\n\r]';

fclose(fileID);



fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', '', 'WhiteSpace', '', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', '', 'WhiteSpace', '', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

fclose(fileID);

E2RECOIL = [dataArray{1:end-1}];
