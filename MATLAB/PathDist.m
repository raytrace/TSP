function [PDist] = PathDist(Nodes,Path,ClosedFlag)

% calculate path distance
if ClosedFlag
    PDist = norm([Nodes.X(Path(end)) Nodes.Y(Path(end))] - [Nodes.X(Path(1)) Nodes.Y(Path(1))]);
else
    PDist = 0;
end

for i=1:length(Path)-1
    PDist = PDist + norm([Nodes.X(Path(i)) Nodes.Y(Path(i))] - [Nodes.X(Path(i+1)) Nodes.Y(Path(i+1))]);
end
