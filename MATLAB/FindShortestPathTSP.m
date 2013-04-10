function [Path] = FindShortestPath(Nodes)
% find shortest path

NNodes = length(Nodes.ID);

if NNodes > 8,
    fprintf(1,'Error: problem size out of range! max 9.\n');
    Path = []; return;
end

% find all possible paths
PossPaths = perms(2:NNodes);
PossPaths = PossPaths(PossPaths(:,1) < NNodes,:); % remove some (but not all) duplicate paths
PossPaths = PossPaths(PossPaths(:,end) > 2,:); % remove some (but not all) duplicate paths
NPaths = size(PossPaths,1);

% remove duplicate paths
DupFlag = zeros(NPaths,1);
for i=1:NPaths
    if DupFlag(i) == 1, continue; end
    path = fliplr(PossPaths(i,:));
    for j=i+1:NPaths
        if sum(path == PossPaths(j,:)) == NNodes-1, % same path, just flipped
            DupFlag(j) = 1;
            break;
        end
    end
end

PossPaths = PossPaths(DupFlag==0,:);
NPaths = size(PossPaths,1);
PossPaths = [ones(NPaths,1) PossPaths]; % always start at node 1

Dists = zeros(NNodes,NNodes);
for i=1:NNodes-1
    Dists(i,i) = Inf;
    for j=i+1:NNodes
        d = norm([Nodes.X(i) Nodes.Y(i)] - [Nodes.X(j) Nodes.Y(j)]);
        Dists(i,j) = d; Dists(j,i) = d;
    end
end
Dists(end,end) = Inf;

PathDist = zeros(NPaths,1);
for i=1:NPaths
    path = PossPaths(i,:);
    for j=1:NNodes-1
        PathDist(i) = PathDist(i) + Dists(path(j),path(j+1));
    end
    PathDist(i) = PathDist(i) + Dists(path(1),path(end));
end

% find path with shortest length
[MinDist,MinPath] = min(PathDist);

% rearrange the node order back to original order
Path = PossPaths(MinPath,:);
