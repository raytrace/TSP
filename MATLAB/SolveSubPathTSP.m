function [Path] =  SolveSubPathTSP(ClusterPath,ClusterMap,Nodes)
% given a master path and cluster map, build a new path for the unclustered nodes

% do forward and reverse paths
FPath = SolverTSP(ClusterPath,ClusterMap,Nodes);
RPath = SolverTSP(flipud(fliplr(ClusterPath)),ClusterMap,Nodes);

% set the same start node
RPath = flipud(fliplr(RPath));
for idx=1:length(RPath),
    if FPath(idx) == RPath(idx), break; end
end
FPath = FPath([idx:length(FPath) 1:idx-1]);
RPath = RPath([idx:length(RPath) 1:idx-1]);

% combine the two paths
Path = zeros(size(FPath));
i = 1;
while i <= length(Path)
    if FPath(i) == RPath(i), Path(i) = FPath(i); i = i + 1; continue; end % paths match
    
    for j=i+1:length(Path)
        if FPath(j)==RPath(j), break; end % paths merge again
    end
    
    % get the distances of these segments
    FDist = norm([Nodes.X(FPath(i-1)) Nodes.Y(FPath(i-1))] - [Nodes.X(FPath(i)) Nodes.Y(FPath(i))]);
    RDist = norm([Nodes.X(RPath(i-1)) Nodes.Y(RPath(i-1))] - [Nodes.X(RPath(i)) Nodes.Y(RPath(i))]);
    for x=i:j-1
        FDist = FDist + norm([Nodes.X(FPath(x)) Nodes.Y(FPath(x))] - [Nodes.X(FPath(x+1)) Nodes.Y(FPath(x+1))]);
        RDist = RDist + norm([Nodes.X(RPath(x)) Nodes.Y(RPath(x))] - [Nodes.X(RPath(x+1)) Nodes.Y(RPath(x+1))]);
    end
    if j==length(Path) & FPath(end) ~= RPath(end), % add edge to start node
        FDist = FDist + norm([Nodes.X(FPath(end)) Nodes.Y(FPath(end))] - [Nodes.X(FPath(1)) Nodes.Y(FPath(1))]);
        RDist = RDist + norm([Nodes.X(RPath(end)) Nodes.Y(RPath(end))] - [Nodes.X(RPath(1)) Nodes.Y(RPath(1))]);
    end
    if FDist < RDist,
        Path(i:j) = FPath(i:j);
    else
        Path(i:j) = RPath(i:j);
    end
    i = j+1;    
end

return


% %%%% Helper function %%%%
function [Path] = SolverTSP(ClusterPath,ClusterMap,Nodes)

Path = zeros(length(Nodes.ID),1);
pidx = 1;

% do the first four nodes
cclust = ClusterPath(1);
nclust = ClusterPath(2);
cid = Nodes.ID(cclust == ClusterMap)+1;
cx = Nodes.X(cclust == ClusterMap);
cy = Nodes.Y(cclust == ClusterMap);
nid = Nodes.ID(nclust == ClusterMap)+1;
nx = Nodes.X(nclust == ClusterMap);
ny = Nodes.Y(nclust == ClusterMap);
mindist = Inf;
for cd=1:length(cx)
    for nd=1:length(nx)
        d = norm([cx(cd) cy(cd)] - [nx(nd) ny(nd)]);
        if d < mindist,
            cdmin = cd; ndmin = nd; mindist = d;
        end
    end
end

if length(cid) == 1,
    Path(pidx) = cid; pidx = pidx + 1;
else
    if cdmin == 1,
        Path(pidx:pidx+1) = cid([2 1]);
    else
        Path(pidx:pidx+1) = cid;
    end
    pidx = pidx + 2;
end
if length(nid) == 1,
    Path(pidx) = nid; pidx = pidx + 1;
else
    if ndmin == 1,
        Path(pidx:pidx+1) = nid;
    else
        Path(pidx:pidx+1) = nid([2 1]);
    end
    pidx = pidx + 2;
end
pidx = pidx - 1; % set it to last node in path

% do the remaining nodes
for c=3:length(ClusterPath)
    cnode = Path(pidx);
    cx = Nodes.X(cnode);
    cy = Nodes.Y(cnode);
    
    nid = Nodes.ID(ClusterPath(c) == ClusterMap)+1;
    nx = Nodes.X(ClusterPath(c) == ClusterMap);
    ny = Nodes.Y(ClusterPath(c) == ClusterMap);
    
    if length(nid) == 1,
        Path(pidx+1) = nid; pidx = pidx + 1;
        continue;
    end
    
    d1 = norm([cx cy] - [nx(1) ny(1)]);
    d2 = norm([cx cy] - [nx(2) ny(2)]);
    
    if d1 < d2,
        Path(pidx+1) = nid(1); Path(pidx+2) = nid(2);
    else
        Path(pidx+1) = nid(2); Path(pidx+2) = nid(1);
    end
    pidx = pidx+2;
end
