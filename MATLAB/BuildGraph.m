function [Nodes] = BuildGraph(CSVFile)
% convert a CSV file with id,x,y columns into Nodes struct

fid = fopen(CSVFile,'r');
matform = textscan(fid,'%s', 'delimiter', '\n');
matform = matform{1,1};
fclose(fid);

header = matform(1);
header = textscan(header{1,1},'%s','delimiter',',');
header = header{1,1};

Nodes = [];
Nodes.ID = zeros(length(matform)-1,1);
Nodes.X = zeros(length(matform)-1,1);
Nodes.Y = zeros(length(matform)-1,1);

for i=2:length(matform) % skip header row
    strs = textscan(matform{i},'%s','delimiter',',');
    strs = strs{1,1};
     
    Nodes.ID(i-1) = str2double(strs(1));
    Nodes.X(i-1) = str2double(strs(2));
    Nodes.Y(i-1) = str2double(strs(3));
end
